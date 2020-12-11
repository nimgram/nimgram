type
    PhoneGetCallConfig* = ref object of TLFunction
    PhoneRequestCall* = ref object of TLFunction
        flags: int32
        video*: bool
        user_id*: InputUserI
        random_id*: int32
        g_a_hash*: seq[uint8]
        protocol*: PhoneCallProtocolI
    PhoneAcceptCall* = ref object of TLFunction
        peer*: InputPhoneCallI
        g_b*: seq[uint8]
        protocol*: PhoneCallProtocolI
    PhoneConfirmCall* = ref object of TLFunction
        peer*: InputPhoneCallI
        g_a*: seq[uint8]
        key_fingerprint*: int64
        protocol*: PhoneCallProtocolI
    PhoneReceivedCall* = ref object of TLFunction
        peer*: InputPhoneCallI
    PhoneDiscardCall* = ref object of TLFunction
        flags: int32
        video*: bool
        peer*: InputPhoneCallI
        duration*: int32
        reason*: PhoneCallDiscardReasonI
        connection_id*: int64
    PhoneSetCallRating* = ref object of TLFunction
        flags: int32
        user_initiative*: bool
        peer*: InputPhoneCallI
        rating*: int32
        comment*: string
    PhoneSaveCallDebug* = ref object of TLFunction
        peer*: InputPhoneCallI
        debug*: DataJSONI
    PhoneSendSignalingData* = ref object of TLFunction
        peer*: InputPhoneCallI
        data*: seq[uint8]
    PhoneCreateGroupCall* = ref object of TLFunction
        channel*: InputChannelI
        random_id*: int32
    PhoneJoinGroupCall* = ref object of TLFunction
        flags: int32
        muted*: bool
        call*: InputGroupCallI
        params*: DataJSONI
    PhoneLeaveGroupCall* = ref object of TLFunction
        call*: InputGroupCallI
        source*: int32
    PhoneEditGroupCallMember* = ref object of TLFunction
        flags: int32
        muted*: bool
        call*: InputGroupCallI
        user_id*: InputUserI
    PhoneInviteToGroupCall* = ref object of TLFunction
        call*: InputGroupCallI
        users*: seq[InputUserI]
    PhoneDiscardGroupCall* = ref object of TLFunction
        call*: InputGroupCallI
    PhoneToggleGroupCallSettings* = ref object of TLFunction
        flags: int32
        call*: InputGroupCallI
        join_muted*: Option[bool]
    PhoneGetGroupCall* = ref object of TLFunction
        call*: InputGroupCallI
    PhoneGetGroupParticipants* = ref object of TLFunction
        call*: InputGroupCallI
        ids*: seq[int32]
        sources*: seq[int32]
        offset*: string
        limit*: int32
    PhoneCheckGroupCall* = ref object of TLFunction
        call*: InputGroupCallI
        source*: int32
method getTypeName*(self: PhoneGetCallConfig): string = "PhoneGetCallConfig"
method getTypeName*(self: PhoneRequestCall): string = "PhoneRequestCall"
method getTypeName*(self: PhoneAcceptCall): string = "PhoneAcceptCall"
method getTypeName*(self: PhoneConfirmCall): string = "PhoneConfirmCall"
method getTypeName*(self: PhoneReceivedCall): string = "PhoneReceivedCall"
method getTypeName*(self: PhoneDiscardCall): string = "PhoneDiscardCall"
method getTypeName*(self: PhoneSetCallRating): string = "PhoneSetCallRating"
method getTypeName*(self: PhoneSaveCallDebug): string = "PhoneSaveCallDebug"
method getTypeName*(self: PhoneSendSignalingData): string = "PhoneSendSignalingData"
method getTypeName*(self: PhoneCreateGroupCall): string = "PhoneCreateGroupCall"
method getTypeName*(self: PhoneJoinGroupCall): string = "PhoneJoinGroupCall"
method getTypeName*(self: PhoneLeaveGroupCall): string = "PhoneLeaveGroupCall"
method getTypeName*(self: PhoneEditGroupCallMember): string = "PhoneEditGroupCallMember"
method getTypeName*(self: PhoneInviteToGroupCall): string = "PhoneInviteToGroupCall"
method getTypeName*(self: PhoneDiscardGroupCall): string = "PhoneDiscardGroupCall"
method getTypeName*(self: PhoneToggleGroupCallSettings): string = "PhoneToggleGroupCallSettings"
method getTypeName*(self: PhoneGetGroupCall): string = "PhoneGetGroupCall"
method getTypeName*(self: PhoneGetGroupParticipants): string = "PhoneGetGroupParticipants"
method getTypeName*(self: PhoneCheckGroupCall): string = "PhoneCheckGroupCall"

method TLEncode*(self: PhoneGetCallConfig): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x55451fa9))
method TLDecode*(self: PhoneGetCallConfig, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: PhoneRequestCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x42ff96ed))
    if self.video:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.user_id)
    result = result & TLEncode(self.random_id)
    result = result & TLEncode(self.g_a_hash)
    result = result & TLEncode(self.protocol)
method TLDecode*(self: PhoneRequestCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.video = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.user_id = cast[InputUserI](tempObj)
    bytes.TLDecode(addr self.random_id)
    self.g_a_hash = bytes.TLDecode()
    tempObj.TLDecode(bytes)
    self.protocol = cast[PhoneCallProtocolI](tempObj)
method TLEncode*(self: PhoneAcceptCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x3bd2b4a0))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.g_b)
    result = result & TLEncode(self.protocol)
