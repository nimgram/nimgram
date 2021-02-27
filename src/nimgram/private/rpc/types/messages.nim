type
    MessagesDialogs* = ref object of MessagesDialogsI
        dialogs*: seq[DialogI]
        messages*: seq[MessageI]
        chats*: seq[ChatI]
        users*: seq[UserI]
    MessagesDialogsSlice* = ref object of MessagesDialogsI
        count*: int32
        dialogs*: seq[DialogI]
        messages*: seq[MessageI]
        chats*: seq[ChatI]
        users*: seq[UserI]
    MessagesDialogsNotModified* = ref object of MessagesDialogsI
        count*: int32
    MessagesMessages* = ref object of MessagesMessagesI
        messages*: seq[MessageI]
        chats*: seq[ChatI]
        users*: seq[UserI]
    MessagesMessagesSlice* = ref object of MessagesMessagesI
        flags: int32
        inexact*: bool
        count*: int32
        next_rate*: Option[int32]
        offset_id_offset*: Option[int32]
        messages*: seq[MessageI]
        chats*: seq[ChatI]
        users*: seq[UserI]
    MessagesChannelMessages* = ref object of MessagesMessagesI
        flags: int32
        inexact*: bool
        pts*: int32
        count*: int32
        offset_id_offset*: Option[int32]
        messages*: seq[MessageI]
        chats*: seq[ChatI]
        users*: seq[UserI]
    MessagesMessagesNotModified* = ref object of MessagesMessagesI
        count*: int32
    MessagesChats* = ref object of MessagesChatsI
        chats*: seq[ChatI]
    MessagesChatsSlice* = ref object of MessagesChatsI
        count*: int32
        chats*: seq[ChatI]
    MessagesChatFull* = ref object of MessagesChatFullI
        full_chat*: ChatFullI
        chats*: seq[ChatI]
        users*: seq[UserI]
    MessagesAffectedHistory* = ref object of MessagesAffectedHistoryI
        pts*: int32
        pts_count*: int32
        offset*: int32
    MessagesDhConfigNotModified* = ref object of MessagesDhConfigI
        random*: seq[uint8]
    MessagesDhConfig* = ref object of MessagesDhConfigI
        g*: int32
        p*: seq[uint8]
        version*: int32
        random*: seq[uint8]
    MessagesSentEncryptedMessage* = ref object of MessagesSentEncryptedMessageI
        date*: int32
    MessagesSentEncryptedFile* = ref object of MessagesSentEncryptedMessageI
        date*: int32
        file*: EncryptedFileI
    MessagesStickersNotModified* = ref object of MessagesStickersI
    MessagesStickers* = ref object of MessagesStickersI
        hash*: int32
        stickers*: seq[DocumentI]
    MessagesAllStickersNotModified* = ref object of MessagesAllStickersI
    MessagesAllStickers* = ref object of MessagesAllStickersI
        hash*: int32
        sets*: seq[StickerSetI]
    MessagesAffectedMessages* = ref object of MessagesAffectedMessagesI
        pts*: int32
        pts_count*: int32
    MessagesStickerSet* = ref object of MessagesStickerSetI
        set*: StickerSetI
        packs*: seq[StickerPackI]
        documents*: seq[DocumentI]
    MessagesSavedGifsNotModified* = ref object of MessagesSavedGifsI
    MessagesSavedGifs* = ref object of MessagesSavedGifsI
        hash*: int32
        gifs*: seq[DocumentI]
    MessagesBotResults* = ref object of MessagesBotResultsI
        flags: int32
        gallery*: bool
        query_id*: int64
        next_offset*: Option[string]
        switch_pm*: Option[InlineBotSwitchPMI]
        results*: seq[BotInlineResultI]
        cache_time*: int32
        users*: seq[UserI]
    MessagesBotCallbackAnswer* = ref object of MessagesBotCallbackAnswerI
        flags: int32
        alert*: bool
        has_url*: bool
        native_ui*: bool
        message*: Option[string]
        url*: Option[string]
        cache_time*: int32
    MessagesMessageEditData* = ref object of MessagesMessageEditDataI
        flags: int32
        caption*: bool
    MessagesPeerDialogs* = ref object of MessagesPeerDialogsI
        dialogs*: seq[DialogI]
        messages*: seq[MessageI]
        chats*: seq[ChatI]
        users*: seq[UserI]
        state*: UpdatesStateI
    MessagesFeaturedStickersNotModified* = ref object of MessagesFeaturedStickersI
        count*: int32
    MessagesFeaturedStickers* = ref object of MessagesFeaturedStickersI
        hash*: int32
        count*: int32
        sets*: seq[StickerSetCoveredI]
        unread*: seq[int64]
    MessagesRecentStickersNotModified* = ref object of MessagesRecentStickersI
    MessagesRecentStickers* = ref object of MessagesRecentStickersI
        hash*: int32
        packs*: seq[StickerPackI]
        stickers*: seq[DocumentI]
        dates*: seq[int32]
    MessagesArchivedStickers* = ref object of MessagesArchivedStickersI
        count*: int32
        sets*: seq[StickerSetCoveredI]
    MessagesStickerSetInstallResultSuccess* = ref object of MessagesStickerSetInstallResultI
    MessagesStickerSetInstallResultArchive* = ref object of MessagesStickerSetInstallResultI
        sets*: seq[StickerSetCoveredI]
    MessagesHighScores* = ref object of MessagesHighScoresI
        scores*: seq[HighScoreI]
        users*: seq[UserI]
    MessagesFavedStickersNotModified* = ref object of MessagesFavedStickersI
    MessagesFavedStickers* = ref object of MessagesFavedStickersI
        hash*: int32
        packs*: seq[StickerPackI]
        stickers*: seq[DocumentI]
    MessagesFoundStickerSetsNotModified* = ref object of MessagesFoundStickerSetsI
    MessagesFoundStickerSets* = ref object of MessagesFoundStickerSetsI
        hash*: int32
        sets*: seq[StickerSetCoveredI]
    MessagesSearchCounter* = ref object of MessagesSearchCounterI
        flags: int32
        inexact*: bool
        filter*: MessagesFilterI
        count*: int32
    MessagesInactiveChats* = ref object of MessagesInactiveChatsI
        dates*: seq[int32]
        chats*: seq[ChatI]
        users*: seq[UserI]
    MessagesVotesList* = ref object of MessagesVotesListI
        flags: int32
        count*: int32
        votes*: seq[MessageUserVoteI]
        users*: seq[UserI]
        next_offset*: Option[string]
    MessagesMessageViews* = ref object of MessagesMessageViewsI
        views*: seq[MessageViewsI]
        chats*: seq[ChatI]
        users*: seq[UserI]
    MessagesDiscussionMessage* = ref object of MessagesDiscussionMessageI
        flags: int32
        messages*: seq[MessageI]
        max_id*: Option[int32]
        read_inbox_max_id*: Option[int32]
        read_outbox_max_id*: Option[int32]
        chats*: seq[ChatI]
        users*: seq[UserI]
    MessagesHistoryImport* = ref object of MessagesHistoryImportI
        id*: int64
    MessagesHistoryImportParsed* = ref object of MessagesHistoryImportParsedI
        flags: int32
        pm*: bool
        group*: bool
        title*: Option[string]
    MessagesAffectedFoundMessages* = ref object of MessagesAffectedFoundMessagesI
        pts*: int32
        pts_count*: int32
        offset*: int32
        messages*: seq[int32]
    MessagesExportedChatInvites* = ref object of MessagesExportedChatInvitesI
        count*: int32
        invites*: seq[ExportedChatInviteI]
        users*: seq[UserI]
    MessagesExportedChatInvite* = ref object of MessagesExportedChatInviteI
        invite*: ExportedChatInviteI
        users*: seq[UserI]
    MessagesExportedChatInviteReplaced* = ref object of MessagesExportedChatInviteI
        invite*: ExportedChatInviteI
        new_invite*: ExportedChatInviteI
        users*: seq[UserI]
    MessagesChatInviteImporters* = ref object of MessagesChatInviteImportersI
        count*: int32
        importers*: seq[ChatInviteImporterI]
        users*: seq[UserI]
    MessagesChatAdminsWithInvites* = ref object of MessagesChatAdminsWithInvitesI
        admins*: seq[ChatAdminWithInvitesI]
        users*: seq[UserI]
