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
import ../../rpc/decoding
import ../../rpc/encoding
#[
Intermediate
In case 4-byte data alignment is needed, an intermediate version of the original protocol may be used.

Overhead: small
Minimum envelope length: 4 bytes
Maximum envelope length: 4 bytes
Payload structure:

+----+----...----+
+len.+  payload  +
+----+----...----+
]#

proc connect*(self: MTProtoNetwork, address: string, port: uint16) {.async.} =
    self.socket = await asyncnet.dial(address, cast[Port](port))
    await self.socket.send("\xEE\xEE\xEE\xEE")
    self.address = address
    self.port = port
    
proc write*(self: MTProtoNetwork, data: seq[uint8]) {.async.} = 
    await self.socket.send(cast[string](TLEncode(uint32(len(data))) & data))

proc receive*(self: MTProtoNetwork): Future[seq[uint8]] {.async.} = 
    var lenght: uint32
    var lenghtBytes = cast[seq[uint8]](await self.socket.recv(4))
    var reader = newScalingSeq(lenghtBytes)
    reader.TLDecode(addr lenght)
    result = cast[seq[uint8]](await self.socket.recv(int32(lenght)))

proc isClosed*(self: MTProtoNetwork): bool = self.socket.isClosed()

proc close*(self: MTProtoNetwork) = self.socket.close()


proc reopen*(self: MTProtoNetwork) {.async.} = 
    self.socket = await asyncnet.dial(self.address, self.port.Port)
    await self.socket.send("\xEE\xEE\xEE\xEE")
