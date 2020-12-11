type
    PhonePhoneCall* = ref object of PhonePhoneCallI
        phone_call*: PhoneCallI
        users*: seq[UserI]
    PhoneGroupCall* = ref object of PhoneGroupCallI
        call*: GroupCallI
        participants*: seq[GroupCallParticipantI]
        participants_next_offset*: string
        users*: seq[UserI]
    PhoneGroupParticipants* = ref object of PhoneGroupParticipantsI
        count*: int32
        participants*: seq[GroupCallParticipantI]
        next_offset*: string
        users*: seq[UserI]
        version*: int32
method getTypeName*(self: PhonePhoneCall): string = "PhonePhoneCall"
method getTypeName*(self: PhoneGroupCall): string = "PhoneGroupCall"
method getTypeName*(self: PhoneGroupParticipants): string = "PhoneGroupParticipants"

method TLEncode*(self: PhonePhoneCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xec82e140))
    result = result & TLEncode(self.phone_call)
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: PhonePhoneCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.phone_call = cast[PhoneCallI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: PhoneGroupCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x66ab0bfc))
    result = result & TLEncode(self.call)
    result = result & TLEncode(cast[seq[TL]](self.participants))
    result = result & TLEncode(self.participants_next_offset)
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: PhoneGroupCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.call = cast[GroupCallI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.participants = cast[seq[GroupCallParticipantI]](tempVector)
    tempVector.setLen(0)
    self.participants_next_offset = cast[string](bytes.TLDecode())
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: PhoneGroupParticipants): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x9cfeb92d))
    result = result & TLEncode(self.count)
    result = result & TLEncode(cast[seq[TL]](self.participants))
    result = result & TLEncode(self.next_offset)
    result = result & TLEncode(cast[seq[TL]](self.users))
    result = result & TLEncode(self.version)
method TLDecode*(self: PhoneGroupParticipants, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.count)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.participants = cast[seq[GroupCallParticipantI]](tempVector)
    tempVector.setLen(0)
    self.next_offset = cast[string](bytes.TLDecode())
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
    bytes.TLDecode(addr self.version)
