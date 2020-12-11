type
    ChannelsReadHistory* = ref object of TLFunction
        channel*: InputChannelI
        max_id*: int32
    ChannelsDeleteMessages* = ref object of TLFunction
        channel*: InputChannelI
        id*: seq[int32]
    ChannelsDeleteUserHistory* = ref object of TLFunction
        channel*: InputChannelI
        user_id*: InputUserI
    ChannelsReportSpam* = ref object of TLFunction
        channel*: InputChannelI
        user_id*: InputUserI
        id*: seq[int32]
    ChannelsGetMessages* = ref object of TLFunction
        channel*: InputChannelI
        id*: seq[InputMessageI]
    ChannelsGetParticipants* = ref object of TLFunction
        channel*: InputChannelI
        filter*: ChannelParticipantsFilterI
        offset*: int32
        limit*: int32
        hash*: int32
    ChannelsGetParticipant* = ref object of TLFunction
        channel*: InputChannelI
        user_id*: InputUserI
    ChannelsGetChannels* = ref object of TLFunction
        id*: seq[InputChannelI]
    ChannelsGetFullChannel* = ref object of TLFunction
        channel*: InputChannelI
    ChannelsCreateChannel* = ref object of TLFunction
        flags: int32
        broadcast*: bool
        megagroup*: bool
        title*: string
        about*: string
        geo_point*: Option[InputGeoPointI]
        address*: Option[string]
    ChannelsEditAdmin* = ref object of TLFunction
        channel*: InputChannelI
        user_id*: InputUserI
        admin_rights*: ChatAdminRightsI
        rank*: string
    ChannelsEditTitle* = ref object of TLFunction
        channel*: InputChannelI
        title*: string
    ChannelsEditPhoto* = ref object of TLFunction
        channel*: InputChannelI
        photo*: InputChatPhotoI
    ChannelsCheckUsername* = ref object of TLFunction
        channel*: InputChannelI
        username*: string
    ChannelsUpdateUsername* = ref object of TLFunction
        channel*: InputChannelI
        username*: string
    ChannelsJoinChannel* = ref object of TLFunction
        channel*: InputChannelI
    ChannelsLeaveChannel* = ref object of TLFunction
        channel*: InputChannelI
    ChannelsInviteToChannel* = ref object of TLFunction
        channel*: InputChannelI
        users*: seq[InputUserI]
    ChannelsDeleteChannel* = ref object of TLFunction
        channel*: InputChannelI
    ChannelsExportMessageLink* = ref object of TLFunction
        flags: int32
        grouped*: bool
        thread*: bool
        channel*: InputChannelI
        id*: int32
    ChannelsToggleSignatures* = ref object of TLFunction
        channel*: InputChannelI
        enabled*: bool
    ChannelsGetAdminedPublicChannels* = ref object of TLFunction
        flags: int32
        by_location*: bool
        check_limit*: bool
    ChannelsEditBanned* = ref object of TLFunction
        channel*: InputChannelI
        user_id*: InputUserI
        banned_rights*: ChatBannedRightsI
    ChannelsGetAdminLog* = ref object of TLFunction
        flags: int32
        channel*: InputChannelI
        q*: string
        events_filter*: Option[ChannelAdminLogEventsFilterI]
        admins*: Option[seq[InputUserI]]
        max_id*: int64
        min_id*: int64
        limit*: int32
    ChannelsSetStickers* = ref object of TLFunction
        channel*: InputChannelI
        stickerset*: InputStickerSetI
    ChannelsReadMessageContents* = ref object of TLFunction
        channel*: InputChannelI
        id*: seq[int32]
    ChannelsDeleteHistory* = ref object of TLFunction
        channel*: InputChannelI
        max_id*: int32
    ChannelsTogglePreHistoryHidden* = ref object of TLFunction
        channel*: InputChannelI
        enabled*: bool
    ChannelsGetLeftChannels* = ref object of TLFunction
        offset*: int32
    ChannelsGetGroupsForDiscussion* = ref object of TLFunction
    ChannelsSetDiscussionGroup* = ref object of TLFunction
        broadcast*: InputChannelI
        group*: InputChannelI
    ChannelsEditCreator* = ref object of TLFunction
        channel*: InputChannelI
        user_id*: InputUserI
        password*: InputCheckPasswordSRPI
    ChannelsEditLocation* = ref object of TLFunction
        channel*: InputChannelI
        geo_point*: InputGeoPointI
        address*: string
    ChannelsToggleSlowMode* = ref object of TLFunction
        channel*: InputChannelI
        seconds*: int32
    ChannelsGetInactiveChannels* = ref object of TLFunction
