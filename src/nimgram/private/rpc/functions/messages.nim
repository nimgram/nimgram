type
    MessagesGetMessages* = ref object of TLFunction
        id*: seq[InputMessageI]
    MessagesGetDialogs* = ref object of TLFunction
        flags: int32
        exclude_pinned*: bool
        folder_id*: Option[int32]
        offset_date*: int32
        offset_id*: int32
        offset_peer*: InputPeerI
        limit*: int32
        hash*: int32
    MessagesGetHistory* = ref object of TLFunction
        peer*: InputPeerI
        offset_id*: int32
        offset_date*: int32
        add_offset*: int32
        limit*: int32
        max_id*: int32
        min_id*: int32
        hash*: int32
    MessagesSearch* = ref object of TLFunction
        flags: int32
        peer*: InputPeerI
        q*: string
        from_id*: Option[InputPeerI]
        top_msg_id*: Option[int32]
        filter*: MessagesFilterI
        min_date*: int32
        max_date*: int32
        offset_id*: int32
        add_offset*: int32
        limit*: int32
        max_id*: int32
        min_id*: int32
        hash*: int32
    MessagesReadHistory* = ref object of TLFunction
        peer*: InputPeerI
        max_id*: int32
    MessagesDeleteHistory* = ref object of TLFunction
        flags: int32
        just_clear*: bool
        revoke*: bool
        peer*: InputPeerI
        max_id*: int32
    MessagesDeleteMessages* = ref object of TLFunction
        flags: int32
        revoke*: bool
        id*: seq[int32]
    MessagesReceivedMessages* = ref object of TLFunction
        max_id*: int32
    MessagesSetTyping* = ref object of TLFunction
        flags: int32
        peer*: InputPeerI
        top_msg_id*: Option[int32]
        action*: SendMessageActionI
    MessagesSendMessage* = ref object of TLFunction
        flags: int32
        no_webpage*: bool
        silent*: bool
        background*: bool
        clear_draft*: bool
        peer*: InputPeerI
        reply_to_msg_id*: Option[int32]
        message*: string
        random_id*: int64
        reply_markup*: Option[ReplyMarkupI]
        entities*: Option[seq[MessageEntityI]]
        schedule_date*: Option[int32]
    MessagesSendMedia* = ref object of TLFunction
        flags: int32
        silent*: bool
        background*: bool
        clear_draft*: bool
        peer*: InputPeerI
        reply_to_msg_id*: Option[int32]
        media*: InputMediaI
        message*: string
        random_id*: int64
        reply_markup*: Option[ReplyMarkupI]
        entities*: Option[seq[MessageEntityI]]
        schedule_date*: Option[int32]
    MessagesForwardMessages* = ref object of TLFunction
        flags: int32
        silent*: bool
        background*: bool
        with_my_score*: bool
        from_peer*: InputPeerI
        id*: seq[int32]
        random_id*: seq[int64]
        to_peer*: InputPeerI
        schedule_date*: Option[int32]
    MessagesReportSpam* = ref object of TLFunction
        peer*: InputPeerI
    MessagesGetPeerSettings* = ref object of TLFunction
        peer*: InputPeerI
    MessagesReport* = ref object of TLFunction
        peer*: InputPeerI
        id*: seq[int32]
        reason*: ReportReasonI
        message*: string
    MessagesGetChats* = ref object of TLFunction
        id*: seq[int32]
    MessagesGetFullChat* = ref object of TLFunction
        chat_id*: int32
    MessagesEditChatTitle* = ref object of TLFunction
        chat_id*: int32
        title*: string
    MessagesEditChatPhoto* = ref object of TLFunction
        chat_id*: int32
        photo*: InputChatPhotoI
    MessagesAddChatUser* = ref object of TLFunction
        chat_id*: int32
        user_id*: InputUserI
        fwd_limit*: int32
    MessagesDeleteChatUser* = ref object of TLFunction
        flags: int32
        revoke_history*: bool
        chat_id*: int32
        user_id*: InputUserI
    MessagesCreateChat* = ref object of TLFunction
        users*: seq[InputUserI]
        title*: string
    MessagesGetDhConfig* = ref object of TLFunction
        version*: int32
        random_length*: int32
    MessagesRequestEncryption* = ref object of TLFunction
        user_id*: InputUserI
        random_id*: int32
        g_a*: seq[uint8]
    MessagesAcceptEncryption* = ref object of TLFunction
        peer*: InputEncryptedChatI
        g_b*: seq[uint8]
        key_fingerprint*: int64
    MessagesDiscardEncryption* = ref object of TLFunction
        flags: int32
        delete_history*: bool
        chat_id*: int32
    MessagesSetEncryptedTyping* = ref object of TLFunction
        peer*: InputEncryptedChatI
        typing*: bool
    MessagesReadEncryptedHistory* = ref object of TLFunction
        peer*: InputEncryptedChatI
        max_date*: int32
    MessagesSendEncrypted* = ref object of TLFunction
        flags: int32
        silent*: bool
        peer*: InputEncryptedChatI
        random_id*: int64
        data*: seq[uint8]
    MessagesSendEncryptedFile* = ref object of TLFunction
        flags: int32
        silent*: bool
        peer*: InputEncryptedChatI
        random_id*: int64
        data*: seq[uint8]
        file*: InputEncryptedFileI
    MessagesSendEncryptedService* = ref object of TLFunction
        peer*: InputEncryptedChatI
        random_id*: int64
        data*: seq[uint8]
    MessagesReceivedQueue* = ref object of TLFunction
        max_qts*: int32
    MessagesReportEncryptedSpam* = ref object of TLFunction
        peer*: InputEncryptedChatI
    MessagesReadMessageContents* = ref object of TLFunction
        id*: seq[int32]
    MessagesGetStickers* = ref object of TLFunction
        emoticon*: string
        hash*: int32
    MessagesGetAllStickers* = ref object of TLFunction
        hash*: int32
    MessagesGetWebPagePreview* = ref object of TLFunction
        flags: int32
        message*: string
        entities*: Option[seq[MessageEntityI]]
    MessagesExportChatInvite* = ref object of TLFunction
        flags: int32
        legacy_revoke_permanent*: bool
        peer*: InputPeerI
        expire_date*: Option[int32]
        usage_limit*: Option[int32]
    MessagesCheckChatInvite* = ref object of TLFunction
        hash*: string
    MessagesImportChatInvite* = ref object of TLFunction
        hash*: string
    MessagesGetStickerSet* = ref object of TLFunction
        stickerset*: InputStickerSetI
    MessagesInstallStickerSet* = ref object of TLFunction
        stickerset*: InputStickerSetI
        archived*: bool
    MessagesUninstallStickerSet* = ref object of TLFunction
        stickerset*: InputStickerSetI
    MessagesStartBot* = ref object of TLFunction
        bot*: InputUserI
        peer*: InputPeerI
        random_id*: int64
        start_param*: string
    MessagesGetMessagesViews* = ref object of TLFunction
        peer*: InputPeerI
        id*: seq[int32]
        increment*: bool
    MessagesEditChatAdmin* = ref object of TLFunction
        chat_id*: int32
        user_id*: InputUserI
        is_admin*: bool
    MessagesMigrateChat* = ref object of TLFunction
        chat_id*: int32
    MessagesSearchGlobal* = ref object of TLFunction
        flags: int32
        folder_id*: Option[int32]
        q*: string
        filter*: MessagesFilterI
        min_date*: int32
        max_date*: int32
        offset_rate*: int32
        offset_peer*: InputPeerI
        offset_id*: int32
        limit*: int32
    MessagesReorderStickerSets* = ref object of TLFunction
        flags: int32
        masks*: bool
        order*: seq[int64]
    MessagesGetDocumentByHash* = ref object of TLFunction
        sha256*: seq[uint8]
        size*: int32
        mime_type*: string
    MessagesGetSavedGifs* = ref object of TLFunction
        hash*: int32
    MessagesSaveGif* = ref object of TLFunction
        id*: InputDocumentI
        unsave*: bool
    MessagesGetInlineBotResults* = ref object of TLFunction
        flags: int32
        bot*: InputUserI
        peer*: InputPeerI
        geo_point*: Option[InputGeoPointI]
        query*: string
        offset*: string
    MessagesSetInlineBotResults* = ref object of TLFunction
        flags: int32
        gallery*: bool
        private*: bool
        query_id*: int64
        results*: seq[InputBotInlineResultI]
        cache_time*: int32
        next_offset*: Option[string]
        switch_pm*: Option[InlineBotSwitchPMI]
    MessagesSendInlineBotResult* = ref object of TLFunction
        flags: int32
        silent*: bool
        background*: bool
        clear_draft*: bool
        hide_via*: bool
        peer*: InputPeerI
        reply_to_msg_id*: Option[int32]
        random_id*: int64
        query_id*: int64
        id*: string
        schedule_date*: Option[int32]
    MessagesGetMessageEditData* = ref object of TLFunction
        peer*: InputPeerI
        id*: int32
    MessagesEditMessage* = ref object of TLFunction
        flags: int32
        no_webpage*: bool
        peer*: InputPeerI
        id*: int32
        message*: Option[string]
        media*: Option[InputMediaI]
        reply_markup*: Option[ReplyMarkupI]
        entities*: Option[seq[MessageEntityI]]
        schedule_date*: Option[int32]
    MessagesEditInlineBotMessage* = ref object of TLFunction
        flags: int32
        no_webpage*: bool
        id*: InputBotInlineMessageIDI
        message*: Option[string]
        media*: Option[InputMediaI]
        reply_markup*: Option[ReplyMarkupI]
        entities*: Option[seq[MessageEntityI]]
    MessagesGetBotCallbackAnswer* = ref object of TLFunction
        flags: int32
        game*: bool
        peer*: InputPeerI
        msg_id*: int32
        data*: Option[seq[uint8]]
        password*: Option[InputCheckPasswordSRPI]
    MessagesSetBotCallbackAnswer* = ref object of TLFunction
        flags: int32
        alert*: bool
        query_id*: int64
        message*: Option[string]
        url*: Option[string]
        cache_time*: int32
    MessagesGetPeerDialogs* = ref object of TLFunction
        peers*: seq[InputDialogPeerI]
    MessagesSaveDraft* = ref object of TLFunction
        flags: int32
        no_webpage*: bool
        reply_to_msg_id*: Option[int32]
        peer*: InputPeerI
        message*: string
        entities*: Option[seq[MessageEntityI]]
    MessagesGetAllDrafts* = ref object of TLFunction
    MessagesGetFeaturedStickers* = ref object of TLFunction
        hash*: int32
    MessagesReadFeaturedStickers* = ref object of TLFunction
        id*: seq[int64]
    MessagesGetRecentStickers* = ref object of TLFunction
        flags: int32
        attached*: bool
        hash*: int32
    MessagesSaveRecentSticker* = ref object of TLFunction
        flags: int32
        attached*: bool
        id*: InputDocumentI
        unsave*: bool
    MessagesClearRecentStickers* = ref object of TLFunction
        flags: int32
        attached*: bool
    MessagesGetArchivedStickers* = ref object of TLFunction
        flags: int32
        masks*: bool
        offset_id*: int64
        limit*: int32
    MessagesGetMaskStickers* = ref object of TLFunction
        hash*: int32
    MessagesGetAttachedStickers* = ref object of TLFunction
        media*: InputStickeredMediaI
    MessagesSetGameScore* = ref object of TLFunction
        flags: int32
        edit_message*: bool
        force*: bool
        peer*: InputPeerI
        id*: int32
        user_id*: InputUserI
        score*: int32
    MessagesSetInlineGameScore* = ref object of TLFunction
        flags: int32
        edit_message*: bool
        force*: bool
        id*: InputBotInlineMessageIDI
        user_id*: InputUserI
        score*: int32
    MessagesGetGameHighScores* = ref object of TLFunction
        peer*: InputPeerI
        id*: int32
        user_id*: InputUserI
    MessagesGetInlineGameHighScores* = ref object of TLFunction
        id*: InputBotInlineMessageIDI
        user_id*: InputUserI
    MessagesGetCommonChats* = ref object of TLFunction
        user_id*: InputUserI
        max_id*: int32
        limit*: int32
    MessagesGetAllChats* = ref object of TLFunction
        except_ids*: seq[int32]
    MessagesGetWebPage* = ref object of TLFunction
        url*: string
        hash*: int32
    MessagesToggleDialogPin* = ref object of TLFunction
        flags: int32
        pinned*: bool
        peer*: InputDialogPeerI
    MessagesReorderPinnedDialogs* = ref object of TLFunction
        flags: int32
        force*: bool
        folder_id*: int32
        order*: seq[InputDialogPeerI]
    MessagesGetPinnedDialogs* = ref object of TLFunction
        folder_id*: int32
    MessagesSetBotShippingResults* = ref object of TLFunction
        flags: int32
        query_id*: int64
        error*: Option[string]
        shipping_options*: Option[seq[ShippingOptionI]]
    MessagesSetBotPrecheckoutResults* = ref object of TLFunction
        flags: int32
        success*: bool
        query_id*: int64
        error*: Option[string]
    MessagesUploadMedia* = ref object of TLFunction
        peer*: InputPeerI
        media*: InputMediaI
    MessagesSendScreenshotNotification* = ref object of TLFunction
        peer*: InputPeerI
        reply_to_msg_id*: int32
        random_id*: int64
    MessagesGetFavedStickers* = ref object of TLFunction
        hash*: int32
    MessagesFaveSticker* = ref object of TLFunction
        id*: InputDocumentI
        unfave*: bool
    MessagesGetUnreadMentions* = ref object of TLFunction
        peer*: InputPeerI
        offset_id*: int32
        add_offset*: int32
        limit*: int32
        max_id*: int32
        min_id*: int32
    MessagesReadMentions* = ref object of TLFunction
        peer*: InputPeerI
    MessagesGetRecentLocations* = ref object of TLFunction
        peer*: InputPeerI
        limit*: int32
        hash*: int32
    MessagesSendMultiMedia* = ref object of TLFunction
        flags: int32
        silent*: bool
        background*: bool
        clear_draft*: bool
        peer*: InputPeerI
        reply_to_msg_id*: Option[int32]
        multi_media*: seq[InputSingleMediaI]
        schedule_date*: Option[int32]
    MessagesUploadEncryptedFile* = ref object of TLFunction
        peer*: InputEncryptedChatI
        file*: InputEncryptedFileI
    MessagesSearchStickerSets* = ref object of TLFunction
        flags: int32
        exclude_featured*: bool
        q*: string
        hash*: int32
    MessagesGetSplitRanges* = ref object of TLFunction
    MessagesMarkDialogUnread* = ref object of TLFunction
        flags: int32
        unread*: bool
        peer*: InputDialogPeerI
    MessagesGetDialogUnreadMarks* = ref object of TLFunction
    MessagesClearAllDrafts* = ref object of TLFunction
    MessagesUpdatePinnedMessage* = ref object of TLFunction
        flags: int32
        silent*: bool
        unpin*: bool
        pm_oneside*: bool
        peer*: InputPeerI
        id*: int32
    MessagesSendVote* = ref object of TLFunction
        peer*: InputPeerI
        msg_id*: int32
        options*: seq[seq[uint8]]
    MessagesGetPollResults* = ref object of TLFunction
        peer*: InputPeerI
        msg_id*: int32
    MessagesGetOnlines* = ref object of TLFunction
        peer*: InputPeerI
    MessagesGetStatsURL* = ref object of TLFunction
        flags: int32
        dark*: bool
        peer*: InputPeerI
        params*: string
    MessagesEditChatAbout* = ref object of TLFunction
        peer*: InputPeerI
        about*: string
    MessagesEditChatDefaultBannedRights* = ref object of TLFunction
        peer*: InputPeerI
        banned_rights*: ChatBannedRightsI
    MessagesGetEmojiKeywords* = ref object of TLFunction
        lang_code*: string
    MessagesGetEmojiKeywordsDifference* = ref object of TLFunction
        lang_code*: string
        from_version*: int32
    MessagesGetEmojiKeywordsLanguages* = ref object of TLFunction
        lang_codes*: seq[string]
    MessagesGetEmojiURL* = ref object of TLFunction
        lang_code*: string
    MessagesGetSearchCounters* = ref object of TLFunction
        peer*: InputPeerI
        filters*: seq[MessagesFilterI]
    MessagesRequestUrlAuth* = ref object of TLFunction
        peer*: InputPeerI
        msg_id*: int32
        button_id*: int32
    MessagesAcceptUrlAuth* = ref object of TLFunction
        flags: int32
        write_allowed*: bool
        peer*: InputPeerI
        msg_id*: int32
        button_id*: int32
    MessagesHidePeerSettingsBar* = ref object of TLFunction
        peer*: InputPeerI
    MessagesGetScheduledHistory* = ref object of TLFunction
        peer*: InputPeerI
        hash*: int32
    MessagesGetScheduledMessages* = ref object of TLFunction
        peer*: InputPeerI
        id*: seq[int32]
    MessagesSendScheduledMessages* = ref object of TLFunction
        peer*: InputPeerI
        id*: seq[int32]
    MessagesDeleteScheduledMessages* = ref object of TLFunction
        peer*: InputPeerI
        id*: seq[int32]
    MessagesGetPollVotes* = ref object of TLFunction
        flags: int32
        peer*: InputPeerI
        id*: int32
        option*: Option[seq[uint8]]
        offset*: Option[string]
        limit*: int32
    MessagesToggleStickerSets* = ref object of TLFunction
        flags: int32
        uninstall*: bool
        archive*: bool
        unarchive*: bool
        stickersets*: seq[InputStickerSetI]
    MessagesGetDialogFilters* = ref object of TLFunction
    MessagesGetSuggestedDialogFilters* = ref object of TLFunction
    MessagesUpdateDialogFilter* = ref object of TLFunction
        flags: int32
        id*: int32
        filter*: Option[DialogFilterI]
    MessagesUpdateDialogFiltersOrder* = ref object of TLFunction
        order*: seq[int32]
    MessagesGetOldFeaturedStickers* = ref object of TLFunction
        offset*: int32
        limit*: int32
        hash*: int32
    MessagesGetReplies* = ref object of TLFunction
        peer*: InputPeerI
        msg_id*: int32
        offset_id*: int32
        offset_date*: int32
        add_offset*: int32
        limit*: int32
        max_id*: int32
        min_id*: int32
        hash*: int32
    MessagesGetDiscussionMessage* = ref object of TLFunction
        peer*: InputPeerI
        msg_id*: int32
    MessagesReadDiscussion* = ref object of TLFunction
        peer*: InputPeerI
        msg_id*: int32
        read_max_id*: int32
    MessagesUnpinAllMessages* = ref object of TLFunction
        peer*: InputPeerI
    MessagesDeleteChat* = ref object of TLFunction
        chat_id*: int32
    MessagesDeletePhoneCallHistory* = ref object of TLFunction
        flags: int32
        revoke*: bool
    MessagesCheckHistoryImport* = ref object of TLFunction
        import_head*: string
    MessagesInitHistoryImport* = ref object of TLFunction
        peer*: InputPeerI
        file*: InputFileI
        media_count*: int32
    MessagesUploadImportedMedia* = ref object of TLFunction
        peer*: InputPeerI
        import_id*: int64
        file_name*: string
        media*: InputMediaI
    MessagesStartHistoryImport* = ref object of TLFunction
        peer*: InputPeerI
        import_id*: int64
    MessagesGetExportedChatInvites* = ref object of TLFunction
        flags: int32
        revoked*: bool
        peer*: InputPeerI
        admin_id*: InputUserI
        offset_date*: Option[int32]
        offset_link*: Option[string]
        limit*: int32
    MessagesEditExportedChatInvite* = ref object of TLFunction
        flags: int32
        revoked*: bool
        peer*: InputPeerI
        link*: string
        expire_date*: Option[int32]
        usage_limit*: Option[int32]
    MessagesDeleteRevokedExportedChatInvites* = ref object of TLFunction
        peer*: InputPeerI
        admin_id*: InputUserI
    MessagesDeleteExportedChatInvite* = ref object of TLFunction
        peer*: InputPeerI
        link*: string
    MessagesGetAdminsWithInvites* = ref object of TLFunction
        peer*: InputPeerI
    MessagesGetChatInviteImporters* = ref object of TLFunction
        peer*: InputPeerI
        link*: string
        offset_date*: int32
        offset_user*: InputUserI
        limit*: int32
    MessagesSetHistoryTTL* = ref object of TLFunction
        peer*: InputPeerI
        period*: int32