method getTypeName*(self: MessagesDialogs): string = "MessagesDialogs"
method getTypeName*(self: MessagesDialogsSlice): string = "MessagesDialogsSlice"
method getTypeName*(self: MessagesDialogsNotModified): string = "MessagesDialogsNotModified"
method getTypeName*(self: MessagesMessages): string = "MessagesMessages"
method getTypeName*(self: MessagesMessagesSlice): string = "MessagesMessagesSlice"
method getTypeName*(self: MessagesChannelMessages): string = "MessagesChannelMessages"
method getTypeName*(self: MessagesMessagesNotModified): string = "MessagesMessagesNotModified"
method getTypeName*(self: MessagesChats): string = "MessagesChats"
method getTypeName*(self: MessagesChatsSlice): string = "MessagesChatsSlice"
method getTypeName*(self: MessagesChatFull): string = "MessagesChatFull"
method getTypeName*(self: MessagesAffectedHistory): string = "MessagesAffectedHistory"
method getTypeName*(self: MessagesDhConfigNotModified): string = "MessagesDhConfigNotModified"
method getTypeName*(self: MessagesDhConfig): string = "MessagesDhConfig"
method getTypeName*(self: MessagesSentEncryptedMessage): string = "MessagesSentEncryptedMessage"
method getTypeName*(self: MessagesSentEncryptedFile): string = "MessagesSentEncryptedFile"
method getTypeName*(self: MessagesStickersNotModified): string = "MessagesStickersNotModified"
method getTypeName*(self: MessagesStickers): string = "MessagesStickers"
method getTypeName*(self: MessagesAllStickersNotModified): string = "MessagesAllStickersNotModified"
method getTypeName*(self: MessagesAllStickers): string = "MessagesAllStickers"
method getTypeName*(self: MessagesAffectedMessages): string = "MessagesAffectedMessages"
method getTypeName*(self: MessagesStickerSet): string = "MessagesStickerSet"
method getTypeName*(self: MessagesSavedGifsNotModified): string = "MessagesSavedGifsNotModified"
method getTypeName*(self: MessagesSavedGifs): string = "MessagesSavedGifs"
method getTypeName*(self: MessagesBotResults): string = "MessagesBotResults"
method getTypeName*(self: MessagesBotCallbackAnswer): string = "MessagesBotCallbackAnswer"
method getTypeName*(self: MessagesMessageEditData): string = "MessagesMessageEditData"
method getTypeName*(self: MessagesPeerDialogs): string = "MessagesPeerDialogs"
method getTypeName*(self: MessagesFeaturedStickersNotModified): string = "MessagesFeaturedStickersNotModified"
method getTypeName*(self: MessagesFeaturedStickers): string = "MessagesFeaturedStickers"
method getTypeName*(self: MessagesRecentStickersNotModified): string = "MessagesRecentStickersNotModified"
method getTypeName*(self: MessagesRecentStickers): string = "MessagesRecentStickers"
method getTypeName*(self: MessagesArchivedStickers): string = "MessagesArchivedStickers"
method getTypeName*(self: MessagesStickerSetInstallResultSuccess): string = "MessagesStickerSetInstallResultSuccess"
method getTypeName*(self: MessagesStickerSetInstallResultArchive): string = "MessagesStickerSetInstallResultArchive"
method getTypeName*(self: MessagesHighScores): string = "MessagesHighScores"
method getTypeName*(self: MessagesFavedStickersNotModified): string = "MessagesFavedStickersNotModified"
method getTypeName*(self: MessagesFavedStickers): string = "MessagesFavedStickers"
method getTypeName*(self: MessagesFoundStickerSetsNotModified): string = "MessagesFoundStickerSetsNotModified"
method getTypeName*(self: MessagesFoundStickerSets): string = "MessagesFoundStickerSets"
method getTypeName*(self: MessagesSearchCounter): string = "MessagesSearchCounter"
method getTypeName*(self: MessagesInactiveChats): string = "MessagesInactiveChats"
method getTypeName*(self: MessagesVotesList): string = "MessagesVotesList"
method getTypeName*(self: MessagesMessageViews): string = "MessagesMessageViews"
method getTypeName*(self: MessagesDiscussionMessage): string = "MessagesDiscussionMessage"
method getTypeName*(self: MessagesHistoryImport): string = "MessagesHistoryImport"
method getTypeName*(self: MessagesHistoryImportParsed): string = "MessagesHistoryImportParsed"
method getTypeName*(self: MessagesAffectedFoundMessages): string = "MessagesAffectedFoundMessages"
method getTypeName*(self: MessagesExportedChatInvites): string = "MessagesExportedChatInvites"
method getTypeName*(self: MessagesExportedChatInvite): string = "MessagesExportedChatInvite"
method getTypeName*(self: MessagesExportedChatInviteReplaced): string = "MessagesExportedChatInviteReplaced"
method getTypeName*(self: MessagesChatInviteImporters): string = "MessagesChatInviteImporters"
method getTypeName*(self: MessagesChatAdminsWithInvites): string = "MessagesChatAdminsWithInvites"