method getTypeName*(self: ChannelsReadHistory): string = "ChannelsReadHistory"
method getTypeName*(self: ChannelsDeleteMessages): string = "ChannelsDeleteMessages"
method getTypeName*(self: ChannelsDeleteUserHistory): string = "ChannelsDeleteUserHistory"
method getTypeName*(self: ChannelsReportSpam): string = "ChannelsReportSpam"
method getTypeName*(self: ChannelsGetMessages): string = "ChannelsGetMessages"
method getTypeName*(self: ChannelsGetParticipants): string = "ChannelsGetParticipants"
method getTypeName*(self: ChannelsGetParticipant): string = "ChannelsGetParticipant"
method getTypeName*(self: ChannelsGetChannels): string = "ChannelsGetChannels"
method getTypeName*(self: ChannelsGetFullChannel): string = "ChannelsGetFullChannel"
method getTypeName*(self: ChannelsCreateChannel): string = "ChannelsCreateChannel"
method getTypeName*(self: ChannelsEditAdmin): string = "ChannelsEditAdmin"
method getTypeName*(self: ChannelsEditTitle): string = "ChannelsEditTitle"
method getTypeName*(self: ChannelsEditPhoto): string = "ChannelsEditPhoto"
method getTypeName*(self: ChannelsCheckUsername): string = "ChannelsCheckUsername"
method getTypeName*(self: ChannelsUpdateUsername): string = "ChannelsUpdateUsername"
method getTypeName*(self: ChannelsJoinChannel): string = "ChannelsJoinChannel"
method getTypeName*(self: ChannelsLeaveChannel): string = "ChannelsLeaveChannel"
method getTypeName*(self: ChannelsInviteToChannel): string = "ChannelsInviteToChannel"
method getTypeName*(self: ChannelsDeleteChannel): string = "ChannelsDeleteChannel"
method getTypeName*(self: ChannelsExportMessageLink): string = "ChannelsExportMessageLink"
method getTypeName*(self: ChannelsToggleSignatures): string = "ChannelsToggleSignatures"
method getTypeName*(self: ChannelsGetAdminedPublicChannels): string = "ChannelsGetAdminedPublicChannels"
method getTypeName*(self: ChannelsEditBanned): string = "ChannelsEditBanned"
method getTypeName*(self: ChannelsGetAdminLog): string = "ChannelsGetAdminLog"
method getTypeName*(self: ChannelsSetStickers): string = "ChannelsSetStickers"
method getTypeName*(self: ChannelsReadMessageContents): string = "ChannelsReadMessageContents"
method getTypeName*(self: ChannelsDeleteHistory): string = "ChannelsDeleteHistory"
method getTypeName*(self: ChannelsTogglePreHistoryHidden): string = "ChannelsTogglePreHistoryHidden"
method getTypeName*(self: ChannelsGetLeftChannels): string = "ChannelsGetLeftChannels"
method getTypeName*(self: ChannelsGetGroupsForDiscussion): string = "ChannelsGetGroupsForDiscussion"
method getTypeName*(self: ChannelsSetDiscussionGroup): string = "ChannelsSetDiscussionGroup"
method getTypeName*(self: ChannelsEditCreator): string = "ChannelsEditCreator"
method getTypeName*(self: ChannelsEditLocation): string = "ChannelsEditLocation"
method getTypeName*(self: ChannelsToggleSlowMode): string = "ChannelsToggleSlowMode"
method getTypeName*(self: ChannelsGetInactiveChannels): string = "ChannelsGetInactiveChannels"

method TLEncode*(self: ChannelsReadHistory): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xcc104937))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.max_id)
method TLDecode*(self: ChannelsReadHistory, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    bytes.TLDecode(addr self.max_id)
method TLEncode*(self: ChannelsDeleteMessages): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x84c1fd4e))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.id)
method TLDecode*(self: ChannelsDeleteMessages, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    bytes.TLDecode(self.id)
method TLEncode*(self: ChannelsDeleteUserHistory): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xd10dd71b))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.user_id)
method TLDecode*(self: ChannelsDeleteUserHistory, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    tempObj.TLDecode(bytes)
    self.user_id = cast[InputUserI](tempObj)
method TLEncode*(self: ChannelsReportSpam): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xfe087810))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.user_id)
    result = result & TLEncode(self.id)
method TLDecode*(self: ChannelsReportSpam, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    tempObj.TLDecode(bytes)
    self.user_id = cast[InputUserI](tempObj)
    bytes.TLDecode(self.id)
method TLEncode*(self: ChannelsGetMessages): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xad8c9a23))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(cast[seq[TL]](self.id))
method TLDecode*(self: ChannelsGetMessages, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.id = cast[seq[InputMessageI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: ChannelsGetParticipants): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x123e05e9))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.filter)
    result = result & TLEncode(self.offset)
    result = result & TLEncode(self.limit)
    result = result & TLEncode(self.hash)