method getTypeName*(self: MessagesGetMessages): string = "MessagesGetMessages"
method getTypeName*(self: MessagesGetDialogs): string = "MessagesGetDialogs"
method getTypeName*(self: MessagesGetHistory): string = "MessagesGetHistory"
method getTypeName*(self: MessagesSearch): string = "MessagesSearch"
method getTypeName*(self: MessagesReadHistory): string = "MessagesReadHistory"
method getTypeName*(self: MessagesDeleteHistory): string = "MessagesDeleteHistory"
method getTypeName*(self: MessagesDeleteMessages): string = "MessagesDeleteMessages"
method getTypeName*(self: MessagesReceivedMessages): string = "MessagesReceivedMessages"
method getTypeName*(self: MessagesSetTyping): string = "MessagesSetTyping"
method getTypeName*(self: MessagesSendMessage): string = "MessagesSendMessage"
method getTypeName*(self: MessagesSendMedia): string = "MessagesSendMedia"
method getTypeName*(self: MessagesForwardMessages): string = "MessagesForwardMessages"
method getTypeName*(self: MessagesReportSpam): string = "MessagesReportSpam"
method getTypeName*(self: MessagesGetPeerSettings): string = "MessagesGetPeerSettings"
method getTypeName*(self: MessagesReport): string = "MessagesReport"
method getTypeName*(self: MessagesGetChats): string = "MessagesGetChats"
method getTypeName*(self: MessagesGetFullChat): string = "MessagesGetFullChat"
method getTypeName*(self: MessagesEditChatTitle): string = "MessagesEditChatTitle"
method getTypeName*(self: MessagesEditChatPhoto): string = "MessagesEditChatPhoto"
method getTypeName*(self: MessagesAddChatUser): string = "MessagesAddChatUser"
method getTypeName*(self: MessagesDeleteChatUser): string = "MessagesDeleteChatUser"
method getTypeName*(self: MessagesCreateChat): string = "MessagesCreateChat"
method getTypeName*(self: MessagesGetDhConfig): string = "MessagesGetDhConfig"
method getTypeName*(self: MessagesRequestEncryption): string = "MessagesRequestEncryption"
method getTypeName*(self: MessagesAcceptEncryption): string = "MessagesAcceptEncryption"
method getTypeName*(self: MessagesDiscardEncryption): string = "MessagesDiscardEncryption"
method getTypeName*(self: MessagesSetEncryptedTyping): string = "MessagesSetEncryptedTyping"
method getTypeName*(self: MessagesReadEncryptedHistory): string = "MessagesReadEncryptedHistory"
method getTypeName*(self: MessagesSendEncrypted): string = "MessagesSendEncrypted"
method getTypeName*(self: MessagesSendEncryptedFile): string = "MessagesSendEncryptedFile"
method getTypeName*(self: MessagesSendEncryptedService): string = "MessagesSendEncryptedService"
method getTypeName*(self: MessagesReceivedQueue): string = "MessagesReceivedQueue"
method getTypeName*(self: MessagesReportEncryptedSpam): string = "MessagesReportEncryptedSpam"
method getTypeName*(self: MessagesReadMessageContents): string = "MessagesReadMessageContents"
method getTypeName*(self: MessagesGetStickers): string = "MessagesGetStickers"
method getTypeName*(self: MessagesGetAllStickers): string = "MessagesGetAllStickers"
method getTypeName*(self: MessagesGetWebPagePreview): string = "MessagesGetWebPagePreview"
method getTypeName*(self: MessagesExportChatInvite): string = "MessagesExportChatInvite"
method getTypeName*(self: MessagesCheckChatInvite): string = "MessagesCheckChatInvite"
method getTypeName*(self: MessagesImportChatInvite): string = "MessagesImportChatInvite"
method getTypeName*(self: MessagesGetStickerSet): string = "MessagesGetStickerSet"
method getTypeName*(self: MessagesInstallStickerSet): string = "MessagesInstallStickerSet"
method getTypeName*(self: MessagesUninstallStickerSet): string = "MessagesUninstallStickerSet"
method getTypeName*(self: MessagesStartBot): string = "MessagesStartBot"
method getTypeName*(self: MessagesGetMessagesViews): string = "MessagesGetMessagesViews"
method getTypeName*(self: MessagesEditChatAdmin): string = "MessagesEditChatAdmin"
method getTypeName*(self: MessagesMigrateChat): string = "MessagesMigrateChat"
method getTypeName*(self: MessagesSearchGlobal): string = "MessagesSearchGlobal"
method getTypeName*(self: MessagesReorderStickerSets): string = "MessagesReorderStickerSets"
method getTypeName*(self: MessagesGetDocumentByHash): string = "MessagesGetDocumentByHash"
method getTypeName*(self: MessagesGetSavedGifs): string = "MessagesGetSavedGifs"
method getTypeName*(self: MessagesSaveGif): string = "MessagesSaveGif"
method getTypeName*(self: MessagesGetInlineBotResults): string = "MessagesGetInlineBotResults"
method getTypeName*(self: MessagesSetInlineBotResults): string = "MessagesSetInlineBotResults"
method getTypeName*(self: MessagesSendInlineBotResult): string = "MessagesSendInlineBotResult"
method getTypeName*(self: MessagesGetMessageEditData): string = "MessagesGetMessageEditData"
method getTypeName*(self: MessagesEditMessage): string = "MessagesEditMessage"
method getTypeName*(self: MessagesEditInlineBotMessage): string = "MessagesEditInlineBotMessage"
method getTypeName*(self: MessagesGetBotCallbackAnswer): string = "MessagesGetBotCallbackAnswer"
method getTypeName*(self: MessagesSetBotCallbackAnswer): string = "MessagesSetBotCallbackAnswer"
method getTypeName*(self: MessagesGetPeerDialogs): string = "MessagesGetPeerDialogs"
method getTypeName*(self: MessagesSaveDraft): string = "MessagesSaveDraft"
method getTypeName*(self: MessagesGetAllDrafts): string = "MessagesGetAllDrafts"
method getTypeName*(self: MessagesGetFeaturedStickers): string = "MessagesGetFeaturedStickers"
method getTypeName*(self: MessagesReadFeaturedStickers): string = "MessagesReadFeaturedStickers"
method getTypeName*(self: MessagesGetRecentStickers): string = "MessagesGetRecentStickers"
method getTypeName*(self: MessagesSaveRecentSticker): string = "MessagesSaveRecentSticker"
method getTypeName*(self: MessagesClearRecentStickers): string = "MessagesClearRecentStickers"
method getTypeName*(self: MessagesGetArchivedStickers): string = "MessagesGetArchivedStickers"
method getTypeName*(self: MessagesGetMaskStickers): string = "MessagesGetMaskStickers"
method getTypeName*(self: MessagesGetAttachedStickers): string = "MessagesGetAttachedStickers"
method getTypeName*(self: MessagesSetGameScore): string = "MessagesSetGameScore"
method getTypeName*(self: MessagesSetInlineGameScore): string = "MessagesSetInlineGameScore"
method getTypeName*(self: MessagesGetGameHighScores): string = "MessagesGetGameHighScores"
method getTypeName*(self: MessagesGetInlineGameHighScores): string = "MessagesGetInlineGameHighScores"
method getTypeName*(self: MessagesGetCommonChats): string = "MessagesGetCommonChats"
method getTypeName*(self: MessagesGetAllChats): string = "MessagesGetAllChats"
method getTypeName*(self: MessagesGetWebPage): string = "MessagesGetWebPage"
method getTypeName*(self: MessagesToggleDialogPin): string = "MessagesToggleDialogPin"
method getTypeName*(self: MessagesReorderPinnedDialogs): string = "MessagesReorderPinnedDialogs"
method getTypeName*(self: MessagesGetPinnedDialogs): string = "MessagesGetPinnedDialogs"
method getTypeName*(self: MessagesSetBotShippingResults): string = "MessagesSetBotShippingResults"
method getTypeName*(self: MessagesSetBotPrecheckoutResults): string = "MessagesSetBotPrecheckoutResults"
method getTypeName*(self: MessagesUploadMedia): string = "MessagesUploadMedia"
method getTypeName*(self: MessagesSendScreenshotNotification): string = "MessagesSendScreenshotNotification"
method getTypeName*(self: MessagesGetFavedStickers): string = "MessagesGetFavedStickers"
method getTypeName*(self: MessagesFaveSticker): string = "MessagesFaveSticker"
method getTypeName*(self: MessagesGetUnreadMentions): string = "MessagesGetUnreadMentions"
method getTypeName*(self: MessagesReadMentions): string = "MessagesReadMentions"
method getTypeName*(self: MessagesGetRecentLocations): string = "MessagesGetRecentLocations"
method getTypeName*(self: MessagesSendMultiMedia): string = "MessagesSendMultiMedia"
method getTypeName*(self: MessagesUploadEncryptedFile): string = "MessagesUploadEncryptedFile"
method getTypeName*(self: MessagesSearchStickerSets): string = "MessagesSearchStickerSets"
method getTypeName*(self: MessagesGetSplitRanges): string = "MessagesGetSplitRanges"
method getTypeName*(self: MessagesMarkDialogUnread): string = "MessagesMarkDialogUnread"
method getTypeName*(self: MessagesGetDialogUnreadMarks): string = "MessagesGetDialogUnreadMarks"
method getTypeName*(self: MessagesClearAllDrafts): string = "MessagesClearAllDrafts"
method getTypeName*(self: MessagesUpdatePinnedMessage): string = "MessagesUpdatePinnedMessage"
method getTypeName*(self: MessagesSendVote): string = "MessagesSendVote"
method getTypeName*(self: MessagesGetPollResults): string = "MessagesGetPollResults"
method getTypeName*(self: MessagesGetOnlines): string = "MessagesGetOnlines"
method getTypeName*(self: MessagesGetStatsURL): string = "MessagesGetStatsURL"
method getTypeName*(self: MessagesEditChatAbout): string = "MessagesEditChatAbout"
method getTypeName*(self: MessagesEditChatDefaultBannedRights): string = "MessagesEditChatDefaultBannedRights"
method getTypeName*(self: MessagesGetEmojiKeywords): string = "MessagesGetEmojiKeywords"
method getTypeName*(self: MessagesGetEmojiKeywordsDifference): string = "MessagesGetEmojiKeywordsDifference"
method getTypeName*(self: MessagesGetEmojiKeywordsLanguages): string = "MessagesGetEmojiKeywordsLanguages"
method getTypeName*(self: MessagesGetEmojiURL): string = "MessagesGetEmojiURL"
method getTypeName*(self: MessagesGetSearchCounters): string = "MessagesGetSearchCounters"
method getTypeName*(self: MessagesRequestUrlAuth): string = "MessagesRequestUrlAuth"
method getTypeName*(self: MessagesAcceptUrlAuth): string = "MessagesAcceptUrlAuth"
method getTypeName*(self: MessagesHidePeerSettingsBar): string = "MessagesHidePeerSettingsBar"
method getTypeName*(self: MessagesGetScheduledHistory): string = "MessagesGetScheduledHistory"
method getTypeName*(self: MessagesGetScheduledMessages): string = "MessagesGetScheduledMessages"
method getTypeName*(self: MessagesSendScheduledMessages): string = "MessagesSendScheduledMessages"
method getTypeName*(self: MessagesDeleteScheduledMessages): string = "MessagesDeleteScheduledMessages"
method getTypeName*(self: MessagesGetPollVotes): string = "MessagesGetPollVotes"
method getTypeName*(self: MessagesToggleStickerSets): string = "MessagesToggleStickerSets"
method getTypeName*(self: MessagesGetDialogFilters): string = "MessagesGetDialogFilters"
method getTypeName*(self: MessagesGetSuggestedDialogFilters): string = "MessagesGetSuggestedDialogFilters"
method getTypeName*(self: MessagesUpdateDialogFilter): string = "MessagesUpdateDialogFilter"
method getTypeName*(self: MessagesUpdateDialogFiltersOrder): string = "MessagesUpdateDialogFiltersOrder"
method getTypeName*(self: MessagesGetOldFeaturedStickers): string = "MessagesGetOldFeaturedStickers"
method getTypeName*(self: MessagesGetReplies): string = "MessagesGetReplies"
method getTypeName*(self: MessagesGetDiscussionMessage): string = "MessagesGetDiscussionMessage"
method getTypeName*(self: MessagesReadDiscussion): string = "MessagesReadDiscussion"
method getTypeName*(self: MessagesUnpinAllMessages): string = "MessagesUnpinAllMessages"
method getTypeName*(self: MessagesDeleteChat): string = "MessagesDeleteChat"
method getTypeName*(self: MessagesDeletePhoneCallHistory): string = "MessagesDeletePhoneCallHistory"
method getTypeName*(self: MessagesCheckHistoryImport): string = "MessagesCheckHistoryImport"
method getTypeName*(self: MessagesInitHistoryImport): string = "MessagesInitHistoryImport"
method getTypeName*(self: MessagesUploadImportedMedia): string = "MessagesUploadImportedMedia"
method getTypeName*(self: MessagesStartHistoryImport): string = "MessagesStartHistoryImport"
method getTypeName*(self: MessagesGetExportedChatInvites): string = "MessagesGetExportedChatInvites"
method getTypeName*(self: MessagesEditExportedChatInvite): string = "MessagesEditExportedChatInvite"
method getTypeName*(self: MessagesDeleteRevokedExportedChatInvites): string = "MessagesDeleteRevokedExportedChatInvites"
method getTypeName*(self: MessagesDeleteExportedChatInvite): string = "MessagesDeleteExportedChatInvite"
method getTypeName*(self: MessagesGetAdminsWithInvites): string = "MessagesGetAdminsWithInvites"
method getTypeName*(self: MessagesGetChatInviteImporters): string = "MessagesGetChatInviteImporters"
method getTypeName*(self: MessagesSetHistoryTTL): string = "MessagesSetHistoryTTL"

