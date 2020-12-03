import decoding
import mtproto
import api
import encoding
import zippy
type 
    FutureSalt* = ref object
        validSince*: int32
        validUntil*: int32
        salt*: uint64
    FutureSalts* = ref object
        reqMsgID*: uint64
        now*: int32
        salts*: seq[FutureSalt]
    
    CoreMessage* = ref object
        msgID*: uint64 
        seqNo*: uint32
        lenght*: uint32
        body*: TL
    
    MessageContainer* = ref object of TL
        messages*: seq[CoreMessage]



proc TLDecode*(self: var ScalingSeq[uint8], fsalt: FutureSalt) =
    self.TLDecode(addr fsalt.validSince) 
    self.TLDecode(addr fsalt.validUntil)
    self.TLDecode(addr fsalt.salt)  

proc TLDecode*(self: var ScalingSeq[uint8], container: MessageContainer)

proc TLDecode*(self: var ScalingSeq[uint8], fsalts: FutureSalts) =
    self.TLDecode(addr fsalts.reqMsgID)
    self.TLDecode(addr fsalts.now)
    
    var lenght: int32
    self.TLDecode(addr lenght)

    for _ in countup(1, lenght):
        var tempObj: FutureSalt
        self.TLDecode(tempObj)
        fsalts.salts.add(tempObj)

proc TLEncode*(self: CoreMessage): seq[uint8] =
    result = TLEncode(self.msgID)
    result.add(TLEncode(self.seqNo))
    var data: seq[uint8]
    if self.body of TLFunction:
        data = TLEncodeGeneric(cast[TLFunction](self.body))
    else:
        data = TLEncode(cast[TLObject](self.body))
    result.add(TLEncode(uint32(len(data))))
    result.add(data)
proc TLDecode*(self: var ScalingSeq[uint8], coreMessage: CoreMessage) = 
    self.TLDecode(addr coreMessage.msgID)
    self.TLDecode(addr coreMessage.seqNo)
    self.TLDecode(addr coreMessage.lenght)
    var objectBytes = newScalingSeq(self.readN(int(coreMessage.lenght)))
    var testID: int32
    objectBytes.TLDecode(addr testID)
    if testID == 0x73F1F8DC:
        var tempContainer = new MessageContainer
        objectBytes.TLDecode(tempContainer)
        coreMessage.body = tempContainer
        return
    else:
        objectBytes.goBack(4)
    
    var tempObject: TLObject
    objectBytes.TLDecode(tempObject)
    coreMessage.body = tempObject


proc TLEncode*(self: MessageContainer): seq[uint8] =
    result = TLEncode(uint32(0x73F1F8DC))
    result.add(TLEncode(uint32(len(self.messages))))

    for i in self.messages:
        result.add(TLEncode(i))

proc TLDecode*(self: var ScalingSeq[uint8], container: MessageContainer) =
    var lenght: uint32
    self.TLDecode(addr lenght)
    for _ in countup(1, int(lenght)):
        var tempObj = new CoreMessage
        self.TLDecode(tempObj)
        container.messages.add(tempObj)

proc seqNo*(self: TL, currentInt: int): int =
    var related = 1
    if self of MessageContainer or self of ping or self of msgs_ack:
        related = 0
    var fdasfd = currentInt + (2 * related)
    return fdasfd