method TLDecode*(self: ChannelsGetParticipants, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    tempObj.TLDecode(bytes)
    self.filter = cast[ChannelParticipantsFilterI](tempObj)
    bytes.TLDecode(addr self.offset)
    bytes.TLDecode(addr self.limit)
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: ChannelsGetParticipant): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x546dd7a6))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.user_id)
method TLDecode*(self: ChannelsGetParticipant, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    tempObj.TLDecode(bytes)
    self.user_id = cast[InputUserI](tempObj)
method TLEncode*(self: ChannelsGetChannels): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xa7f6bbb))
    result = result & TLEncode(cast[seq[TL]](self.id))
method TLDecode*(self: ChannelsGetChannels, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.id = cast[seq[InputChannelI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: ChannelsGetFullChannel): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x8736a09))
    result = result & TLEncode(self.channel)
method TLDecode*(self: ChannelsGetFullChannel, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
method TLEncode*(self: ChannelsCreateChannel): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x3d5fb10f))
    if self.broadcast:
        self.flags = self.flags or 1 shl 0
    if self.megagroup:
        self.flags = self.flags or 1 shl 1
    if self.geo_point.isSome():
        self.flags = self.flags or 1 shl 2
    if self.address.isSome():
        self.flags = self.flags or 1 shl 2
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.title)
    result = result & TLEncode(self.about)
    if self.geo_point.isSome():
        result = result & TLEncode(self.geo_point.get())
    if self.address.isSome():
        result = result & TLEncode(self.address.get())
method TLDecode*(self: ChannelsCreateChannel, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.broadcast = true
    if (self.flags and (1 shl 1)) != 0:
        self.megagroup = true
    self.title = cast[string](bytes.TLDecode())
    self.about = cast[string](bytes.TLDecode())
    if (self.flags and (1 shl 2)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.geo_point = some(tempVal.InputGeoPointI)
    if (self.flags and (1 shl 2)) != 0:
        self.address = some(cast[string](bytes.TLDecode()))
method TLEncode*(self: ChannelsEditAdmin): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xd33c8902))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.user_id)
    result = result & TLEncode(self.admin_rights)
    result = result & TLEncode(self.rank)
method TLDecode*(self: ChannelsEditAdmin, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    tempObj.TLDecode(bytes)
    self.user_id = cast[InputUserI](tempObj)
    tempObj.TLDecode(bytes)
    self.admin_rights = cast[ChatAdminRightsI](tempObj)
    self.rank = cast[string](bytes.TLDecode())
method TLEncode*(self: ChannelsEditTitle): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x566decd0))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.title)
method TLDecode*(self: ChannelsEditTitle, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    self.title = cast[string](bytes.TLDecode())
method TLEncode*(self: ChannelsEditPhoto): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf12e57c9))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.photo)
method TLDecode*(self: ChannelsEditPhoto, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    tempObj.TLDecode(bytes)
    self.photo = cast[InputChatPhotoI](tempObj)
method TLEncode*(self: ChannelsCheckUsername): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x10e6bd2c))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.username)
method TLDecode*(self: ChannelsCheckUsername, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    self.username = cast[string](bytes.TLDecode())
method TLEncode*(self: ChannelsUpdateUsername): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x3514b3de))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.username)
method TLDecode*(self: ChannelsUpdateUsername, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    self.username = cast[string](bytes.TLDecode())
method TLEncode*(self: ChannelsJoinChannel): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x24b524c5))
    result = result & TLEncode(self.channel)
method TLDecode*(self: ChannelsJoinChannel, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
method TLEncode*(self: ChannelsLeaveChannel): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf836aa95))
    result = result & TLEncode(self.channel)
method TLDecode*(self: ChannelsLeaveChannel, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
method TLEncode*(self: ChannelsInviteToChannel): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x199f3a6c))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: ChannelsInviteToChannel, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.users = cast[seq[InputUserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: ChannelsDeleteChannel): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc0111fe3))
    result = result & TLEncode(self.channel)
method TLDecode*(self: ChannelsDeleteChannel, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
method TLEncode*(self: ChannelsExportMessageLink): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xe63fadeb))
    if self.grouped:
        self.flags = self.flags or 1 shl 0
    if self.thread:
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.id)
method TLDecode*(self: ChannelsExportMessageLink, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.grouped = true
    if (self.flags and (1 shl 1)) != 0:
        self.thread = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    bytes.TLDecode(addr self.id)
method TLEncode*(self: ChannelsToggleSignatures): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x1f69b606))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.enabled)
method TLDecode*(self: ChannelsToggleSignatures, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    bytes.TLDecode(self.enabled)
method TLEncode*(self: ChannelsGetAdminedPublicChannels): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf8b036af))
    if self.by_location:
        self.flags = self.flags or 1 shl 0
    if self.check_limit:
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
method TLDecode*(self: ChannelsGetAdminedPublicChannels, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.by_location = true
    if (self.flags and (1 shl 1)) != 0:
        self.check_limit = true
method TLEncode*(self: ChannelsEditBanned): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x72796912))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.user_id)
    result = result & TLEncode(self.banned_rights)