method TLEncode*(self: MessagesGetMessages): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x63c66506))
    result = result & TLEncode(cast[seq[TL]](self.id))
method TLDecode*(self: MessagesGetMessages, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.id = cast[seq[InputMessageI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesGetDialogs): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xa0ee3b73))
    if self.exclude_pinned:
        self.flags = self.flags or 1 shl 0
    if self.folder_id.isSome():
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    if self.folder_id.isSome():
        result = result & TLEncode(self.folder_id.get())
    result = result & TLEncode(self.offset_date)
    result = result & TLEncode(self.offset_id)
    result = result & TLEncode(self.offset_peer)
    result = result & TLEncode(self.limit)
    result = result & TLEncode(self.hash)
method TLDecode*(self: MessagesGetDialogs, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.exclude_pinned = true
    if (self.flags and (1 shl 1)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.folder_id = some(tempVal)
    bytes.TLDecode(addr self.offset_date)
    bytes.TLDecode(addr self.offset_id)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.offset_peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.limit)
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: MessagesGetHistory): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xdcbb8260))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.offset_id)
    result = result & TLEncode(self.offset_date)
    result = result & TLEncode(self.add_offset)
    result = result & TLEncode(self.limit)
    result = result & TLEncode(self.max_id)
    result = result & TLEncode(self.min_id)
    result = result & TLEncode(self.hash)