method TLEncode*(self: MessagesDialogs): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x15ba6c40))
    result = result & TLEncode(cast[seq[TL]](self.dialogs))
    result = result & TLEncode(cast[seq[TL]](self.messages))
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: MessagesDialogs, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.dialogs = cast[seq[DialogI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.messages = cast[seq[MessageI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesDialogsSlice): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x71e094f3))
    result = result & TLEncode(self.count)
    result = result & TLEncode(cast[seq[TL]](self.dialogs))
    result = result & TLEncode(cast[seq[TL]](self.messages))
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: MessagesDialogsSlice, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.count)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.dialogs = cast[seq[DialogI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.messages = cast[seq[MessageI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesDialogsNotModified): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf0e3e596))
    result = result & TLEncode(self.count)
method TLDecode*(self: MessagesDialogsNotModified, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.count)
method TLEncode*(self: MessagesMessages): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x8c718e87))
    result = result & TLEncode(cast[seq[TL]](self.messages))
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: MessagesMessages, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.messages = cast[seq[MessageI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesMessagesSlice): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x3a54685e))
    if self.inexact:
        self.flags = self.flags or 1 shl 1
    if self.next_rate.isSome():
        self.flags = self.flags or 1 shl 0
    if self.offset_id_offset.isSome():
        self.flags = self.flags or 1 shl 2
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.count)
    if self.next_rate.isSome():
        result = result & TLEncode(self.next_rate.get())
    if self.offset_id_offset.isSome():
        result = result & TLEncode(self.offset_id_offset.get())
    result = result & TLEncode(cast[seq[TL]](self.messages))
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: MessagesMessagesSlice, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 1)) != 0:
        self.inexact = true
    bytes.TLDecode(addr self.count)
    if (self.flags and (1 shl 0)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.next_rate = some(tempVal)
    if (self.flags and (1 shl 2)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.offset_id_offset = some(tempVal)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.messages = cast[seq[MessageI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesChannelMessages): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x64479808))
    if self.inexact:
        self.flags = self.flags or 1 shl 1
    if self.offset_id_offset.isSome():
        self.flags = self.flags or 1 shl 2
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.pts)
    result = result & TLEncode(self.count)
    if self.offset_id_offset.isSome():
        result = result & TLEncode(self.offset_id_offset.get())
    result = result & TLEncode(cast[seq[TL]](self.messages))
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: MessagesChannelMessages, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 1)) != 0:
        self.inexact = true
    bytes.TLDecode(addr self.pts)
    bytes.TLDecode(addr self.count)
    if (self.flags and (1 shl 2)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.offset_id_offset = some(tempVal)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.messages = cast[seq[MessageI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesMessagesNotModified): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x74535f21))
    result = result & TLEncode(self.count)
