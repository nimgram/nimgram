# Nimgram
# Copyright (C) 2020-2021 Daniele Cortesi <https://github.com/dadadani>
# This file is part of Nimgram, under the MIT License
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY
# OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import asyncdispatch
import tables
import strutils
# If threads are enabled, we can use Sqlite (compile time)
when compileOption("threads"):
    import strformat
    import utils/sqlite
    import db_sqlite
    import base64
import utils/binmanager
import shared 

type NimgramStorageConfig* = ref object of RootObj

type NimgramStorageConfigRam* = ref object of NimgramStorageConfig
    binfilename*: string

when compileOption("threads"):
    type NimgramStorageConfigSqlite* = ref object of NimgramStorageConfig
        filename*: string
        disableCache*: bool #By enabling this, cache in ram will be not used, increasing disk usage

type NimgramStorage* = ref object of RootObj

## Storage using ram: Saves information on ram
## This might be helpful when creating scalable instances saving disk usage
## with the disavantage of consuming more ram over time. 
## If you want to clear saved information, use the clearCache method
type NimgramStorageRam* = ref object of NimgramStorage
    binFileName: string
    peerStorage: Table[int64, StoragePeer]
    
when compileOption("threads"):
    ## Storage using sqlite: Saves information on file database (sqlite)
    ## Saved information are permanent, since are written on disk.
    ## By default, cache in ram is used to use less storage usage, can be disabled on config
    ## To use this type of storage, threads need to be enabled (use --threads:on on the Nim compiler)
    type NimgramStorageSqlite* = ref object of NimgramStorage
        disableCache: bool
        cache: Table[int64, StoragePeer]
        sqliteInstance: SqlManager


proc init*(self: NimgramStorageRam, config: NimgramStorageConfig) = 
    doAssert config of NimgramStorageConfigRam, "Expecting config of type NimgramStorageRam"

    var ramConfig = config.NimgramStorageConfigRam
    self.binFileName = ramConfig.binfilename

proc writeSessionsInfo*(self: NimgramStorageRam, dcOptions: Table[int, DcOption]) {.async.} = 
    await writeBin(self.binFileName, dcOptions)

proc clearCache*(self: NimgramStorageRam) = self.peerStorage.clear()

proc getSessionsInfo*(self: NimgramStorageRam): Future[Table[int, DcOption]] {.async.} = 
    return await loadBin(self.binFileName)

proc addPeer*(self: NimgramStorageRam, user: StoragePeer) {.async.} =
    self.peerStorage[user.peerID] = user

proc getPeer*(self: NimgramStorageRam, user: int64): Future[StoragePeer] {.async.} = 
    return self.peerStorage[user]