method TLDecode*(self: ChannelsEditBanned, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    tempObj.TLDecode(bytes)
    self.user_id = cast[InputUserI](tempObj)
    tempObj.TLDecode(bytes)
    self.banned_rights = cast[ChatBannedRightsI](tempObj)
method TLEncode*(self: ChannelsGetAdminLog): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x33ddf480))
    if self.events_filter.isSome():
        self.flags = self.flags or 1 shl 0
    if self.admins.isSome():
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.q)
    if self.events_filter.isSome():
        result = result & TLEncode(self.events_filter.get())
    if self.admins.isSome():
        result = result & TLEncode(cast[seq[TL]](self.admins.get()))
    result = result & TLEncode(self.max_id)
    result = result & TLEncode(self.min_id)
    result = result & TLEncode(self.limit)
method TLDecode*(self: ChannelsGetAdminLog, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    self.q = cast[string](bytes.TLDecode())
    if (self.flags and (1 shl 0)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.events_filter = some(tempVal.ChannelAdminLogEventsFilterI)
    if (self.flags and (1 shl 1)) != 0:
        var tempVal = newSeq[TL]()
        tempVal.TLDecode(bytes)
        self.admins = some(cast[seq[InputUserI]](tempVal))
    bytes.TLDecode(addr self.max_id)
    bytes.TLDecode(addr self.min_id)
    bytes.TLDecode(addr self.limit)
method TLEncode*(self: ChannelsSetStickers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xea8ca4f9))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.stickerset)
method TLDecode*(self: ChannelsSetStickers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    tempObj.TLDecode(bytes)
    self.stickerset = cast[InputStickerSetI](tempObj)
method TLEncode*(self: ChannelsReadMessageContents): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xeab5dc38))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.id)
method TLDecode*(self: ChannelsReadMessageContents, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    bytes.TLDecode(self.id)
method TLEncode*(self: ChannelsDeleteHistory): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xaf369d42))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.max_id)
method TLDecode*(self: ChannelsDeleteHistory, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    bytes.TLDecode(addr self.max_id)
method TLEncode*(self: ChannelsTogglePreHistoryHidden): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xeabbb94c))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.enabled)
method TLDecode*(self: ChannelsTogglePreHistoryHidden, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    bytes.TLDecode(self.enabled)
method TLEncode*(self: ChannelsGetLeftChannels): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x8341ecc0))
    result = result & TLEncode(self.offset)
method TLDecode*(self: ChannelsGetLeftChannels, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.offset)
method TLEncode*(self: ChannelsGetGroupsForDiscussion): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf5dad378))
method TLDecode*(self: ChannelsGetGroupsForDiscussion, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: ChannelsSetDiscussionGroup): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x40582bb2))
    result = result & TLEncode(self.broadcast)
    result = result & TLEncode(self.group)
method TLDecode*(self: ChannelsSetDiscussionGroup, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.broadcast = cast[InputChannelI](tempObj)
    tempObj.TLDecode(bytes)
    self.group = cast[InputChannelI](tempObj)
method TLEncode*(self: ChannelsEditCreator): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x8f38cd1f))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.user_id)
    result = result & TLEncode(self.password)
method TLDecode*(self: ChannelsEditCreator, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    tempObj.TLDecode(bytes)
    self.user_id = cast[InputUserI](tempObj)
    tempObj.TLDecode(bytes)
    self.password = cast[InputCheckPasswordSRPI](tempObj)
method TLEncode*(self: ChannelsEditLocation): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x58e63f6d))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.geo_point)
    result = result & TLEncode(self.address)
method TLDecode*(self: ChannelsEditLocation, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    tempObj.TLDecode(bytes)
    self.geo_point = cast[InputGeoPointI](tempObj)
    self.address = cast[string](bytes.TLDecode())
method TLEncode*(self: ChannelsToggleSlowMode): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xedd49ef0))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.seconds)
method TLDecode*(self: ChannelsToggleSlowMode, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    bytes.TLDecode(addr self.seconds)
method TLEncode*(self: ChannelsGetInactiveChannels): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x11e831ee))
method TLDecode*(self: ChannelsGetInactiveChannels, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