method TLDecode*(self: MessagesMessagesNotModified, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.count)
method TLEncode*(self: MessagesChats): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x64ff9fd5))
    result = result & TLEncode(cast[seq[TL]](self.chats))
method TLDecode*(self: MessagesChats, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesChatsSlice): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x9cd81144))
    result = result & TLEncode(self.count)
    result = result & TLEncode(cast[seq[TL]](self.chats))
method TLDecode*(self: MessagesChatsSlice, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.count)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesChatFull): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xe5d7d19c))
    result = result & TLEncode(self.full_chat)
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: MessagesChatFull, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.full_chat = cast[ChatFullI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesAffectedHistory): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb45c69d1))
    result = result & TLEncode(self.pts)
    result = result & TLEncode(self.pts_count)
    result = result & TLEncode(self.offset)
method TLDecode*(self: MessagesAffectedHistory, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.pts)
    bytes.TLDecode(addr self.pts_count)
    bytes.TLDecode(addr self.offset)
method TLEncode*(self: MessagesDhConfigNotModified): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc0e24635))
    result = result & TLEncode(self.random)
method TLDecode*(self: MessagesDhConfigNotModified, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.random = bytes.TLDecode()
method TLEncode*(self: MessagesDhConfig): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x2c221edd))
    result = result & TLEncode(self.g)
    result = result & TLEncode(self.p)
    result = result & TLEncode(self.version)
    result = result & TLEncode(self.random)