when compileOption("threads"):
    proc init*(self: NimgramStorageSqlite, config: NimgramStorageConfig) = 
        doAssert config of NimgramStorageConfigSqlite, "Expecting config of type NimgramStorageSqlite"

        var sqliteConfig = config.NimgramStorageConfigSqlite
        self.disableCache = sqliteConfig.disableCache
        self.sqliteInstance = initSqlite(sqliteConfig.filename)

    proc writeSessionsInfo*(self: NimgramStorageSqlite, dcOptions: Table[int, DcOption]) {.async.} =
        await self.sqliteInstance.exec(sql("DELETE from dcoptions;"))
        var query = ""
        for _, key in dcOptions:
            var isAuthorized = "0"
            if key.isAuthorized:
                isAuthorized = "1"
            var isMain = "0"
            if key.isMain:
                isMain = "1"
            var authKey = encode(key.authKey)
            var salt = encode(key.salt)
            await self.sqliteInstance.exec(sql(&"INSERT INTO dcoptions (number, isAuthorized, isMain, authKey, salt) VALUES ({key.number}, {isAuthorized}, {isMain}, '{authKey}', '{salt}');"))

    proc addPeer*(self: NimgramStorageSqlite, user: StoragePeer) {.async.} =
        await self.sqliteInstance.exec(sql(&"INSERT INTO peerdata(id, access_hash) VALUES({user.peerID}, '{user.accessHash}') ON CONFLICT(id) DO UPDATE SET access_hash='{user.accessHash}';"))
        if not self.disableCache: 
            #TODO: maybe add cache auto clean if we reach many chats stored?
            self.cache[user.peerID] = user

    proc getPeer*(self: NimgramStorageSqlite, user: int64): Future[StoragePeer] {.async.} =
        if not self.disableCache and self.cache.contains(user):
            return self.cache[user]
        var row = await self.sqliteInstance.getRow(sql(&"select access_hash from peerdata where id = {user}"))
        return StoragePeer(peerID: user, accessHash: row[0].parseBiggestInt)

    proc clearCache*(self: NimgramStorageSqlite) = 
        self.cache.clear()

    proc getSessionsInfo*(self: NimgramStorageSqlite): Future[Table[int, DcOption]] {.async.} =
        var rows = await self.sqliteInstance.getAllRows(sql("SELECT number, isAuthorized, isMain, authKey, salt FROM dcoptions"))
        for row in rows:
            var number = parseInt(row[0]).uint16
            var isAuthorized = if row[1] == "1": true else: false
            var isMain = if row[2] == "1": true else: false
            var authKey = cast[seq[uint8]](decode(row[3]))
            var salt = cast[seq[uint8]](decode(row[4]))
            result[int(number)] = DcOption(number: number, isAuthorized: isAuthorized, isMain: isMain, authKey: authKey, salt: salt)


proc init*(self: NimgramStorage, config: NimgramStorageConfig) = 
    when compileOption("threads"):
        if self of NimgramStorageSqlite:
            self.NimgramStorageSqlite.init(config)
            return
    if self of NimgramStorageRam:
        self.NimgramStorageRam.init(config)
        return
    raise newException(CatchableError, "Unable to resolve type")

proc writeSessionsInfo*(self: NimgramStorage, dcOptions: Table[int, DcOption]) {.async.} =
    when compileOption("threads"):
        if self of NimgramStorageSqlite:
            await self.NimgramStorageSqlite.writeSessionsInfo(dcOptions)
            return
    if self of NimgramStorageRam:
        await self.NimgramStorageRam.writeSessionsInfo(dcOptions)
        return
    raise newException(CatchableError, "Unable to resolve type")


proc clearCache*(self: NimgramStorage) = 
    when compileOption("threads"):
        if self of NimgramStorageSqlite:
            self.NimgramStorageSqlite.clearCache()
            return
    if self of NimgramStorageRam:
        self.NimgramStorageRam.clearCache()
        return
    raise newException(CatchableError, "Unable to resolve type")


proc getSessionsInfo*(self: NimgramStorage): Future[Table[int, DcOption]] {.async.} = 
    when compileOption("threads"):
        if self of NimgramStorageSqlite:
            return await returnself.NimgramStorageSqlite.getSessionsInfo()
            
    if self of NimgramStorageRam:
        return await self.NimgramStorageRam.getSessionsInfo()
    raise newException(CatchableError, "Unable to resolve type")
   


proc addPeer*(self: NimgramStorage, user: StoragePeer) {.async.} =
    when compileOption("threads"):
        if self of NimgramStorageSqlite:
            self.NimgramStorageSqlite.addPeer(user)
            return
    if self of NimgramStorageRam:
        await self.NimgramStorageRam.addPeer(user)
        return
    raise newException(CatchableError, "Unable to resolve type")

proc getPeer*(self: NimgramStorage, user: int64): Future[StoragePeer] {.async.} = 
    when compileOption("threads"):
        if self of NimgramStorageSqlite:
            return await returnself.NimgramStorageSqlite.getPeer(user)
            
    if self of NimgramStorageRam:
        return await self.NimgramStorageRam.getPeer(user)
    raise newException(CatchableError, "Unable to resolve type")
