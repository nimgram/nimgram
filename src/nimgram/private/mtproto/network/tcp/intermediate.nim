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

import std / [asyncdispatch, asyncnet],
  pkg / tltypes / [encode, decode],
  .. / transports


type MTProtoIntermediate* = ref object of MTProtoNetwork
  ## Implementation of the Intermediate TCP transport.
  ## https://core.telegram.org/mtproto/mtproto-transports#intermediate

  socket: AsyncSocket
  address: string
  port: Port


proc connectIntermediate(self: MTProtoNetwork) {.async.} =
  ## Connect to the address specified during initialization
  self.MTProtoIntermediate.socket = await asyncnet.dial(
      self.MTProtoIntermediate.address, self.MTProtoIntermediate.port)
  await self.MTProtoIntermediate.socket.send("\xEE\xEE\xEE\xEE")


proc writeIntermediate(self: MTProtoNetwork, data: seq[uint8]) {.async.} =
  ## Write specified data to the socket
  await self.MTProtoIntermediate.socket.send(cast[string](TLEncode(uint32(len(
      data))) & data))


proc receiveIntermediate(self: MTProtoNetwork): Future[seq[uint8]] {.async.} =
  ## Receive data from the socket
  let length = TLDecode[uint32](newTLStream(
      cast[seq[uint8]](await self.MTProtoIntermediate.socket.recv(4))))

  return cast[seq[uint8]](
    await self.MTProtoIntermediate.socket.recv(int(length))
  )

proc isClosedIntermediate(self: MTProtoNetwork): Future[bool] {.async.} =
  ## Check if the socket is closed
  return self.MTProtoIntermediate.socket.isClosed()


proc closeIntermediate(self: MTProtoNetwork) {.async.} =
  ## Close the connection on the socket
  self.MTProtoIntermediate.socket.close()


proc reopenIntermediate(self: MTProtoNetwork) {.async.} =
  ## Alias of connect
  await connectIntermediate(self)


proc newIntermediate*(address: string, port: Port): MTProtoIntermediate =
  ## Initialize a new connection using the Intermediate transport
  return MTProtoIntermediate(
    address: address,
    port: port,
    procs: NetworkInterface(
      connect: connectIntermediate,
      write: writeIntermediate,
      receive: receiveIntermediate,
      isClosed: isClosedIntermediate,
      close: closeIntermediate,
      reopen: reopenIntermediate,
    )
  )