method TLDecode*(self: MessagesDhConfig, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.g)
    self.p = bytes.TLDecode()
    bytes.TLDecode(addr self.version)
    self.random = bytes.TLDecode()
method TLEncode*(self: MessagesSentEncryptedMessage): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x560f8935))
    result = result & TLEncode(self.date)
method TLDecode*(self: MessagesSentEncryptedMessage, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.date)
method TLEncode*(self: MessagesSentEncryptedFile): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x9493ff32))
    result = result & TLEncode(self.date)
    result = result & TLEncode(self.file)
method TLDecode*(self: MessagesSentEncryptedFile, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.date)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.file = cast[EncryptedFileI](tempObj)
method TLEncode*(self: MessagesStickersNotModified): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf1749a22))
method TLDecode*(self: MessagesStickersNotModified, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: MessagesStickers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xe4599bbd))
    result = result & TLEncode(self.hash)
    result = result & TLEncode(cast[seq[TL]](self.stickers))
method TLDecode*(self: MessagesStickers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.hash)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.stickers = cast[seq[DocumentI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesAllStickersNotModified): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xe86602c3))
method TLDecode*(self: MessagesAllStickersNotModified, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: MessagesAllStickers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xedfd405f))
    result = result & TLEncode(self.hash)
    result = result & TLEncode(cast[seq[TL]](self.sets))
method TLDecode*(self: MessagesAllStickers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.hash)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.sets = cast[seq[StickerSetI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesAffectedMessages): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x84d19185))
    result = result & TLEncode(self.pts)
    result = result & TLEncode(self.pts_count)
method TLDecode*(self: MessagesAffectedMessages, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.pts)
    bytes.TLDecode(addr self.pts_count)
method TLEncode*(self: MessagesStickerSet): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb60a24a6))
    result = result & TLEncode(self.set)
    result = result & TLEncode(cast[seq[TL]](self.packs))
    result = result & TLEncode(cast[seq[TL]](self.documents))
