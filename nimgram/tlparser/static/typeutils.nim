import options
import encoding
import decoding
import strformat
import stint
import zippy

type TL* = ref object of RootObj

type TLObject* = ref object of TL

type TLFunction* = ref object of TL

method getTypeName*(self: TL): string {.base.} = "TL"

method TLEncode*(self: TL): seq[uint8] {.base.} = raise newException(Exception, "Trying to encode a generic object")

proc TLEncode*(self: seq[TL]): seq[uint8]

method getTypeName*(self: TLObject): string = "TLObject"

method getTypeName*(self: TLFunction): string = "TLFunction"

method TLDecode*(self: TL, bytes: var ScalingSeq[uint8]) {.base.} = discard

proc TLDecode*(self: var TL, bytes: var ScalingSeq[uint8])    

proc TLDecode*(self: var seq[TL], bytes: var ScalingSeq[uint8])
    

type GZipPacked* = ref object of TLObject
        body*: TL
        
method getTypeName*(self: GZipPacked): string = "GZipPacked"

method TLEncode*(self: GZipPacked): seq[uint8] =
    result.add(TLEncode(uint32(0x3072CFA1)))
    result.add(TLEncode(compress(self.body.TLEncode())))

method TLDecode*(self: GZipPacked, bytes: var ScalingSeq[uint8]) =
    var data = newScalingSeq(uncompress(bytes.TLDecode()))
    self.body.TLDecode(data)

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
    MessageContainer* = ref object of TLObject
        messages*: seq[CoreMessage]

method getTypeName*(self: FutureSalt): string = "FutureSalt"
method getTypeName*(self: FutureSalts): string = "FutureSalts"
method getTypeName*(self: MessageContainer): string = "MessageContainer"


method TLDecode*(self: FutureSalt, bytes: var ScalingSeq[uint8]) =
    bytes.TLDecode(addr self.validSince) 
    bytes.TLDecode(addr self.validUntil)
    bytes.TLDecode(addr self.salt)  


method TLDecode*(self: FutureSalts, bytes: var ScalingSeq[uint8]) =
    bytes.TLDecode(addr self.reqMsgID)
    bytes.TLDecode(addr self.now)
    
    var lenght: int32
    bytes.TLDecode(addr lenght)

    for _ in countup(1, lenght):
        var tmp = new FutureSalt
        tmp.TLDecode(bytes)
        self.salts.add(tmp)

proc TLEncode*(self: CoreMessage): seq[uint8] =
    result.add(self.msgID.TLEncode())
    result.add(self.seqNo.TLEncode())
    var body = TLEncode(self.body)
    result.add(TLEncode(uint32(len(body)))) 
    result.add(body)

proc TLDecode*(self: CoreMessage, bytes: var ScalingSeq[uint8])

method TLDecode*(self: MessageContainer, bytes: var ScalingSeq[uint8]) =
    var lenght: uint32
    bytes.TLDecode(addr lenght)
    for _ in countup(1, int(lenght)):
        var tmp = new CoreMessage
        tmp.TLDecode(bytes)
        self.messages.add(tmp)

proc TLDecode*(self: CoreMessage, bytes: var ScalingSeq[uint8]) =
    bytes.TLDecode(addr self.msgID)
    bytes.TLDecode(addr self.seqNo)
    bytes.TLDecode(addr self.lenght)
    var objectBytes = newScalingSeq(bytes.readN(int(self.lenght)))
    self.body.TLDecode(objectBytes)

method TLEncode*(self: MessageContainer): seq[uint8] =
    result = TLEncode(uint32(0x73F1F8DC))
    result.add(TLEncode(uint32(len(self.messages))))

    for i in self.messages:
        result.add(TLEncode(i))


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
    var obj = new TL
    for i in countup(1, lenght):
        obj.TLDecode(bytes)
        self.add(obj)


proc seqNo*(self: TL, currentInt: int): int =
    var related = 1
    if self of MessageContainer or self of Ping or self of Msgs_ack:
        related = 0
    var fdasfd = currentInt + (2 * related)
    return fdasfd
