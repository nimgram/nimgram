type
    ChannelsChannelParticipants* = ref object of ChannelsChannelParticipantsI
        count*: int32
        participants*: seq[ChannelParticipantI]
        chats*: seq[ChatI]
        users*: seq[UserI]
    ChannelsChannelParticipantsNotModified* = ref object of ChannelsChannelParticipantsI
    ChannelsChannelParticipant* = ref object of ChannelsChannelParticipantI
        participant*: ChannelParticipantI
        chats*: seq[ChatI]
        users*: seq[UserI]
    ChannelsAdminLogResults* = ref object of ChannelsAdminLogResultsI
        events*: seq[ChannelAdminLogEventI]
        chats*: seq[ChatI]
        users*: seq[UserI]
method getTypeName*(self: ChannelsChannelParticipants): string = "ChannelsChannelParticipants"
method getTypeName*(self: ChannelsChannelParticipantsNotModified): string = "ChannelsChannelParticipantsNotModified"
method getTypeName*(self: ChannelsChannelParticipant): string = "ChannelsChannelParticipant"
method getTypeName*(self: ChannelsAdminLogResults): string = "ChannelsAdminLogResults"

method TLEncode*(self: ChannelsChannelParticipants): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x9ab0feaf))
    result = result & TLEncode(self.count)
    result = result & TLEncode(cast[seq[TL]](self.participants))
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: ChannelsChannelParticipants, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.count)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.participants = cast[seq[ChannelParticipantI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: ChannelsChannelParticipantsNotModified): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf0173fe9))
method TLDecode*(self: ChannelsChannelParticipantsNotModified, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: ChannelsChannelParticipant): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xdfb80317))
    result = result & TLEncode(self.participant)
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: ChannelsChannelParticipant, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.participant = cast[ChannelParticipantI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: ChannelsAdminLogResults): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xed8af74d))
    result = result & TLEncode(cast[seq[TL]](self.events))
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: ChannelsAdminLogResults, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.events = cast[seq[ChannelAdminLogEventI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