method TLDecode*(self: MessagesGetHistory, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.offset_id)
    bytes.TLDecode(addr self.offset_date)
    bytes.TLDecode(addr self.add_offset)
    bytes.TLDecode(addr self.limit)
    bytes.TLDecode(addr self.max_id)
    bytes.TLDecode(addr self.min_id)
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: MessagesSearch): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc352eec))
    if self.from_id.isSome():
        self.flags = self.flags or 1 shl 0
    if self.top_msg_id.isSome():
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.q)
    if self.from_id.isSome():
        result = result & TLEncode(self.from_id.get())
    if self.top_msg_id.isSome():
        result = result & TLEncode(self.top_msg_id.get())
    result = result & TLEncode(self.filter)
    result = result & TLEncode(self.min_date)
    result = result & TLEncode(self.max_date)
    result = result & TLEncode(self.offset_id)
    result = result & TLEncode(self.add_offset)
    result = result & TLEncode(self.limit)
    result = result & TLEncode(self.max_id)
    result = result & TLEncode(self.min_id)
    result = result & TLEncode(self.hash)
method TLDecode*(self: MessagesSearch, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    self.q = cast[string](bytes.TLDecode())
    if (self.flags and (1 shl 0)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.from_id = some(tempVal.InputPeerI)
    if (self.flags and (1 shl 1)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.top_msg_id = some(tempVal)
    tempObj.TLDecode(bytes)
    self.filter = cast[MessagesFilterI](tempObj)
    bytes.TLDecode(addr self.min_date)
    bytes.TLDecode(addr self.max_date)
    bytes.TLDecode(addr self.offset_id)
    bytes.TLDecode(addr self.add_offset)
    bytes.TLDecode(addr self.limit)
    bytes.TLDecode(addr self.max_id)
    bytes.TLDecode(addr self.min_id)
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: MessagesReadHistory): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xe306d3a))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.max_id)
method TLDecode*(self: MessagesReadHistory, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.max_id)
method TLEncode*(self: MessagesDeleteHistory): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x1c015b09))
    if self.just_clear:
        self.flags = self.flags or 1 shl 0
    if self.revoke:
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.max_id)
method TLDecode*(self: MessagesDeleteHistory, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.just_clear = true
    if (self.flags and (1 shl 1)) != 0:
        self.revoke = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.max_id)
method TLEncode*(self: MessagesDeleteMessages): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xe58e95d2))
    if self.revoke:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.id)
method TLDecode*(self: MessagesDeleteMessages, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.revoke = true
    bytes.TLDecode(self.id)
method TLEncode*(self: MessagesReceivedMessages): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x5a954c0))
    result = result & TLEncode(self.max_id)
method TLDecode*(self: MessagesReceivedMessages, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.max_id)
method TLEncode*(self: MessagesSetTyping): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x58943ee2))
    if self.top_msg_id.isSome():
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
    if self.top_msg_id.isSome():
        result = result & TLEncode(self.top_msg_id.get())
    result = result & TLEncode(self.action)
method TLDecode*(self: MessagesSetTyping, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    if (self.flags and (1 shl 0)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.top_msg_id = some(tempVal)
    tempObj.TLDecode(bytes)
    self.action = cast[SendMessageActionI](tempObj)
method TLEncode*(self: MessagesSendMessage): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x520c3870))
    if self.no_webpage:
        self.flags = self.flags or 1 shl 1
    if self.silent:
        self.flags = self.flags or 1 shl 5
    if self.background:
        self.flags = self.flags or 1 shl 6
    if self.clear_draft:
        self.flags = self.flags or 1 shl 7
    if self.reply_to_msg_id.isSome():
        self.flags = self.flags or 1 shl 0
    if self.reply_markup.isSome():
        self.flags = self.flags or 1 shl 2
    if self.entities.isSome():
        self.flags = self.flags or 1 shl 3
    if self.schedule_date.isSome():
        self.flags = self.flags or 1 shl 10
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
    if self.reply_to_msg_id.isSome():
        result = result & TLEncode(self.reply_to_msg_id.get())
    result = result & TLEncode(self.message)
    result = result & TLEncode(self.random_id)
    if self.reply_markup.isSome():
        result = result & TLEncode(self.reply_markup.get())
    if self.entities.isSome():
        result = result & TLEncode(cast[seq[TL]](self.entities.get()))
    if self.schedule_date.isSome():
        result = result & TLEncode(self.schedule_date.get())
method TLDecode*(self: MessagesSendMessage, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 1)) != 0:
        self.no_webpage = true
    if (self.flags and (1 shl 5)) != 0:
        self.silent = true
    if (self.flags and (1 shl 6)) != 0:
        self.background = true
    if (self.flags and (1 shl 7)) != 0:
        self.clear_draft = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    if (self.flags and (1 shl 0)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.reply_to_msg_id = some(tempVal)
    self.message = cast[string](bytes.TLDecode())
    bytes.TLDecode(addr self.random_id)
    if (self.flags and (1 shl 2)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.reply_markup = some(tempVal.ReplyMarkupI)
    if (self.flags and (1 shl 3)) != 0:
        var tempVal = newSeq[TL]()
        tempVal.TLDecode(bytes)
        self.entities = some(cast[seq[MessageEntityI]](tempVal))
    if (self.flags and (1 shl 10)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.schedule_date = some(tempVal)
method TLEncode*(self: MessagesSendMedia): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x3491eba9))
    if self.silent:
        self.flags = self.flags or 1 shl 5
    if self.background:
        self.flags = self.flags or 1 shl 6
    if self.clear_draft:
        self.flags = self.flags or 1 shl 7
    if self.reply_to_msg_id.isSome():
        self.flags = self.flags or 1 shl 0
    if self.reply_markup.isSome():
        self.flags = self.flags or 1 shl 2
    if self.entities.isSome():
        self.flags = self.flags or 1 shl 3
    if self.schedule_date.isSome():
        self.flags = self.flags or 1 shl 10
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
    if self.reply_to_msg_id.isSome():
        result = result & TLEncode(self.reply_to_msg_id.get())
    result = result & TLEncode(self.media)
    result = result & TLEncode(self.message)
    result = result & TLEncode(self.random_id)
    if self.reply_markup.isSome():
        result = result & TLEncode(self.reply_markup.get())
    if self.entities.isSome():
        result = result & TLEncode(cast[seq[TL]](self.entities.get()))
    if self.schedule_date.isSome():
        result = result & TLEncode(self.schedule_date.get())
method TLDecode*(self: MessagesSendMedia, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 5)) != 0:
        self.silent = true
    if (self.flags and (1 shl 6)) != 0:
        self.background = true
    if (self.flags and (1 shl 7)) != 0:
        self.clear_draft = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    if (self.flags and (1 shl 0)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.reply_to_msg_id = some(tempVal)
    tempObj.TLDecode(bytes)
    self.media = cast[InputMediaI](tempObj)
    self.message = cast[string](bytes.TLDecode())
    bytes.TLDecode(addr self.random_id)
    if (self.flags and (1 shl 2)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.reply_markup = some(tempVal.ReplyMarkupI)
    if (self.flags and (1 shl 3)) != 0:
        var tempVal = newSeq[TL]()
        tempVal.TLDecode(bytes)
        self.entities = some(cast[seq[MessageEntityI]](tempVal))
    if (self.flags and (1 shl 10)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.schedule_date = some(tempVal)
method TLEncode*(self: MessagesForwardMessages): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xd9fee60e))
    if self.silent:
        self.flags = self.flags or 1 shl 5
    if self.background:
        self.flags = self.flags or 1 shl 6
    if self.with_my_score:
        self.flags = self.flags or 1 shl 8
    if self.schedule_date.isSome():
        self.flags = self.flags or 1 shl 10
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.from_peer)
    result = result & TLEncode(self.id)
    result = result & TLEncode(self.random_id)
    result = result & TLEncode(self.to_peer)
    if self.schedule_date.isSome():
        result = result & TLEncode(self.schedule_date.get())
method TLDecode*(self: MessagesForwardMessages, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 5)) != 0:
        self.silent = true
    if (self.flags and (1 shl 6)) != 0:
        self.background = true
    if (self.flags and (1 shl 8)) != 0:
        self.with_my_score = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.from_peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(self.id)
    bytes.TLDecode(self.random_id)
    tempObj.TLDecode(bytes)
    self.to_peer = cast[InputPeerI](tempObj)
    if (self.flags and (1 shl 10)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.schedule_date = some(tempVal)
method TLEncode*(self: MessagesReportSpam): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xcf1592db))
    result = result & TLEncode(self.peer)
method TLDecode*(self: MessagesReportSpam, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
method TLEncode*(self: MessagesGetPeerSettings): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x3672e09c))
    result = result & TLEncode(self.peer)
method TLDecode*(self: MessagesGetPeerSettings, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
method TLEncode*(self: MessagesReport): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x8953ab4e))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.id)
    result = result & TLEncode(self.reason)
    result = result & TLEncode(self.message)
method TLDecode*(self: MessagesReport, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(self.id)
    tempObj.TLDecode(bytes)
    self.reason = cast[ReportReasonI](tempObj)
    self.message = cast[string](bytes.TLDecode())
method TLEncode*(self: MessagesGetChats): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x3c6aa187))
    result = result & TLEncode(self.id)
method TLDecode*(self: MessagesGetChats, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(self.id)
method TLEncode*(self: MessagesGetFullChat): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x3b831c66))
    result = result & TLEncode(self.chat_id)
method TLDecode*(self: MessagesGetFullChat, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.chat_id)
method TLEncode*(self: MessagesEditChatTitle): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xdc452855))
    result = result & TLEncode(self.chat_id)
    result = result & TLEncode(self.title)
