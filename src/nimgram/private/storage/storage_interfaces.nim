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

import std/asyncdispatch
import std/options

type
  StorageInterface* = object
    addOrEditSession*: proc(self: NimgramStorage, dcId: int, isTestMode: bool, isMedia: bool, authKey: seq[uint8], salt: int64, default: Option[bool]): Future[void] {.async.}
    getSession*: proc(self: NimgramStorage, dcId: int, isTestMode: bool, isMedia: bool): Future[(seq[uint8], int64)] {.async.}
    getDefaultSession*: proc(self: NimgramStorage): Future[(int, bool, bool, seq[uint8], int64)] {.async.}
    clearCache*: proc(self: NimgramStorage) {.async.} 
    addOrEditPeer*: proc(self: NimgramStorage, peerId: int64, accessHash: int64, username: string) {.async.}
    getPeer*: proc(self: NimgramStorage, id: int64): Future[(int64, Option[string])] {.async.}
    getPeerByUsername*: proc(self: NimgramStorage, username: string): Future[(int64, int64)] {.async.}
    close*: proc(self: NimgramStorage) {.async.}
  NimgramStorage* = ref object of RootObj
    procs*: StorageInterface

proc addOrEditSession*(self: NimgramStorage, dcId: int, isTestMode: bool, isMedia: bool, authKey: seq[uint8], salt: int64, default: Option[bool] = none(bool)): Future[void] {.async.} =
  await self.procs.addOrEditSession(self, dcId, isTestMode, isMedia, authKey, salt, default)

proc getSession*(self: NimgramStorage, dcId: int, isTestMode: bool, isMedia: bool): Future[(seq[uint8], int64)] {.async.} =
  return await self.procs.getSession(self, dcId, isTestMode, isMedia)

proc getDefaultSession*(self: NimgramStorage): Future[(int, bool, bool, seq[uint8], int64)] {.async.} =
  return await self.procs.getDefaultSession(self)

proc clearCache*(self: NimgramStorage) {.async.} =
  await self.procs.clearCache(self)

proc addOrEditPeer*(self: NimgramStorage, peerId: int64, accessHash: int64, username = ""): Future[void] {.async.} =
  await self.procs.addOrEditPeer(self, peerId, accessHash, username)

proc getPeer*(self: NimgramStorage, id: int64): Future[(int64, Option[string])] {.async.} =
  return await self.procs.getPeer(self, id)

proc getPeer*(self: NimgramStorage, username: string): Future[(int64, int64)] {.async.} =
  return await self.procs.getPeerByUsername(self, username)

proc close*(self: NimgramStorage) {.async.} =
  await self.procs.close(self)