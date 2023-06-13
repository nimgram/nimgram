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

import std / asyncdispatch


type
  ConnectionType* = enum
    TCPAbridged,
    TCPIntermediate,
    #Dummy
  
  NetworkInterface* = object
    connect*: proc(self: MTProtoNetwork) {.async.}
    write*: proc(self: MTProtoNetwork, data: seq[uint8]) {.async.}
    receive*: proc(self: MTProtoNetwork): Future[seq[uint8]] {.async.}
    isClosed*: proc(self: MTProtoNetwork): Future[bool] {.async.}
    close*: proc(self: MTProtoNetwork) {.async.}
    reopen*: proc(self: MTProtoNetwork) {.async.}

  MTProtoNetwork* = ref object of RootObj
    procs*: NetworkInterface


proc connect*(self: MTProtoNetwork) {.async.} =
  await self.procs.connect(self)

proc write*(self: MTProtoNetwork, data: seq[uint8]) {.async.} =
  await self.procs.write(self, data)

proc receive*(self: MTProtoNetwork): Future[seq[uint8]] {.async.} =
  return await self.procs.receive(self)

proc isClosed*(self: MTProtoNetwork): Future[bool] {.async.} =
  return await self.procs.isClosed(self)

proc close*(self: MTProtoNetwork) {.async.} =
  await self.procs.close(self)

proc reopen*(self: MTProtoNetwork) {.async.} =
  await self.procs.reopen(self)