method TLDecode*(self: MessagesEditChatTitle, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.chat_id)
    self.title = cast[string](bytes.TLDecode())
method TLEncode*(self: MessagesEditChatPhoto): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xca4c79d8))
    result = result & TLEncode(self.chat_id)
    result = result & TLEncode(self.photo)
method TLDecode*(self: MessagesEditChatPhoto, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.chat_id)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.photo = cast[InputChatPhotoI](tempObj)
method TLEncode*(self: MessagesAddChatUser): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf9a0aa09))
    result = result & TLEncode(self.chat_id)
    result = result & TLEncode(self.user_id)
    result = result & TLEncode(self.fwd_limit)
method TLDecode*(self: MessagesAddChatUser, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.chat_id)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.user_id = cast[InputUserI](tempObj)
    bytes.TLDecode(addr self.fwd_limit)
method TLEncode*(self: MessagesDeleteChatUser): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc534459a))
    if self.revoke_history:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.chat_id)
    result = result & TLEncode(self.user_id)
method TLDecode*(self: MessagesDeleteChatUser, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.revoke_history = true
    bytes.TLDecode(addr self.chat_id)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.user_id = cast[InputUserI](tempObj)
method TLEncode*(self: MessagesCreateChat): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x9cb126e))
    result = result & TLEncode(cast[seq[TL]](self.users))
    result = result & TLEncode(self.title)
method TLDecode*(self: MessagesCreateChat, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.users = cast[seq[InputUserI]](tempVector)
    tempVector.setLen(0)
    self.title = cast[string](bytes.TLDecode())
method TLEncode*(self: MessagesGetDhConfig): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x26cf8950))
    result = result & TLEncode(self.version)
    result = result & TLEncode(self.random_length)
method TLDecode*(self: MessagesGetDhConfig, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.version)
    bytes.TLDecode(addr self.random_length)
method TLEncode*(self: MessagesRequestEncryption): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf64daf43))
    result = result & TLEncode(self.user_id)
    result = result & TLEncode(self.random_id)
    result = result & TLEncode(self.g_a)
method TLDecode*(self: MessagesRequestEncryption, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.user_id = cast[InputUserI](tempObj)
    bytes.TLDecode(addr self.random_id)
    self.g_a = bytes.TLDecode()
method TLEncode*(self: MessagesAcceptEncryption): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x3dbc0415))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.g_b)
    result = result & TLEncode(self.key_fingerprint)
method TLDecode*(self: MessagesAcceptEncryption, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputEncryptedChatI](tempObj)
    self.g_b = bytes.TLDecode()
    bytes.TLDecode(addr self.key_fingerprint)
method TLEncode*(self: MessagesDiscardEncryption): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf393aea0))
    if self.delete_history:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.chat_id)
method TLDecode*(self: MessagesDiscardEncryption, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.delete_history = true
    bytes.TLDecode(addr self.chat_id)
method TLEncode*(self: MessagesSetEncryptedTyping): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x791451ed))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.typing)
method TLDecode*(self: MessagesSetEncryptedTyping, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputEncryptedChatI](tempObj)
    bytes.TLDecode(self.typing)
method TLEncode*(self: MessagesReadEncryptedHistory): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x7f4b690a))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.max_date)
method TLDecode*(self: MessagesReadEncryptedHistory, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputEncryptedChatI](tempObj)
    bytes.TLDecode(addr self.max_date)
method TLEncode*(self: MessagesSendEncrypted): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x44fa7a15))
    if self.silent:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.random_id)
    result = result & TLEncode(self.data)
method TLDecode*(self: MessagesSendEncrypted, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.silent = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputEncryptedChatI](tempObj)
    bytes.TLDecode(addr self.random_id)
    self.data = bytes.TLDecode()
method TLEncode*(self: MessagesSendEncryptedFile): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x5559481d))
    if self.silent:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.random_id)
    result = result & TLEncode(self.data)
    result = result & TLEncode(self.file)
method TLDecode*(self: MessagesSendEncryptedFile, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.silent = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputEncryptedChatI](tempObj)
    bytes.TLDecode(addr self.random_id)
    self.data = bytes.TLDecode()
    tempObj.TLDecode(bytes)
    self.file = cast[InputEncryptedFileI](tempObj)
method TLEncode*(self: MessagesSendEncryptedService): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x32d439a4))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.random_id)
    result = result & TLEncode(self.data)
method TLDecode*(self: MessagesSendEncryptedService, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputEncryptedChatI](tempObj)
    bytes.TLDecode(addr self.random_id)
    self.data = bytes.TLDecode()
method TLEncode*(self: MessagesReceivedQueue): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x55a5bb66))
    result = result & TLEncode(self.max_qts)
method TLDecode*(self: MessagesReceivedQueue, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.max_qts)
method TLEncode*(self: MessagesReportEncryptedSpam): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x4b0c8c0f))
    result = result & TLEncode(self.peer)
method TLDecode*(self: MessagesReportEncryptedSpam, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputEncryptedChatI](tempObj)
method TLEncode*(self: MessagesReadMessageContents): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x36a73f77))
    result = result & TLEncode(self.id)
method TLDecode*(self: MessagesReadMessageContents, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(self.id)
method TLEncode*(self: MessagesGetStickers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x43d4f2c))
    result = result & TLEncode(self.emoticon)
    result = result & TLEncode(self.hash)
method TLDecode*(self: MessagesGetStickers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.emoticon = cast[string](bytes.TLDecode())
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: MessagesGetAllStickers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x1c9618b1))
    result = result & TLEncode(self.hash)
method TLDecode*(self: MessagesGetAllStickers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: MessagesGetWebPagePreview): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x8b68b0cc))
    if self.entities.isSome():
        self.flags = self.flags or 1 shl 3
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.message)
    if self.entities.isSome():
        result = result & TLEncode(cast[seq[TL]](self.entities.get()))
method TLDecode*(self: MessagesGetWebPagePreview, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    self.message = cast[string](bytes.TLDecode())
    if (self.flags and (1 shl 3)) != 0:
        var tempVal = newSeq[TL]()
        tempVal.TLDecode(bytes)
        self.entities = some(cast[seq[MessageEntityI]](tempVal))
method TLEncode*(self: MessagesExportChatInvite): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x14b9bcd7))
    if self.legacy_revoke_permanent:
        self.flags = self.flags or 1 shl 2
    if self.expire_date.isSome():
        self.flags = self.flags or 1 shl 0
    if self.usage_limit.isSome():
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
    if self.expire_date.isSome():
        result = result & TLEncode(self.expire_date.get())
    if self.usage_limit.isSome():
        result = result & TLEncode(self.usage_limit.get())
method TLDecode*(self: MessagesExportChatInvite, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 2)) != 0:
        self.legacy_revoke_permanent = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    if (self.flags and (1 shl 0)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.expire_date = some(tempVal)
    if (self.flags and (1 shl 1)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.usage_limit = some(tempVal)
method TLEncode*(self: MessagesCheckChatInvite): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x3eadb1bb))
    result = result & TLEncode(self.hash)
method TLDecode*(self: MessagesCheckChatInvite, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.hash = cast[string](bytes.TLDecode())
method TLEncode*(self: MessagesImportChatInvite): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x6c50051c))
    result = result & TLEncode(self.hash)
method TLDecode*(self: MessagesImportChatInvite, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.hash = cast[string](bytes.TLDecode())
method TLEncode*(self: MessagesGetStickerSet): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x2619a90e))
    result = result & TLEncode(self.stickerset)
method TLDecode*(self: MessagesGetStickerSet, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.stickerset = cast[InputStickerSetI](tempObj)
method TLEncode*(self: MessagesInstallStickerSet): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc78fe460))
    result = result & TLEncode(self.stickerset)
    result = result & TLEncode(self.archived)
method TLDecode*(self: MessagesInstallStickerSet, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.stickerset = cast[InputStickerSetI](tempObj)
    bytes.TLDecode(self.archived)
method TLEncode*(self: MessagesUninstallStickerSet): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf96e55de))
    result = result & TLEncode(self.stickerset)
method TLDecode*(self: MessagesUninstallStickerSet, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.stickerset = cast[InputStickerSetI](tempObj)
method TLEncode*(self: MessagesStartBot): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xe6df7378))
    result = result & TLEncode(self.bot)
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.random_id)
    result = result & TLEncode(self.start_param)
method TLDecode*(self: MessagesStartBot, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.bot = cast[InputUserI](tempObj)
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.random_id)
    self.start_param = cast[string](bytes.TLDecode())
method TLEncode*(self: MessagesGetMessagesViews): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x5784d3e1))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.id)
    result = result & TLEncode(self.increment)
method TLDecode*(self: MessagesGetMessagesViews, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(self.id)
    bytes.TLDecode(self.increment)
method TLEncode*(self: MessagesEditChatAdmin): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xa9e69f2e))
    result = result & TLEncode(self.chat_id)
    result = result & TLEncode(self.user_id)
    result = result & TLEncode(self.is_admin)
method TLDecode*(self: MessagesEditChatAdmin, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.chat_id)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.user_id = cast[InputUserI](tempObj)
    bytes.TLDecode(self.is_admin)
method TLEncode*(self: MessagesMigrateChat): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x15a3b8e3))
    result = result & TLEncode(self.chat_id)
method TLDecode*(self: MessagesMigrateChat, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.chat_id)
method TLEncode*(self: MessagesSearchGlobal): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x4bc6589a))
    if self.folder_id.isSome():
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    if self.folder_id.isSome():
        result = result & TLEncode(self.folder_id.get())
    result = result & TLEncode(self.q)
    result = result & TLEncode(self.filter)
    result = result & TLEncode(self.min_date)
    result = result & TLEncode(self.max_date)
    result = result & TLEncode(self.offset_rate)
    result = result & TLEncode(self.offset_peer)
    result = result & TLEncode(self.offset_id)
    result = result & TLEncode(self.limit)
method TLDecode*(self: MessagesSearchGlobal, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.folder_id = some(tempVal)
    self.q = cast[string](bytes.TLDecode())
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.filter = cast[MessagesFilterI](tempObj)
    bytes.TLDecode(addr self.min_date)
    bytes.TLDecode(addr self.max_date)
    bytes.TLDecode(addr self.offset_rate)
    tempObj.TLDecode(bytes)
    self.offset_peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.offset_id)
    bytes.TLDecode(addr self.limit)
method TLEncode*(self: MessagesReorderStickerSets): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x78337739))
    if self.masks:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.order)
method TLDecode*(self: MessagesReorderStickerSets, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.masks = true
    bytes.TLDecode(self.order)
method TLEncode*(self: MessagesGetDocumentByHash): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x338e2464))
    result = result & TLEncode(self.sha256)
    result = result & TLEncode(self.size)
    result = result & TLEncode(self.mime_type)
method TLDecode*(self: MessagesGetDocumentByHash, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.sha256 = bytes.TLDecode()
    bytes.TLDecode(addr self.size)
    self.mime_type = cast[string](bytes.TLDecode())
method TLEncode*(self: MessagesGetSavedGifs): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x83bf3d52))
    result = result & TLEncode(self.hash)
method TLDecode*(self: MessagesGetSavedGifs, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: MessagesSaveGif): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x327a30cb))
    result = result & TLEncode(self.id)
    result = result & TLEncode(self.unsave)