method TLDecode*(self: MessagesStickerSet, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.set = cast[StickerSetI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.packs = cast[seq[StickerPackI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.documents = cast[seq[DocumentI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesSavedGifsNotModified): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xe8025ca2))
method TLDecode*(self: MessagesSavedGifsNotModified, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: MessagesSavedGifs): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x2e0709a5))
    result = result & TLEncode(self.hash)
    result = result & TLEncode(cast[seq[TL]](self.gifs))
method TLDecode*(self: MessagesSavedGifs, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.hash)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.gifs = cast[seq[DocumentI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesBotResults): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x947ca848))
    if self.gallery:
        self.flags = self.flags or 1 shl 0
    if self.next_offset.isSome():
        self.flags = self.flags or 1 shl 1
    if self.switch_pm.isSome():
        self.flags = self.flags or 1 shl 2
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.query_id)
    if self.next_offset.isSome():
        result = result & TLEncode(self.next_offset.get())
    if self.switch_pm.isSome():
        result = result & TLEncode(self.switch_pm.get())
    result = result & TLEncode(cast[seq[TL]](self.results))
    result = result & TLEncode(self.cache_time)
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: MessagesBotResults, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.gallery = true
    bytes.TLDecode(addr self.query_id)
    if (self.flags and (1 shl 1)) != 0:
        self.next_offset = some(cast[string](bytes.TLDecode()))
    if (self.flags and (1 shl 2)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.switch_pm = some(tempVal.InlineBotSwitchPMI)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.results = cast[seq[BotInlineResultI]](tempVector)
    tempVector.setLen(0)
    bytes.TLDecode(addr self.cache_time)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesBotCallbackAnswer): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x36585ea4))
    if self.alert:
        self.flags = self.flags or 1 shl 1
    if self.has_url:
        self.flags = self.flags or 1 shl 3
    if self.native_ui:
        self.flags = self.flags or 1 shl 4
    if self.message.isSome():
        self.flags = self.flags or 1 shl 0
    if self.url.isSome():
        self.flags = self.flags or 1 shl 2
    result = result & TLEncode(self.flags)
    if self.message.isSome():
        result = result & TLEncode(self.message.get())
    if self.url.isSome():
        result = result & TLEncode(self.url.get())
    result = result & TLEncode(self.cache_time)
method TLDecode*(self: MessagesBotCallbackAnswer, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 1)) != 0:
        self.alert = true
    if (self.flags and (1 shl 3)) != 0:
        self.has_url = true
    if (self.flags and (1 shl 4)) != 0:
        self.native_ui = true
    if (self.flags and (1 shl 0)) != 0:
        self.message = some(cast[string](bytes.TLDecode()))
    if (self.flags and (1 shl 2)) != 0:
        self.url = some(cast[string](bytes.TLDecode()))
    bytes.TLDecode(addr self.cache_time)
method TLEncode*(self: MessagesMessageEditData): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x26b5dde6))
    if self.caption:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
method TLDecode*(self: MessagesMessageEditData, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.caption = true
method TLEncode*(self: MessagesPeerDialogs): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x3371c354))
    result = result & TLEncode(cast[seq[TL]](self.dialogs))
    result = result & TLEncode(cast[seq[TL]](self.messages))
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
    result = result & TLEncode(self.state)
