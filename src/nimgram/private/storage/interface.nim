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

import std / asyncdispatch
import std / tables

type
  DcOption* = object
    auth_key: seq[uint8]
    salt: seq[uint8]

  StoragePeer* = object
    peerID*: int64
    accessHash*: int64

  StorageInterface* = object
    getSessions*: proc(self: NimgramStorage): Future[Table[int, DcOption]] {.async.}
    writeSessions*: proc(self: NimgramStorage, sessions: Table[int, DcOption]) {.async.}
    clearCache*: proc(self: NimgramStorage) {.async.}
    addPeer*: proc(self: NimgramStorage, peer: StoragePeer) {.async.}
    getPeer*: proc(self: NimgramStorage, id: int64): Future[StoragePeer] {.async.}

  NimgramStorage* = ref object of RootObj
    procs*: StorageInterface

proc getSessions*(self: NimgramStorage): Future[Table[int, DcOption]] {.async.} =
  return await self.procs.getSessions(self)

proc writeSessions*(self: NimgramStorage, sessions: Table[int, DcOption]) {.async.} =
  await self.procs.writeSessions(self, sessions)

proc addPeer*(self: NimgramStorage, peer: StoragePeer) {.async.} =
  await self.procs.addPeer(self, peer)

proc getPeer*(self: NimgramStorage, id: int64): Future[StoragePeer] {.async.} =
  return await self.procs.getPeer(self, id)
