# Nimgram
# Copyright (C) 2020-2022 Daniele Cortesi <https://github.com/dadadani>
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
import std/[options, logging, base64, asyncdispatch]
import norm/[model, sqlite, pragmas]
import logging

type
  SessionDataSqlite {.tableName: "sessions".} = ref object of Model
    dcId* {.uniqueGroup.}: int
    authKey*: string
    salt*: int64
    isMedia* {.uniqueGroup.}: bool
    isTestMode* {.uniqueGroup.}: bool
    isDefault* {.uniqueGroup.}: bool

  StoragePeerSqlite {.tableName: "peers".} = ref object of Model
    peerID {.unique.}: int64
    accessHash: int64
    username {.unique.}: Option[string]

  SqliteStorage* = ref object of NimgramStorage
    database: DbConn


proc addOrEditSessionS(self: NimgramStorage, dcId: int, isTestMode: bool, isMedia: bool, authKey: seq[uint8], salt: int64, default: Option[bool]) {.async.} =
    if self.SqliteStorage.database.exists(SessionDataSqlite, "dcId = ? AND isMedia = ? AND isTestMode = ?", dcId, isMedia, isTestMode):
       if isSome(default):
            self.SqliteStorage.database.exec(sql"UPDATE sessions SET authKey = ?, salt = ?, isDefault = ? WHERE dcId = ? AND isMedia = ? AND isTestMode = ?", encode(authKey), salt, default.get, dcId, isMedia, isTestMode)
       else:
            self.SqliteStorage.database.exec(sql"UPDATE sessions SET authKey = ?, salt = ? WHERE dcId = ? AND isMedia = ? AND isTestMode = ?", encode(authKey), salt, dcId, isMedia, isTestMode)
    else:
        var session = SessionDataSqlite(dcId: dcId, isMedia: isMedia, isTestMode: isTestMode, authKey: encode(authKey), salt: salt, isDefault: if default.isSome: default.get else: false)
        self.SqliteStorage.database.insert(session)

proc getSessionS(self: NimgramStorage, dcId: int, isTestMode: bool, isMedia: bool): Future[(seq[uint8], int64)] {.async.} = 
    var session = SessionDataSqlite()
    self.SqliteStorage.database.select(session, "dcId = ? AND isMedia = ? AND isTestMode = ?", dcId, isMedia, isTestMode)
    result[0] = cast[seq[uint8]](decode(session.authKey))
    result[1] = session.salt

proc getDefaultSessionS(self: NimgramStorage): Future[(int, bool, bool, seq[uint8], int64)] {.async.} = 
    var session = SessionDataSqlite()
    self.SqliteStorage.database.select(session, "isDefault = ?", true)
    result[0] = session.dcId
    result[1] = session.isTestMode
    result[2] = session.isMedia
    result[3] = cast[seq[uint8]](decode(session.authKey))
    result[4] = session.salt

proc addOrEditPeerS(self: NimgramStorage, peerID: int64, accessHash: int64, username = "") {.async.} =
    if self.SqliteStorage.database.exists(StoragePeerSqlite, "peerID = ?", peerID):
       if username.len > 1:
          self.SqliteStorage.database.exec(sql"UPDATE peers SET accessHash = ?, username = ? WHERE peerID = ?", accessHash, if username == "rm": "" else: username, peerID)
       else:
          self.SqliteStorage.database.exec(sql"UPDATE peers SET accessHash = ? WHERE peerID = ?", accessHash, peerID)

    else:
        var session = StoragePeerSqlite(peerID: peerID, accessHash: accessHash, username: (if username.len > 2: some(username) else: none(string)))
        self.SqliteStorage.database.insert(session)

proc getPeerS(self: NimgramStorage, peerID: int64): Future[(int64, Option[string])] {.async.} = 
    var peer = StoragePeerSqlite()
    self.SqliteStorage.database.select(peer, "peerID = ?", peerID)
    result[0] = peer.accessHash
    result[1] = peer.username

proc getPeerByUsernameS(self: NimgramStorage, username: string): Future[(int64, int64)] {.async.} = 
    var peer = StoragePeerSqlite()
    self.SqliteStorage.database.select(peer, "username = ?", username)
    result[0] = peer.peerID
    result[1] = peer.accessHash

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
    result.database.createTables(SessionDataSqlite())
    result.database.createTables(StoragePeerSqlite())