method TLDecode*(self: PhoneAcceptCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPhoneCallI](tempObj)
    self.g_b = bytes.TLDecode()
    tempObj.TLDecode(bytes)
    self.protocol = cast[PhoneCallProtocolI](tempObj)
method TLEncode*(self: PhoneConfirmCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x2efe1722))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.g_a)
    result = result & TLEncode(self.key_fingerprint)
    result = result & TLEncode(self.protocol)
method TLDecode*(self: PhoneConfirmCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPhoneCallI](tempObj)
    self.g_a = bytes.TLDecode()
    bytes.TLDecode(addr self.key_fingerprint)
    tempObj.TLDecode(bytes)
    self.protocol = cast[PhoneCallProtocolI](tempObj)
method TLEncode*(self: PhoneReceivedCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x17d54f61))
    result = result & TLEncode(self.peer)
method TLDecode*(self: PhoneReceivedCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPhoneCallI](tempObj)
method TLEncode*(self: PhoneDiscardCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb2cbc1c0))
    if self.video:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.duration)
    result = result & TLEncode(self.reason)
    result = result & TLEncode(self.connection_id)
method TLDecode*(self: PhoneDiscardCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.video = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPhoneCallI](tempObj)
    bytes.TLDecode(addr self.duration)
    tempObj.TLDecode(bytes)
    self.reason = cast[PhoneCallDiscardReasonI](tempObj)
    bytes.TLDecode(addr self.connection_id)
method TLEncode*(self: PhoneSetCallRating): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x59ead627))
    if self.user_initiative:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.rating)
    result = result & TLEncode(self.comment)
method TLDecode*(self: PhoneSetCallRating, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.user_initiative = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPhoneCallI](tempObj)
    bytes.TLDecode(addr self.rating)
    self.comment = cast[string](bytes.TLDecode())
method TLEncode*(self: PhoneSaveCallDebug): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x277add7e))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.debug)
method TLDecode*(self: PhoneSaveCallDebug, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPhoneCallI](tempObj)
    tempObj.TLDecode(bytes)
    self.debug = cast[DataJSONI](tempObj)
method TLEncode*(self: PhoneSendSignalingData): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xff7a9383))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.data)
method TLDecode*(self: PhoneSendSignalingData, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPhoneCallI](tempObj)
    self.data = bytes.TLDecode()
method TLEncode*(self: PhoneCreateGroupCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xe428fa02))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.random_id)
method TLDecode*(self: PhoneCreateGroupCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    bytes.TLDecode(addr self.random_id)
method TLEncode*(self: PhoneJoinGroupCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x5f9c8e62))
    if self.muted:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.call)
    result = result & TLEncode(self.params)
method TLDecode*(self: PhoneJoinGroupCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.muted = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.call = cast[InputGroupCallI](tempObj)
    tempObj.TLDecode(bytes)
    self.params = cast[DataJSONI](tempObj)
method TLEncode*(self: PhoneLeaveGroupCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x500377f9))
    result = result & TLEncode(self.call)
    result = result & TLEncode(self.source)
method TLDecode*(self: PhoneLeaveGroupCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.call = cast[InputGroupCallI](tempObj)
    bytes.TLDecode(addr self.source)
method TLEncode*(self: PhoneEditGroupCallMember): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x63146ae4))
    if self.muted:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.call)
    result = result & TLEncode(self.user_id)
method TLDecode*(self: PhoneEditGroupCallMember, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.muted = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.call = cast[InputGroupCallI](tempObj)
    tempObj.TLDecode(bytes)
    self.user_id = cast[InputUserI](tempObj)
method TLEncode*(self: PhoneInviteToGroupCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x7b393160))
    result = result & TLEncode(self.call)
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: PhoneInviteToGroupCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.call = cast[InputGroupCallI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.users = cast[seq[InputUserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: PhoneDiscardGroupCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x7a777135))
    result = result & TLEncode(self.call)
method TLDecode*(self: PhoneDiscardGroupCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.call = cast[InputGroupCallI](tempObj)
method TLEncode*(self: PhoneToggleGroupCallSettings): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x74bbb43d))
    if self.join_muted.isSome():
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.call)
    if self.join_muted.isSome():
        result = result & TLEncode(self.join_muted.get())
method TLDecode*(self: PhoneToggleGroupCallSettings, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.call = cast[InputGroupCallI](tempObj)
    if (self.flags and (1 shl 0)) != 0:
        var tempVal: bool
        bytes.TLDecode(tempVal)
        self.join_muted = some(tempVal)
method TLEncode*(self: PhoneGetGroupCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc7cb017))
    result = result & TLEncode(self.call)
method TLDecode*(self: PhoneGetGroupCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.call = cast[InputGroupCallI](tempObj)
method TLEncode*(self: PhoneGetGroupParticipants): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc9f1d285))
    result = result & TLEncode(self.call)
    result = result & TLEncode(self.ids)
    result = result & TLEncode(self.sources)
    result = result & TLEncode(self.offset)
    result = result & TLEncode(self.limit)
method TLDecode*(self: PhoneGetGroupParticipants, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.call = cast[InputGroupCallI](tempObj)
    bytes.TLDecode(self.ids)
    bytes.TLDecode(self.sources)
    self.offset = cast[string](bytes.TLDecode())
    bytes.TLDecode(addr self.limit)
method TLEncode*(self: PhoneCheckGroupCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb74a7bea))
    result = result & TLEncode(self.call)
    result = result & TLEncode(self.source)
method TLDecode*(self: PhoneCheckGroupCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.call = cast[InputGroupCallI](tempObj)
    bytes.TLDecode(addr self.source)
