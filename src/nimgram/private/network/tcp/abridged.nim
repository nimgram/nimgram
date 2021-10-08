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
import asyncnet
import ../transports

#[
Abridged
The lightest protocol available.

Overhead: Very small
Minimum envelope length: 1 byte
Maximum envelope length: 4 bytes
Payload structure:
+-+----...----+
|l|  payload  |
+-+----...----+
OR (if l >= 127)

+-+---+----...----+
|h|len|  payload  +
+-+---+----...----+
]#


proc connect*(self: MTProtoNetwork, address: string, port: uint16) {.async.} =
    self.socket = await asyncnet.dial(address, port.Port)
    await self.socket.send("\xEF")
    self.address = address
    self.port = port

proc write*(self: MTProtoNetwork, data: seq[uint8]) {.async.} = 
    var lenght = uint32(len(data)/4)
    if lenght >= 127:
        await self.socket.send(cast[string](uint8(0x7F) & toBytes(lenght)[0..2] & data))
    else:
        await self.socket.send(cast[string](uint8(lenght) & data))

proc receive*(self: MTProtoNetwork): Future[seq[uint8]] {.async.} = 
    var lenght = cast[seq[uint8]](await self.socket.recv(1))
    var realLenght = 0
    if lenght[0] == 0x7F:
        lenght = cast[seq[uint8]](await self.socket.recv(3))
    copyMem(addr realLenght, addr lenght[0], len(lenght))
    result = cast[seq[uint8]](await self.socket.recv(realLenght * 4))

proc isClosed*(self: MTProtoNetwork): bool = self.socket.isClosed()

proc close*(self: MTProtoNetwork) = self.socket.close()

proc reopen*(self: MTProtoNetwork) {.async.} = 
    self.socket = await asyncnet.dial(self.address, self.port.Port)
    await self.socket.send("\xEF")
