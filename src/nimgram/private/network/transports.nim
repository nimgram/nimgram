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
import endians
import asyncnet

proc toBytes*(x: uint32) : array[0..3, uint8] =
    if cpuEndian != littleEndian:
        var tempResult = cast[array[0..3, uint8]](x) 
        swapEndian32(addr result, addr tempResult[0])
    result = cast[array[0..3, uint8]](x)


type NetworkTypes* = enum
    NetTcpAbridged
    NetTcpIntermediate

type MTProtoNetwork* = ref object
    socket*: AsyncSocket
    address*: string
    port*: uint16
    write*: proc (self: MTProtoNetwork, data: seq[uint8]) {.async.}
    receive*: proc (self: MTProtoNetwork):  Future[seq[uint8]]  {.async.}
    isClosed*: proc (self: MTProtoNetwork): bool
    close*: proc (self: MTProtoNetwork) {.locks: "unknown".}
    reopen*: proc (self: MTProtoNetwork) {.async.}



