# Nimgram
# Copyright (C) 2020-2023 Daniele Cortesi <https://github.com/dadadani>
# This file is part of Nimgram, under the MIT License
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

## An sqlite interface to StorageInterface

import storage_interfaces
import std/[options, base64, asyncdispatch]
import std/strutils

import pkg/db_connector/db_sqlite

type SqliteStorage* = ref object of NimgramStorage
    database: DbConn


proc addOrEditSessionS(self: NimgramStorage, dcId: int, isTestMode: bool, isMedia: bool, authKey: seq[uint8], salt: int64, default: Option[bool]) {.async.} =
    if self.SqliteStorage.database.getRow(sql"SELECT 1 FROM sessions WHERE dcId = ? AND isMedia = ? AND isTestMode = ?", dcId, if isMedia: "1" else: "0", if isTestMode: "1" else: "0")[0] == "1":
        if default.isSome:
            self.SqliteStorage.database.exec(sql"UPDATE sessions SET authKey = ?, salt = ?, isDefault = ? WHERE dcId = ? AND isMedia = ? AND isTestMode = ?", encode(authKey), salt, if default.get: "1" else: "0", dcId, if isMedia: "1" else: "0", if isTestMode: "1" else: "0")
        else:
            self.SqliteStorage.database.exec(sql"UPDATE sessions SET authKey = ?, salt = ? WHERE dcId = ? AND isMedia = ? AND isTestMode = ?", encode(authKey), salt,dcId, if isMedia: "1" else: "0", if isTestMode: "1" else: "0")
    else:
        self.SqliteStorage.database.exec(sql"INSERT INTO sessions (dcId, authKey, salt, isMedia, isTestMode, isDefault) VALUES (?, ?, ?, ?, ?, ?)", dcId, encode(authKey), salt, if isMedia: "1" else: "0", if isTestMode: "1" else: "0", if default.isSome and default.get: "1" else: "0")

proc getSessionS(self: NimgramStorage, dcId: int, isTestMode: bool, isMedia: bool): Future[(seq[uint8], int64)] {.async.} = 
    let row = self.SqliteStorage.database.getRow(sql"SELECT authKey, salt from sessions WHERE dcId = ? AND isMedia = ? AND isTestMode = ?", dcId, if isMedia: "1" else: "0", if isTestMode: "1" else: "0") 

    if row.len > 0 and row[0] != "": 
        result[0] = cast[seq[uint8]](decode(row[0]))
        result[1] = parseBiggestInt(row[1])
    else:
        raise newException(DbError, "Unable to find session")

proc getDefaultSessionS(self: NimgramStorage): Future[(int, bool, bool, seq[uint8], int64)] {.async.} = 
    let row = self.SqliteStorage.database.getRow(sql"SELECT dcId, authKey, salt, isMedia, isTestMode from sessions WHERE isDefault > 0")
    if row.len > 0 and row[0] != "":
        result[0] = parseInt(row[0])
        result[1] = if parseInt(row[4]) > 0: true else: false
        result[2] = if parseInt(row[3]) > 0: true else: false
        result[3] = cast[seq[uint8]](decode(row[1]))
        result[4] = parseBiggestInt(row[2])
    else:
        raise newException(DbError, "Unable to find session")

proc addOrEditPeerS(self: NimgramStorage, peerID: int64, accessHash: int64, username = "") {.async.} =
    if self.SqliteStorage.database.getRow(sql"SELECT 1 FROM peers WHERE peerId = ?", peerId)[0] == "1":
        if username.len > 1:
            self.SqliteStorage.database.exec(sql"UPDATE peers SET accessHash = ?, username = ? WHERE peerID = ?", accessHash, if username == "rm": "" else: username, peerID)
        else:
            self.SqliteStorage.database.exec(sql"UPDATE peers SET accessHash = ? WHERE peerID = ?", accessHash, peerID)
    else:
        if username.len > 1:
            self.SqliteStorage.database.exec(sql"INSERT INTO peers (peerID, accessHash, username) VALUES (?, ?, ?)", peerID, accessHash, username)
        else:
            self.SqliteStorage.database.exec(sql"INSERT INTO peers (peerID, accessHash) VALUES (?, ?)", peerID, accessHash)            

proc getPeerS(self: NimgramStorage, peerID: int64): Future[(int64, Option[string])] {.async.} = 
    let row = self.SqliteStorage.database.getRow(sql"SELECT accessHash, username FROM peers WHERE peerID = ?", peerID)
    if row.len >= 1 and row[0] != "":
        result[0] = parseBiggestInt(row[0])
        if row.len >= 2 and row[1] != "":
            result[1] = some(row[1])
    else:
        raise newException(DbError, "Unable to find user")

proc getPeerByUsernameS(self: NimgramStorage, username: string): Future[(int64, int64)] {.async.} = 
    let row = self.SqliteStorage.database.getRow(sql"SELECT peerID, accessHash FROM peers WHERE username = ?", username)
    if row.len == 2 and row[0] != "":
        result[0] = parseBiggestInt(row[0])
        result[1] = parseBiggestInt(row[1])
    else:
        raise newException(DbError, "Unable to find user")

proc clearCacheS(self: NimgramStorage) {.async.} =
    # TODO: IMPLEMENT CACHE
    discard

proc closeS(self: NimgramStorage) {.async.} =
    self.SqliteStorage.database.close()

proc newSqliteStorage*(filename: string): SqliteStorage =
    result = SqliteStorage(database: open(filename, "", "", ""),
    procs: StorageInterface(
        addOrEditSession: addOrEditSessionS,
        getSession: getSessionS,
        addOrEditPeer: addOrEditPeerS,
        getPeer: getPeerS,
        getPeerByUsername: getPeerByUsernameS,
        getDefaultSession: getDefaultSessionS,
        clearCache: clearCacheS,
        close: closeS
    ))  
    result.database.exec(sql"CREATE TABLE IF NOT EXISTS sessions(id INTEGER NOT NULL PRIMARY KEY, dcId INTEGER NOT NULL, authKey TEXT NOT NULL, salt INTEGER NOT NULL, isMedia INTEGER NOT NULL, isTestMode INTEGER NOT NULL, isDefault INTEGER NOT NULL, UNIQUE(dcId, isMedia, isTestMode))")
    result.database.exec(sql"CREATE TABLE IF NOT EXISTS peers(peerID INTEGER NOT NULL PRIMARY KEY, accessHash INTEGER NOT NULL, username TEXT UNIQUE)")
    #result.database.createTables(SessionDataSqlite())
    #result.database.createTables(StoragePeerSqlite())