method TLDecode*(self: MessagesSaveGif, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.id = cast[InputDocumentI](tempObj)
    bytes.TLDecode(self.unsave)
method TLEncode*(self: MessagesGetInlineBotResults): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x514e999d))
    if self.geo_point.isSome():
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.bot)
    result = result & TLEncode(self.peer)
    if self.geo_point.isSome():
        result = result & TLEncode(self.geo_point.get())
    result = result & TLEncode(self.query)
    result = result & TLEncode(self.offset)
method TLDecode*(self: MessagesGetInlineBotResults, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.bot = cast[InputUserI](tempObj)
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    if (self.flags and (1 shl 0)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.geo_point = some(tempVal.InputGeoPointI)
    self.query = cast[string](bytes.TLDecode())
    self.offset = cast[string](bytes.TLDecode())
method TLEncode*(self: MessagesSetInlineBotResults): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xeb5ea206))
    if self.gallery:
        self.flags = self.flags or 1 shl 0
    if self.private:
        self.flags = self.flags or 1 shl 1
    if self.next_offset.isSome():
        self.flags = self.flags or 1 shl 2
    if self.switch_pm.isSome():
        self.flags = self.flags or 1 shl 3
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.query_id)
    result = result & TLEncode(cast[seq[TL]](self.results))
    result = result & TLEncode(self.cache_time)
    if self.next_offset.isSome():
        result = result & TLEncode(self.next_offset.get())
    if self.switch_pm.isSome():
        result = result & TLEncode(self.switch_pm.get())
method TLDecode*(self: MessagesSetInlineBotResults, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.gallery = true
    if (self.flags and (1 shl 1)) != 0:
        self.private = true
    bytes.TLDecode(addr self.query_id)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.results = cast[seq[InputBotInlineResultI]](tempVector)
    tempVector.setLen(0)
    bytes.TLDecode(addr self.cache_time)
    if (self.flags and (1 shl 2)) != 0:
        self.next_offset = some(cast[string](bytes.TLDecode()))
    if (self.flags and (1 shl 3)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.switch_pm = some(tempVal.InlineBotSwitchPMI)
method TLEncode*(self: MessagesSendInlineBotResult): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x220815b0))
    if self.silent:
        self.flags = self.flags or 1 shl 5
    if self.background:
        self.flags = self.flags or 1 shl 6
    if self.clear_draft:
        self.flags = self.flags or 1 shl 7
    if self.hide_via:
        self.flags = self.flags or 1 shl 11
    if self.reply_to_msg_id.isSome():
        self.flags = self.flags or 1 shl 0
    if self.schedule_date.isSome():
        self.flags = self.flags or 1 shl 10
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
    if self.reply_to_msg_id.isSome():
        result = result & TLEncode(self.reply_to_msg_id.get())
    result = result & TLEncode(self.random_id)
    result = result & TLEncode(self.query_id)
    result = result & TLEncode(self.id)
    if self.schedule_date.isSome():
        result = result & TLEncode(self.schedule_date.get())
method TLDecode*(self: MessagesSendInlineBotResult, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 5)) != 0:
        self.silent = true
    if (self.flags and (1 shl 6)) != 0:
        self.background = true
    if (self.flags and (1 shl 7)) != 0:
        self.clear_draft = true
    if (self.flags and (1 shl 11)) != 0:
        self.hide_via = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    if (self.flags and (1 shl 0)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.reply_to_msg_id = some(tempVal)
    bytes.TLDecode(addr self.random_id)
    bytes.TLDecode(addr self.query_id)
    self.id = cast[string](bytes.TLDecode())
    if (self.flags and (1 shl 10)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.schedule_date = some(tempVal)
method TLEncode*(self: MessagesGetMessageEditData): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xfda68d36))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.id)
method TLDecode*(self: MessagesGetMessageEditData, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.id)
method TLEncode*(self: MessagesEditMessage): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x48f71778))
    if self.no_webpage:
        self.flags = self.flags or 1 shl 1
    if self.message.isSome():
        self.flags = self.flags or 1 shl 11
    if self.media.isSome():
        self.flags = self.flags or 1 shl 14
    if self.reply_markup.isSome():
        self.flags = self.flags or 1 shl 2
    if self.entities.isSome():
        self.flags = self.flags or 1 shl 3
    if self.schedule_date.isSome():
        self.flags = self.flags or 1 shl 15
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.id)
    if self.message.isSome():
        result = result & TLEncode(self.message.get())
    if self.media.isSome():
        result = result & TLEncode(self.media.get())
    if self.reply_markup.isSome():
        result = result & TLEncode(self.reply_markup.get())
    if self.entities.isSome():
        result = result & TLEncode(cast[seq[TL]](self.entities.get()))
    if self.schedule_date.isSome():
        result = result & TLEncode(self.schedule_date.get())
method TLDecode*(self: MessagesEditMessage, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 1)) != 0:
        self.no_webpage = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.id)
    if (self.flags and (1 shl 11)) != 0:
        self.message = some(cast[string](bytes.TLDecode()))
    if (self.flags and (1 shl 14)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.media = some(tempVal.InputMediaI)
    if (self.flags and (1 shl 2)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.reply_markup = some(tempVal.ReplyMarkupI)
    if (self.flags and (1 shl 3)) != 0:
        var tempVal = newSeq[TL]()
        tempVal.TLDecode(bytes)
        self.entities = some(cast[seq[MessageEntityI]](tempVal))
    if (self.flags and (1 shl 15)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.schedule_date = some(tempVal)
method TLEncode*(self: MessagesEditInlineBotMessage): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x83557dba))
    if self.no_webpage:
        self.flags = self.flags or 1 shl 1
    if self.message.isSome():
        self.flags = self.flags or 1 shl 11
    if self.media.isSome():
        self.flags = self.flags or 1 shl 14
    if self.reply_markup.isSome():
        self.flags = self.flags or 1 shl 2
    if self.entities.isSome():
        self.flags = self.flags or 1 shl 3
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.id)
    if self.message.isSome():
        result = result & TLEncode(self.message.get())
    if self.media.isSome():
        result = result & TLEncode(self.media.get())
    if self.reply_markup.isSome():
        result = result & TLEncode(self.reply_markup.get())
    if self.entities.isSome():
        result = result & TLEncode(cast[seq[TL]](self.entities.get()))
method TLDecode*(self: MessagesEditInlineBotMessage, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 1)) != 0:
        self.no_webpage = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.id = cast[InputBotInlineMessageIDI](tempObj)
    if (self.flags and (1 shl 11)) != 0:
        self.message = some(cast[string](bytes.TLDecode()))
    if (self.flags and (1 shl 14)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.media = some(tempVal.InputMediaI)
    if (self.flags and (1 shl 2)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.reply_markup = some(tempVal.ReplyMarkupI)
    if (self.flags and (1 shl 3)) != 0:
        var tempVal = newSeq[TL]()
        tempVal.TLDecode(bytes)
        self.entities = some(cast[seq[MessageEntityI]](tempVal))
method TLEncode*(self: MessagesGetBotCallbackAnswer): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x9342ca07))
    if self.game:
        self.flags = self.flags or 1 shl 1
    if self.data.isSome():
        self.flags = self.flags or 1 shl 0
    if self.password.isSome():
        self.flags = self.flags or 1 shl 2
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.msg_id)
    if self.data.isSome():
        result = result & TLEncode(self.data.get())
    if self.password.isSome():
        result = result & TLEncode(self.password.get())
method TLDecode*(self: MessagesGetBotCallbackAnswer, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 1)) != 0:
        self.game = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.msg_id)
    if (self.flags and (1 shl 0)) != 0:
        self.data = some(bytes.TLDecode())
    if (self.flags and (1 shl 2)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.password = some(tempVal.InputCheckPasswordSRPI)
method TLEncode*(self: MessagesSetBotCallbackAnswer): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xd58f130a))
    if self.alert:
        self.flags = self.flags or 1 shl 1
    if self.message.isSome():
        self.flags = self.flags or 1 shl 0
    if self.url.isSome():
        self.flags = self.flags or 1 shl 2
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.query_id)
    if self.message.isSome():
        result = result & TLEncode(self.message.get())
    if self.url.isSome():
        result = result & TLEncode(self.url.get())
    result = result & TLEncode(self.cache_time)
method TLDecode*(self: MessagesSetBotCallbackAnswer, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 1)) != 0:
        self.alert = true
    bytes.TLDecode(addr self.query_id)
    if (self.flags and (1 shl 0)) != 0:
        self.message = some(cast[string](bytes.TLDecode()))
    if (self.flags and (1 shl 2)) != 0:
        self.url = some(cast[string](bytes.TLDecode()))
    bytes.TLDecode(addr self.cache_time)
method TLEncode*(self: MessagesGetPeerDialogs): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xe470bcfd))
    result = result & TLEncode(cast[seq[TL]](self.peers))
method TLDecode*(self: MessagesGetPeerDialogs, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.peers = cast[seq[InputDialogPeerI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesSaveDraft): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xbc39e14b))
    if self.no_webpage:
        self.flags = self.flags or 1 shl 1
    if self.reply_to_msg_id.isSome():
        self.flags = self.flags or 1 shl 0
    if self.entities.isSome():
        self.flags = self.flags or 1 shl 3
    result = result & TLEncode(self.flags)
    if self.reply_to_msg_id.isSome():
        result = result & TLEncode(self.reply_to_msg_id.get())
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.message)
    if self.entities.isSome():
        result = result & TLEncode(cast[seq[TL]](self.entities.get()))
method TLDecode*(self: MessagesSaveDraft, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 1)) != 0:
        self.no_webpage = true
    if (self.flags and (1 shl 0)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.reply_to_msg_id = some(tempVal)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    self.message = cast[string](bytes.TLDecode())
    if (self.flags and (1 shl 3)) != 0:
        var tempVal = newSeq[TL]()
        tempVal.TLDecode(bytes)
        self.entities = some(cast[seq[MessageEntityI]](tempVal))
method TLEncode*(self: MessagesGetAllDrafts): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x6a3f8d65))
method TLDecode*(self: MessagesGetAllDrafts, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: MessagesGetFeaturedStickers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x2dacca4f))
    result = result & TLEncode(self.hash)
method TLDecode*(self: MessagesGetFeaturedStickers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: MessagesReadFeaturedStickers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x5b118126))
    result = result & TLEncode(self.id)
method TLDecode*(self: MessagesReadFeaturedStickers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(self.id)
method TLEncode*(self: MessagesGetRecentStickers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x5ea192c9))
    if self.attached:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.hash)
method TLDecode*(self: MessagesGetRecentStickers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.attached = true
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: MessagesSaveRecentSticker): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x392718f8))
    if self.attached:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.id)
    result = result & TLEncode(self.unsave)
method TLDecode*(self: MessagesSaveRecentSticker, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.attached = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.id = cast[InputDocumentI](tempObj)
    bytes.TLDecode(self.unsave)
method TLEncode*(self: MessagesClearRecentStickers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x8999602d))
    if self.attached:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
method TLDecode*(self: MessagesClearRecentStickers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.attached = true
method TLEncode*(self: MessagesGetArchivedStickers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x57f17692))
    if self.masks:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.offset_id)
    result = result & TLEncode(self.limit)
method TLDecode*(self: MessagesGetArchivedStickers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.masks = true
    bytes.TLDecode(addr self.offset_id)
    bytes.TLDecode(addr self.limit)
method TLEncode*(self: MessagesGetMaskStickers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x65b8c79f))
    result = result & TLEncode(self.hash)