method TLDecode*(self: MessagesPeerDialogs, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.dialogs = cast[seq[DialogI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.messages = cast[seq[MessageI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.state = cast[UpdatesStateI](tempObj)
method TLEncode*(self: MessagesFeaturedStickersNotModified): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc6dc0c66))
    result = result & TLEncode(self.count)
method TLDecode*(self: MessagesFeaturedStickersNotModified, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.count)
method TLEncode*(self: MessagesFeaturedStickers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb6abc341))
    result = result & TLEncode(self.hash)
    result = result & TLEncode(self.count)
    result = result & TLEncode(cast[seq[TL]](self.sets))
    result = result & TLEncode(self.unread)
method TLDecode*(self: MessagesFeaturedStickers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.hash)
    bytes.TLDecode(addr self.count)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.sets = cast[seq[StickerSetCoveredI]](tempVector)
    tempVector.setLen(0)
    bytes.TLDecode(self.unread)
method TLEncode*(self: MessagesRecentStickersNotModified): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb17f890))
method TLDecode*(self: MessagesRecentStickersNotModified, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: MessagesRecentStickers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x22f3afb3))
    result = result & TLEncode(self.hash)
    result = result & TLEncode(cast[seq[TL]](self.packs))
    result = result & TLEncode(cast[seq[TL]](self.stickers))
    result = result & TLEncode(self.dates)
method TLDecode*(self: MessagesRecentStickers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.hash)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.packs = cast[seq[StickerPackI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.stickers = cast[seq[DocumentI]](tempVector)
    tempVector.setLen(0)
    bytes.TLDecode(self.dates)
method TLEncode*(self: MessagesArchivedStickers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x4fcba9c8))
    result = result & TLEncode(self.count)
    result = result & TLEncode(cast[seq[TL]](self.sets))
method TLDecode*(self: MessagesArchivedStickers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.count)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.sets = cast[seq[StickerSetCoveredI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesStickerSetInstallResultSuccess): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x38641628))
method TLDecode*(self: MessagesStickerSetInstallResultSuccess, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: MessagesStickerSetInstallResultArchive): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x35e410a8))
    result = result & TLEncode(cast[seq[TL]](self.sets))
method TLDecode*(self: MessagesStickerSetInstallResultArchive, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.sets = cast[seq[StickerSetCoveredI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesHighScores): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x9a3bfd99))
    result = result & TLEncode(cast[seq[TL]](self.scores))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: MessagesHighScores, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.scores = cast[seq[HighScoreI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesFavedStickersNotModified): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x9e8fa6d3))
method TLDecode*(self: MessagesFavedStickersNotModified, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: MessagesFavedStickers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf37f2f16))
    result = result & TLEncode(self.hash)
    result = result & TLEncode(cast[seq[TL]](self.packs))
    result = result & TLEncode(cast[seq[TL]](self.stickers))
method TLDecode*(self: MessagesFavedStickers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.hash)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.packs = cast[seq[StickerPackI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.stickers = cast[seq[DocumentI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesFoundStickerSetsNotModified): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xd54b65d))
method TLDecode*(self: MessagesFoundStickerSetsNotModified, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: MessagesFoundStickerSets): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x5108d648))
    result = result & TLEncode(self.hash)
    result = result & TLEncode(cast[seq[TL]](self.sets))
method TLDecode*(self: MessagesFoundStickerSets, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.hash)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.sets = cast[seq[StickerSetCoveredI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesSearchCounter): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xe844ebff))
    if self.inexact:
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.filter)
    result = result & TLEncode(self.count)
method TLDecode*(self: MessagesSearchCounter, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 1)) != 0:
        self.inexact = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.filter = cast[MessagesFilterI](tempObj)
    bytes.TLDecode(addr self.count)
method TLEncode*(self: MessagesInactiveChats): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xa927fec5))
    result = result & TLEncode(self.dates)
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: MessagesInactiveChats, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(self.dates)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesVotesList): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x823f649))
    if self.next_offset.isSome():
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.count)
    result = result & TLEncode(cast[seq[TL]](self.votes))
    result = result & TLEncode(cast[seq[TL]](self.users))
    if self.next_offset.isSome():
        result = result & TLEncode(self.next_offset.get())
