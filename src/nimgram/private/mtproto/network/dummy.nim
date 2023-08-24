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

import std / [asyncdispatch], transports


type MTProtoDummy* = ref object of MTProtoNetwork
  ## A dummy implementation of MTProtoNetwork, to be used for debugging/unit tests

  incomingBuffer*: seq[uint8]
  outgoingBuffer*: seq[uint8]


proc connectDummy(self: MTProtoNetwork) {.async.} = discard


proc writeServerDummy*(self: MTProtoDummy, data: sink seq[uint8]) =
  ## Write specified data to the socket
  self.incomingBuffer.add(data)

proc receiveServerDummy*(self: MTProtoDummy): seq[uint8] =
  ## Receive data from the socket
  result = self.outgoingBuffer
  self.outgoingBuffer.setLen(0)

proc writeDummy(self: MTProtoNetwork, data: sink seq[uint8]) {.async.} =
  ## Write specified data to the socket
  self.MTProtoDummy.outgoingBuffer.add(data)


proc receiveDummy(self: MTProtoNetwork): Future[seq[uint8]] {.async.} =
  ## Receive data from the socket
  result = self.MTProtoDummy.incomingBuffer
  self.MTProtoDummy.incomingBuffer.setLen(0)

proc isClosedDummy(self: MTProtoNetwork): Future[bool] {.async.} =
  ## Check if the socket is closed
  return false


proc closeDummy(self: MTProtoNetwork) {.async.} = discard


proc reopenDummy(self: MTProtoNetwork) {.async.} = discard


proc newDummy*(): MTProtoDummy =
  ## Initialize a new connection using the Dummy transport
  return MTProtoDummy(
    incomingBuffer: newSeq[uint8](),
    outgoingBuffer: newSeq[uint8](),
    procs: NetworkInterface(
      connect: connectDummy,
      write: writeDummy,
      receive: receiveDummy,
      isClosed: isClosedDummy,
      close: closeDummy,
      reopen: reopenDummy,
    )
  )