method TLDecode*(self: MessagesGetMaskStickers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: MessagesGetAttachedStickers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xcc5b67cc))
    result = result & TLEncode(self.media)
method TLDecode*(self: MessagesGetAttachedStickers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.media = cast[InputStickeredMediaI](tempObj)
method TLEncode*(self: MessagesSetGameScore): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x8ef8ecc0))
    if self.edit_message:
        self.flags = self.flags or 1 shl 0
    if self.force:
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.id)
    result = result & TLEncode(self.user_id)
    result = result & TLEncode(self.score)
method TLDecode*(self: MessagesSetGameScore, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.edit_message = true
    if (self.flags and (1 shl 1)) != 0:
        self.force = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.id)
    tempObj.TLDecode(bytes)
    self.user_id = cast[InputUserI](tempObj)
    bytes.TLDecode(addr self.score)
method TLEncode*(self: MessagesSetInlineGameScore): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x15ad9f64))
    if self.edit_message:
        self.flags = self.flags or 1 shl 0
    if self.force:
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.id)
    result = result & TLEncode(self.user_id)
    result = result & TLEncode(self.score)
method TLDecode*(self: MessagesSetInlineGameScore, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.edit_message = true
    if (self.flags and (1 shl 1)) != 0:
        self.force = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.id = cast[InputBotInlineMessageIDI](tempObj)
    tempObj.TLDecode(bytes)
    self.user_id = cast[InputUserI](tempObj)
    bytes.TLDecode(addr self.score)
method TLEncode*(self: MessagesGetGameHighScores): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xe822649d))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.id)
    result = result & TLEncode(self.user_id)
method TLDecode*(self: MessagesGetGameHighScores, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.id)
    tempObj.TLDecode(bytes)
    self.user_id = cast[InputUserI](tempObj)
method TLEncode*(self: MessagesGetInlineGameHighScores): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf635e1b))
    result = result & TLEncode(self.id)
    result = result & TLEncode(self.user_id)
method TLDecode*(self: MessagesGetInlineGameHighScores, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.id = cast[InputBotInlineMessageIDI](tempObj)
    tempObj.TLDecode(bytes)
    self.user_id = cast[InputUserI](tempObj)
method TLEncode*(self: MessagesGetCommonChats): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xd0a48c4))
    result = result & TLEncode(self.user_id)
    result = result & TLEncode(self.max_id)
    result = result & TLEncode(self.limit)
method TLDecode*(self: MessagesGetCommonChats, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.user_id = cast[InputUserI](tempObj)
    bytes.TLDecode(addr self.max_id)
    bytes.TLDecode(addr self.limit)
method TLEncode*(self: MessagesGetAllChats): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xeba80ff0))
    result = result & TLEncode(self.except_ids)
method TLDecode*(self: MessagesGetAllChats, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(self.except_ids)
method TLEncode*(self: MessagesGetWebPage): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x32ca8f91))
    result = result & TLEncode(self.url)
    result = result & TLEncode(self.hash)
method TLDecode*(self: MessagesGetWebPage, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.url = cast[string](bytes.TLDecode())
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: MessagesToggleDialogPin): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xa731e257))
    if self.pinned:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
method TLDecode*(self: MessagesToggleDialogPin, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.pinned = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputDialogPeerI](tempObj)
method TLEncode*(self: MessagesReorderPinnedDialogs): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x3b1adf37))
    if self.force:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.folder_id)
    result = result & TLEncode(cast[seq[TL]](self.order))
method TLDecode*(self: MessagesReorderPinnedDialogs, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.force = true
    bytes.TLDecode(addr self.folder_id)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.order = cast[seq[InputDialogPeerI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesGetPinnedDialogs): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xd6b94df2))
    result = result & TLEncode(self.folder_id)
method TLDecode*(self: MessagesGetPinnedDialogs, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.folder_id)
method TLEncode*(self: MessagesSetBotShippingResults): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xe5f672fa))
    if self.error.isSome():
        self.flags = self.flags or 1 shl 0
    if self.shipping_options.isSome():
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.query_id)
    if self.error.isSome():
        result = result & TLEncode(self.error.get())
    if self.shipping_options.isSome():
        result = result & TLEncode(cast[seq[TL]](self.shipping_options.get()))
method TLDecode*(self: MessagesSetBotShippingResults, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    bytes.TLDecode(addr self.query_id)
    if (self.flags and (1 shl 0)) != 0:
        self.error = some(cast[string](bytes.TLDecode()))
    if (self.flags and (1 shl 1)) != 0:
        var tempVal = newSeq[TL]()
        tempVal.TLDecode(bytes)
        self.shipping_options = some(cast[seq[ShippingOptionI]](tempVal))
method TLEncode*(self: MessagesSetBotPrecheckoutResults): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x9c2dd95))
    if self.success:
        self.flags = self.flags or 1 shl 1
    if self.error.isSome():
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.query_id)
    if self.error.isSome():
        result = result & TLEncode(self.error.get())
method TLDecode*(self: MessagesSetBotPrecheckoutResults, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 1)) != 0:
        self.success = true
    bytes.TLDecode(addr self.query_id)
    if (self.flags and (1 shl 0)) != 0:
        self.error = some(cast[string](bytes.TLDecode()))
method TLEncode*(self: MessagesUploadMedia): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x519bc2b1))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.media)
method TLDecode*(self: MessagesUploadMedia, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    tempObj.TLDecode(bytes)
    self.media = cast[InputMediaI](tempObj)
method TLEncode*(self: MessagesSendScreenshotNotification): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc97df020))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.reply_to_msg_id)
    result = result & TLEncode(self.random_id)
method TLDecode*(self: MessagesSendScreenshotNotification, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.reply_to_msg_id)
    bytes.TLDecode(addr self.random_id)
method TLEncode*(self: MessagesGetFavedStickers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x21ce0b0e))
    result = result & TLEncode(self.hash)
method TLDecode*(self: MessagesGetFavedStickers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: MessagesFaveSticker): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb9ffc55b))
    result = result & TLEncode(self.id)
    result = result & TLEncode(self.unfave)
method TLDecode*(self: MessagesFaveSticker, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.id = cast[InputDocumentI](tempObj)
    bytes.TLDecode(self.unfave)
method TLEncode*(self: MessagesGetUnreadMentions): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x46578472))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.offset_id)
    result = result & TLEncode(self.add_offset)
    result = result & TLEncode(self.limit)
    result = result & TLEncode(self.max_id)
    result = result & TLEncode(self.min_id)
method TLDecode*(self: MessagesGetUnreadMentions, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.offset_id)
    bytes.TLDecode(addr self.add_offset)
    bytes.TLDecode(addr self.limit)
    bytes.TLDecode(addr self.max_id)
    bytes.TLDecode(addr self.min_id)
method TLEncode*(self: MessagesReadMentions): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf0189d3))
    result = result & TLEncode(self.peer)
method TLDecode*(self: MessagesReadMentions, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
method TLEncode*(self: MessagesGetRecentLocations): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xbbc45b09))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.limit)
    result = result & TLEncode(self.hash)
method TLDecode*(self: MessagesGetRecentLocations, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.limit)
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: MessagesSendMultiMedia): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xcc0110cb))
    if self.silent:
        self.flags = self.flags or 1 shl 5
    if self.background:
        self.flags = self.flags or 1 shl 6
    if self.clear_draft:
        self.flags = self.flags or 1 shl 7
    if self.reply_to_msg_id.isSome():
        self.flags = self.flags or 1 shl 0
    if self.schedule_date.isSome():
        self.flags = self.flags or 1 shl 10
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
    if self.reply_to_msg_id.isSome():
        result = result & TLEncode(self.reply_to_msg_id.get())
    result = result & TLEncode(cast[seq[TL]](self.multi_media))
    if self.schedule_date.isSome():
        result = result & TLEncode(self.schedule_date.get())
method TLDecode*(self: MessagesSendMultiMedia, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 5)) != 0:
        self.silent = true
    if (self.flags and (1 shl 6)) != 0:
        self.background = true
    if (self.flags and (1 shl 7)) != 0:
        self.clear_draft = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    if (self.flags and (1 shl 0)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.reply_to_msg_id = some(tempVal)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.multi_media = cast[seq[InputSingleMediaI]](tempVector)
    tempVector.setLen(0)
    if (self.flags and (1 shl 10)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.schedule_date = some(tempVal)
method TLEncode*(self: MessagesUploadEncryptedFile): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x5057c497))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.file)
method TLDecode*(self: MessagesUploadEncryptedFile, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputEncryptedChatI](tempObj)
    tempObj.TLDecode(bytes)
    self.file = cast[InputEncryptedFileI](tempObj)
method TLEncode*(self: MessagesSearchStickerSets): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc2b7d08b))
    if self.exclude_featured:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.q)
    result = result & TLEncode(self.hash)
method TLDecode*(self: MessagesSearchStickerSets, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.exclude_featured = true
    self.q = cast[string](bytes.TLDecode())
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: MessagesGetSplitRanges): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x1cff7e08))
method TLDecode*(self: MessagesGetSplitRanges, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: MessagesMarkDialogUnread): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc286d98f))
    if self.unread:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
method TLDecode*(self: MessagesMarkDialogUnread, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.unread = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputDialogPeerI](tempObj)
method TLEncode*(self: MessagesGetDialogUnreadMarks): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x22e24e22))
method TLDecode*(self: MessagesGetDialogUnreadMarks, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: MessagesClearAllDrafts): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x7e58ee9c))
method TLDecode*(self: MessagesClearAllDrafts, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: MessagesUpdatePinnedMessage): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xd2aaf7ec))
    if self.silent:
        self.flags = self.flags or 1 shl 0
    if self.unpin:
        self.flags = self.flags or 1 shl 1
    if self.pm_oneside:
        self.flags = self.flags or 1 shl 2
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.id)
method TLDecode*(self: MessagesUpdatePinnedMessage, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.silent = true
    if (self.flags and (1 shl 1)) != 0:
        self.unpin = true
    if (self.flags and (1 shl 2)) != 0:
        self.pm_oneside = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.id)
method TLEncode*(self: MessagesSendVote): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x10ea6184))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.msg_id)
    result = result & TLEncode(cast[seq[TL]](self.options))
method TLDecode*(self: MessagesSendVote, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.msg_id)
    self.options = bytes.TLDecodeSeq()
method TLEncode*(self: MessagesGetPollResults): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x73bb643b))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.msg_id)
method TLDecode*(self: MessagesGetPollResults, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.msg_id)
method TLEncode*(self: MessagesGetOnlines): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x6e2be050))
    result = result & TLEncode(self.peer)
method TLDecode*(self: MessagesGetOnlines, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
method TLEncode*(self: MessagesGetStatsURL): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x812c2ae6))
    if self.dark:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.params)
method TLDecode*(self: MessagesGetStatsURL, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.dark = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    self.params = cast[string](bytes.TLDecode())
method TLEncode*(self: MessagesEditChatAbout): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xdef60797))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.about)
method TLDecode*(self: MessagesEditChatAbout, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    self.about = cast[string](bytes.TLDecode())
method TLEncode*(self: MessagesEditChatDefaultBannedRights): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xa5866b41))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.banned_rights)
method TLDecode*(self: MessagesEditChatDefaultBannedRights, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    tempObj.TLDecode(bytes)
    self.banned_rights = cast[ChatBannedRightsI](tempObj)
method TLEncode*(self: MessagesGetEmojiKeywords): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x35a0e062))
    result = result & TLEncode(self.lang_code)
