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

import std / [asyncdispatch, asyncnet],
  pkg / tltypes / [encode, decode],
  .. / transports


type MTProtoAbridged* = ref object of MTProtoNetwork
  ## Implementation of the Abridged TCP transport.
  ## https://core.telegram.org/mtproto/mtproto-transports#abridged

  socket: AsyncSocket
  address: string
  port: Port


proc connectAbridged(self: MTProtoNetwork) {.async.} =
  ## Connect to the address specified during initialization
  self.MTProtoAbridged.socket = await asyncnet.dial(
      self.MTProtoAbridged.address, self.MTProtoAbridged.port)
  await self.MTProtoAbridged.socket.send("\xEF")


proc writeAbridged(self: MTProtoNetwork, data: sink seq[uint8]) {.async.} =
  ## Write specified data to the socket
  let length: uint32 = uint32(len(data)) div 4
  if length >= 127:
    await self.MTProtoAbridged.socket.send(cast[string](
      0x7F'u8 &
      TLEncode(length)[0 ..^ 3] &
      data
    ))
  else:
    await self.MTProtoAbridged.socket.send(
      cast[string](uint8(length) & data))


proc receiveAbridged(self: MTProtoNetwork): Future[seq[uint8]] {.async.} =
  ## Receive data from the socket
  var length = int(cast[uint8]((await self.MTProtoAbridged.socket.recv(1))[0]))

  if length == 0x7F:
    length = int(TLDecode[uint32](newTLStream(cast[seq[uint8]](
      await self.MTProtoAbridged.socket.recv(3)) & 0'u8)))

  return cast[seq[uint8]](
    await self.MTProtoAbridged.socket.recv(length * 4)
  )


proc isClosedAbridged(self: MTProtoNetwork): Future[bool] {.async.} =
  ## Check if the socket is closed
  return self.MTProtoAbridged.socket.isClosed()


proc closeAbridged(self: MTProtoNetwork) {.async.} =
  ## Close the connection on the socket
  self.MTProtoAbridged.socket.close()


proc reopenAbridged(self: MTProtoNetwork) {.async.} =
  ## Alias of connect
  await connectAbridged(self)


proc newAbridged*(address: string, port: Port): MTProtoAbridged =
  ## Initialize a new connection using the Abridged transport
  return MTProtoAbridged(
    address: address,
    port: port,
    procs: NetworkInterface(
      connect: connectAbridged,
      write: writeAbridged,
      receive: receiveAbridged,
      isClosed: isClosedAbridged,
      close: closeAbridged,
      reopen: reopenAbridged,
    )
  )