method TLDecode*(self: MessagesVotesList, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    bytes.TLDecode(addr self.count)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.votes = cast[seq[MessageUserVoteI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
    if (self.flags and (1 shl 0)) != 0:
        self.next_offset = some(cast[string](bytes.TLDecode()))
method TLEncode*(self: MessagesMessageViews): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb6c4f543))
    result = result & TLEncode(cast[seq[TL]](self.views))
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: MessagesMessageViews, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.views = cast[seq[MessageViewsI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesDiscussionMessage): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf5dd8f9d))
    if self.max_id.isSome():
        self.flags = self.flags or 1 shl 0
    if self.read_inbox_max_id.isSome():
        self.flags = self.flags or 1 shl 1
    if self.read_outbox_max_id.isSome():
        self.flags = self.flags or 1 shl 2
    result = result & TLEncode(self.flags)
    result = result & TLEncode(cast[seq[TL]](self.messages))
    if self.max_id.isSome():
        result = result & TLEncode(self.max_id.get())
    if self.read_inbox_max_id.isSome():
        result = result & TLEncode(self.read_inbox_max_id.get())
    if self.read_outbox_max_id.isSome():
        result = result & TLEncode(self.read_outbox_max_id.get())
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: MessagesDiscussionMessage, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.messages = cast[seq[MessageI]](tempVector)
    tempVector.setLen(0)
    if (self.flags and (1 shl 0)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.max_id = some(tempVal)
    if (self.flags and (1 shl 1)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.read_inbox_max_id = some(tempVal)
    if (self.flags and (1 shl 2)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.read_outbox_max_id = some(tempVal)
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesHistoryImport): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x1662af0b))
    result = result & TLEncode(self.id)
method TLDecode*(self: MessagesHistoryImport, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.id)
method TLEncode*(self: MessagesHistoryImportParsed): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x5e0fb7b9))
    if self.pm:
        self.flags = self.flags or 1 shl 0
    if self.group:
        self.flags = self.flags or 1 shl 1
    if self.title.isSome():
        self.flags = self.flags or 1 shl 2
    result = result & TLEncode(self.flags)
    if self.title.isSome():
        result = result & TLEncode(self.title.get())
method TLDecode*(self: MessagesHistoryImportParsed, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.pm = true
    if (self.flags and (1 shl 1)) != 0:
        self.group = true
    if (self.flags and (1 shl 2)) != 0:
        self.title = some(cast[string](bytes.TLDecode()))
method TLEncode*(self: MessagesAffectedFoundMessages): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xef8d3e6c))
    result = result & TLEncode(self.pts)
    result = result & TLEncode(self.pts_count)
    result = result & TLEncode(self.offset)
    result = result & TLEncode(self.messages)
method TLDecode*(self: MessagesAffectedFoundMessages, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.pts)
    bytes.TLDecode(addr self.pts_count)
    bytes.TLDecode(addr self.offset)
    bytes.TLDecode(self.messages)
method TLEncode*(self: MessagesExportedChatInvites): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xbdc62dcc))
    result = result & TLEncode(self.count)
    result = result & TLEncode(cast[seq[TL]](self.invites))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: MessagesExportedChatInvites, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.count)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.invites = cast[seq[ExportedChatInviteI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesExportedChatInvite): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x1871be50))
    result = result & TLEncode(self.invite)
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: MessagesExportedChatInvite, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.invite = cast[ExportedChatInviteI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesExportedChatInviteReplaced): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x222600ef))
    result = result & TLEncode(self.invite)
    result = result & TLEncode(self.new_invite)
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: MessagesExportedChatInviteReplaced, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.invite = cast[ExportedChatInviteI](tempObj)
    tempObj.TLDecode(bytes)
    self.new_invite = cast[ExportedChatInviteI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesChatInviteImporters): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x81b6b00a))
    result = result & TLEncode(self.count)
    result = result & TLEncode(cast[seq[TL]](self.importers))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: MessagesChatInviteImporters, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.count)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.importers = cast[seq[ChatInviteImporterI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesChatAdminsWithInvites): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb69b72d7))
    result = result & TLEncode(cast[seq[TL]](self.admins))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: MessagesChatAdminsWithInvites, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.admins = cast[seq[ChatAdminWithInvitesI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