method TLDecode*(self: MessagesGetEmojiKeywords, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.lang_code = cast[string](bytes.TLDecode())
method TLEncode*(self: MessagesGetEmojiKeywordsDifference): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x1508b6af))
    result = result & TLEncode(self.lang_code)
    result = result & TLEncode(self.from_version)
method TLDecode*(self: MessagesGetEmojiKeywordsDifference, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.lang_code = cast[string](bytes.TLDecode())
    bytes.TLDecode(addr self.from_version)
method TLEncode*(self: MessagesGetEmojiKeywordsLanguages): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x4e9963b2))
    result = result & TLEncode(cast[seq[TL]](self.lang_codes))
method TLDecode*(self: MessagesGetEmojiKeywordsLanguages, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.lang_codes = cast[seq[string]](bytes.TLDecodeSeq())
method TLEncode*(self: MessagesGetEmojiURL): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xd5b10c26))
    result = result & TLEncode(self.lang_code)
method TLDecode*(self: MessagesGetEmojiURL, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.lang_code = cast[string](bytes.TLDecode())
method TLEncode*(self: MessagesGetSearchCounters): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x732eef00))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(cast[seq[TL]](self.filters))
method TLDecode*(self: MessagesGetSearchCounters, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.filters = cast[seq[MessagesFilterI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesRequestUrlAuth): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xe33f5613))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.msg_id)
    result = result & TLEncode(self.button_id)
method TLDecode*(self: MessagesRequestUrlAuth, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.msg_id)
    bytes.TLDecode(addr self.button_id)
method TLEncode*(self: MessagesAcceptUrlAuth): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf729ea98))
    if self.write_allowed:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.msg_id)
    result = result & TLEncode(self.button_id)
method TLDecode*(self: MessagesAcceptUrlAuth, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.write_allowed = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.msg_id)
    bytes.TLDecode(addr self.button_id)
method TLEncode*(self: MessagesHidePeerSettingsBar): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x4facb138))
    result = result & TLEncode(self.peer)
method TLDecode*(self: MessagesHidePeerSettingsBar, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
method TLEncode*(self: MessagesGetScheduledHistory): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xe2c2685b))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.hash)
method TLDecode*(self: MessagesGetScheduledHistory, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: MessagesGetScheduledMessages): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xbdbb0464))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.id)
method TLDecode*(self: MessagesGetScheduledMessages, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(self.id)
method TLEncode*(self: MessagesSendScheduledMessages): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xbd38850a))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.id)
method TLDecode*(self: MessagesSendScheduledMessages, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(self.id)
method TLEncode*(self: MessagesDeleteScheduledMessages): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x59ae2b16))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.id)
method TLDecode*(self: MessagesDeleteScheduledMessages, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(self.id)
method TLEncode*(self: MessagesGetPollVotes): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb86e380e))
    if self.option.isSome():
        self.flags = self.flags or 1 shl 0
    if self.offset.isSome():
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.id)
    if self.option.isSome():
        result = result & TLEncode(self.option.get())
    if self.offset.isSome():
        result = result & TLEncode(self.offset.get())
    result = result & TLEncode(self.limit)
method TLDecode*(self: MessagesGetPollVotes, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.id)
    if (self.flags and (1 shl 0)) != 0:
        self.option = some(bytes.TLDecode())
    if (self.flags and (1 shl 1)) != 0:
        self.offset = some(cast[string](bytes.TLDecode()))
    bytes.TLDecode(addr self.limit)
method TLEncode*(self: MessagesToggleStickerSets): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb5052fea))
    if self.uninstall:
        self.flags = self.flags or 1 shl 0
    if self.archive:
        self.flags = self.flags or 1 shl 1
    if self.unarchive:
        self.flags = self.flags or 1 shl 2
    result = result & TLEncode(self.flags)
    result = result & TLEncode(cast[seq[TL]](self.stickersets))
method TLDecode*(self: MessagesToggleStickerSets, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.uninstall = true
    if (self.flags and (1 shl 1)) != 0:
        self.archive = true
    if (self.flags and (1 shl 2)) != 0:
        self.unarchive = true
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.stickersets = cast[seq[InputStickerSetI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: MessagesGetDialogFilters): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf19ed96d))
method TLDecode*(self: MessagesGetDialogFilters, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: MessagesGetSuggestedDialogFilters): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xa29cd42c))
method TLDecode*(self: MessagesGetSuggestedDialogFilters, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: MessagesUpdateDialogFilter): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x1ad4a04a))
    if self.filter.isSome():
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.id)
    if self.filter.isSome():
        result = result & TLEncode(self.filter.get())
method TLDecode*(self: MessagesUpdateDialogFilter, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    bytes.TLDecode(addr self.id)
    if (self.flags and (1 shl 0)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.filter = some(tempVal.DialogFilterI)
method TLEncode*(self: MessagesUpdateDialogFiltersOrder): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc563c1e4))
    result = result & TLEncode(self.order)
method TLDecode*(self: MessagesUpdateDialogFiltersOrder, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(self.order)
method TLEncode*(self: MessagesGetOldFeaturedStickers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x5fe7025b))
    result = result & TLEncode(self.offset)
    result = result & TLEncode(self.limit)
    result = result & TLEncode(self.hash)
method TLDecode*(self: MessagesGetOldFeaturedStickers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.offset)
    bytes.TLDecode(addr self.limit)
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: MessagesGetReplies): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x24b581ba))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.msg_id)
    result = result & TLEncode(self.offset_id)
    result = result & TLEncode(self.offset_date)
    result = result & TLEncode(self.add_offset)
    result = result & TLEncode(self.limit)
    result = result & TLEncode(self.max_id)
    result = result & TLEncode(self.min_id)
    result = result & TLEncode(self.hash)
method TLDecode*(self: MessagesGetReplies, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.msg_id)
    bytes.TLDecode(addr self.offset_id)
    bytes.TLDecode(addr self.offset_date)
    bytes.TLDecode(addr self.add_offset)
    bytes.TLDecode(addr self.limit)
    bytes.TLDecode(addr self.max_id)
    bytes.TLDecode(addr self.min_id)
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: MessagesGetDiscussionMessage): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x446972fd))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.msg_id)
method TLDecode*(self: MessagesGetDiscussionMessage, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.msg_id)
method TLEncode*(self: MessagesReadDiscussion): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf731a9f4))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.msg_id)
    result = result & TLEncode(self.read_max_id)
method TLDecode*(self: MessagesReadDiscussion, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.msg_id)
    bytes.TLDecode(addr self.read_max_id)
method TLEncode*(self: MessagesUnpinAllMessages): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf025bc8b))
    result = result & TLEncode(self.peer)
method TLDecode*(self: MessagesUnpinAllMessages, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
method TLEncode*(self: MessagesDeleteChat): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x83247d11))
    result = result & TLEncode(self.chat_id)
method TLDecode*(self: MessagesDeleteChat, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.chat_id)
method TLEncode*(self: MessagesDeletePhoneCallHistory): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf9cbe409))
    if self.revoke:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
method TLDecode*(self: MessagesDeletePhoneCallHistory, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.revoke = true
method TLEncode*(self: MessagesCheckHistoryImport): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x43fe19f3))
    result = result & TLEncode(self.import_head)
method TLDecode*(self: MessagesCheckHistoryImport, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.import_head = cast[string](bytes.TLDecode())
method TLEncode*(self: MessagesInitHistoryImport): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x34090c3b))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.file)
    result = result & TLEncode(self.media_count)
method TLDecode*(self: MessagesInitHistoryImport, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    tempObj.TLDecode(bytes)
    self.file = cast[InputFileI](tempObj)
    bytes.TLDecode(addr self.media_count)
method TLEncode*(self: MessagesUploadImportedMedia): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x2a862092))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.import_id)
    result = result & TLEncode(self.file_name)
    result = result & TLEncode(self.media)
method TLDecode*(self: MessagesUploadImportedMedia, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.import_id)
    self.file_name = cast[string](bytes.TLDecode())
    tempObj.TLDecode(bytes)
    self.media = cast[InputMediaI](tempObj)
method TLEncode*(self: MessagesStartHistoryImport): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb43df344))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.import_id)
method TLDecode*(self: MessagesStartHistoryImport, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.import_id)
method TLEncode*(self: MessagesGetExportedChatInvites): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xa2b5a3f6))
    if self.revoked:
        self.flags = self.flags or 1 shl 3
    if self.offset_date.isSome():
        self.flags = self.flags or 1 shl 2
    if self.offset_link.isSome():
        self.flags = self.flags or 1 shl 2
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.admin_id)
    if self.offset_date.isSome():
        result = result & TLEncode(self.offset_date.get())
    if self.offset_link.isSome():
        result = result & TLEncode(self.offset_link.get())
    result = result & TLEncode(self.limit)
method TLDecode*(self: MessagesGetExportedChatInvites, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 3)) != 0:
        self.revoked = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    tempObj.TLDecode(bytes)
    self.admin_id = cast[InputUserI](tempObj)
    if (self.flags and (1 shl 2)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.offset_date = some(tempVal)
    if (self.flags and (1 shl 2)) != 0:
        self.offset_link = some(cast[string](bytes.TLDecode()))
    bytes.TLDecode(addr self.limit)
method TLEncode*(self: MessagesEditExportedChatInvite): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x2e4ffbe))
    if self.revoked:
        self.flags = self.flags or 1 shl 2
    if self.expire_date.isSome():
        self.flags = self.flags or 1 shl 0
    if self.usage_limit.isSome():
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.link)
    if self.expire_date.isSome():
        result = result & TLEncode(self.expire_date.get())
    if self.usage_limit.isSome():
        result = result & TLEncode(self.usage_limit.get())
method TLDecode*(self: MessagesEditExportedChatInvite, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 2)) != 0:
        self.revoked = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    self.link = cast[string](bytes.TLDecode())
    if (self.flags and (1 shl 0)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.expire_date = some(tempVal)
    if (self.flags and (1 shl 1)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.usage_limit = some(tempVal)
method TLEncode*(self: MessagesDeleteRevokedExportedChatInvites): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x56987bd5))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.admin_id)
method TLDecode*(self: MessagesDeleteRevokedExportedChatInvites, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    tempObj.TLDecode(bytes)
    self.admin_id = cast[InputUserI](tempObj)
method TLEncode*(self: MessagesDeleteExportedChatInvite): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xd464a42b))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.link)
method TLDecode*(self: MessagesDeleteExportedChatInvite, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    self.link = cast[string](bytes.TLDecode())
method TLEncode*(self: MessagesGetAdminsWithInvites): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x3920e6ef))
    result = result & TLEncode(self.peer)
method TLDecode*(self: MessagesGetAdminsWithInvites, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
method TLEncode*(self: MessagesGetChatInviteImporters): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x26fb7289))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.link)
    result = result & TLEncode(self.offset_date)
    result = result & TLEncode(self.offset_user)
    result = result & TLEncode(self.limit)
method TLDecode*(self: MessagesGetChatInviteImporters, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    self.link = cast[string](bytes.TLDecode())
    bytes.TLDecode(addr self.offset_date)
    tempObj.TLDecode(bytes)
    self.offset_user = cast[InputUserI](tempObj)
    bytes.TLDecode(addr self.limit)
method TLEncode*(self: MessagesSetHistoryTTL): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb80e5fe4))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.period)
method TLDecode*(self: MessagesSetHistoryTTL, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.period)
