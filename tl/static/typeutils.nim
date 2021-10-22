
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

import options
import encoding
import decoding
import strformat
import stint
import zippy

type TL* = ref object of RootObj

type TLObject* = ref object of TL

type TLFunction* = ref object of TL

proc TLEncode*(self: TL): seq[uint8] 

proc TLEncode*(self: seq[TL]): seq[uint8] 

proc TLDecode*(self: var TL, bytes: var ScalingSeq[uint8])    

proc TLDecode*(self: var seq[TL], bytes: var ScalingSeq[uint8])
    

type GZipPacked* = ref object of TLObject
        body*: TL
        

type 
    RPCException* = ref object of CatchableError
        errorCode* : int32
        errorMessage*: string

    FutureSalt* = ref object of TLObject
        validSince*: int32
        validUntil*: int32
        salt*: uint64
    FutureSalts* = ref object of TLObject
        reqMsgID*: uint64
        now*: int32
        salts*: seq[FutureSalt]
    CoreMessage* = ref object
        msgID*: uint64 
        seqNo*: uint32
        lenght*: uint32
        body*: TL
    TLTrue* = ref object of TLObject
    TLFalse* = ref object of TLObject

    MessageContainer* = ref object of TLObject
        messages*: seq[CoreMessage]

proc TLEncode*(self: CoreMessage): seq[uint8] =
    result.add(self.msgID.TLEncode())
    result.add(self.seqNo.TLEncode())
    var body = TLEncode(self.body)
    result.add(TLEncode(uint32(len(body)))) 
    result.add(body)

proc TLDecode*(self: CoreMessage, bytes: var ScalingSeq[uint8])

proc TLDecode*(self: CoreMessage, bytes: var ScalingSeq[uint8]) =
    bytes.TLDecode(addr self.msgID)
    bytes.TLDecode(addr self.seqNo)
    bytes.TLDecode(addr self.lenght)
    var objectBytes = newScalingSeq(bytes.readN(int(self.lenght)))
    self.body.TLDecode(objectBytes)

include types/base
include functions/base
include core/types/base
include core/functions/base

proc TLEncode(self: seq[TL]): seq[uint8] =
    result.add(TLEncode(uint32(481674261)))
    result.add(TLEncode(uint32(self.len)))
    for obj in self:
        result.add(obj.TLEncode())

proc TLDecode*(self: var seq[TL], bytes: var ScalingSeq[uint8]) =
    var id: uint32
    bytes.TLDecode(addr id)
    var lenght: int32
    bytes.TLDecode(addr lenght)
    for i in countup(1, lenght):
        var obj = new TL

        obj.TLDecode(bytes)
        self.add(obj)


proc seqNo*(self: TL, currentInt: int): int =
    var related = 1
    if self of MessageContainer or self of Ping or self of Msgs_ack:
        related = 0
    var seqno = currentInt + abs(2 * not related)
    return seqno
