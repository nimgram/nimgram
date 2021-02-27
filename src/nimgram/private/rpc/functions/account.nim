type
    AccountRegisterDevice* = ref object of TLFunction
        flags: int32
        no_muted*: bool
        token_type*: int32
        token*: string
        app_sandbox*: bool
        secret*: seq[uint8]
        other_uids*: seq[int32]
    AccountUnregisterDevice* = ref object of TLFunction
        token_type*: int32
        token*: string
        other_uids*: seq[int32]
    AccountUpdateNotifySettings* = ref object of TLFunction
        peer*: InputNotifyPeerI
        settings*: InputPeerNotifySettingsI
    AccountGetNotifySettings* = ref object of TLFunction
        peer*: InputNotifyPeerI
    AccountResetNotifySettings* = ref object of TLFunction
    AccountUpdateProfile* = ref object of TLFunction
        flags: int32
        first_name*: Option[string]
        last_name*: Option[string]
        about*: Option[string]
    AccountUpdateStatus* = ref object of TLFunction
        offline*: bool
    AccountGetWallPapers* = ref object of TLFunction
        hash*: int32
    AccountReportPeer* = ref object of TLFunction
        peer*: InputPeerI
        reason*: ReportReasonI
        message*: string
    AccountCheckUsername* = ref object of TLFunction
        username*: string
    AccountUpdateUsername* = ref object of TLFunction
        username*: string
    AccountGetPrivacy* = ref object of TLFunction
        key*: InputPrivacyKeyI
    AccountSetPrivacy* = ref object of TLFunction
        key*: InputPrivacyKeyI
        rules*: seq[InputPrivacyRuleI]
    AccountDeleteAccount* = ref object of TLFunction
        reason*: string
    AccountGetAccountTTL* = ref object of TLFunction
    AccountSetAccountTTL* = ref object of TLFunction
        ttl*: AccountDaysTTLI
    AccountSendChangePhoneCode* = ref object of TLFunction
        phone_number*: string
        settings*: CodeSettingsI
    AccountChangePhone* = ref object of TLFunction
        phone_number*: string
        phone_code_hash*: string
        phone_code*: string
    AccountUpdateDeviceLocked* = ref object of TLFunction
        period*: int32
    AccountGetAuthorizations* = ref object of TLFunction
    AccountResetAuthorization* = ref object of TLFunction
        hash*: int64
    AccountGetPassword* = ref object of TLFunction
    AccountGetPasswordSettings* = ref object of TLFunction
        password*: InputCheckPasswordSRPI
    AccountUpdatePasswordSettings* = ref object of TLFunction
        password*: InputCheckPasswordSRPI
        new_settings*: AccountPasswordInputSettingsI
    AccountSendConfirmPhoneCode* = ref object of TLFunction
        hash*: string
        settings*: CodeSettingsI
    AccountConfirmPhone* = ref object of TLFunction
        phone_code_hash*: string
        phone_code*: string
    AccountGetTmpPassword* = ref object of TLFunction
        password*: InputCheckPasswordSRPI
        period*: int32
    AccountGetWebAuthorizations* = ref object of TLFunction
    AccountResetWebAuthorization* = ref object of TLFunction
        hash*: int64
    AccountResetWebAuthorizations* = ref object of TLFunction
    AccountGetAllSecureValues* = ref object of TLFunction
    AccountGetSecureValue* = ref object of TLFunction
        types*: seq[SecureValueTypeI]
    AccountSaveSecureValue* = ref object of TLFunction
        value*: InputSecureValueI
        secure_secret_id*: int64
    AccountDeleteSecureValue* = ref object of TLFunction
        types*: seq[SecureValueTypeI]
    AccountGetAuthorizationForm* = ref object of TLFunction
        bot_id*: int32
        scope*: string
        public_key*: string
    AccountAcceptAuthorization* = ref object of TLFunction
        bot_id*: int32
        scope*: string
        public_key*: string
        value_hashes*: seq[SecureValueHashI]
        credentials*: SecureCredentialsEncryptedI
    AccountSendVerifyPhoneCode* = ref object of TLFunction
        phone_number*: string
        settings*: CodeSettingsI
    AccountVerifyPhone* = ref object of TLFunction
        phone_number*: string
        phone_code_hash*: string
        phone_code*: string
    AccountSendVerifyEmailCode* = ref object of TLFunction
        email*: string
    AccountVerifyEmail* = ref object of TLFunction
        email*: string
        code*: string
    AccountInitTakeoutSession* = ref object of TLFunction
        flags: int32
        contacts*: bool
        message_users*: bool
        message_chats*: bool
        message_megagroups*: bool
        message_channels*: bool
        files*: bool
        file_max_size*: Option[int32]
    AccountFinishTakeoutSession* = ref object of TLFunction
        flags: int32
        success*: bool
    AccountConfirmPasswordEmail* = ref object of TLFunction
        code*: string
    AccountResendPasswordEmail* = ref object of TLFunction
    AccountCancelPasswordEmail* = ref object of TLFunction
    AccountGetContactSignUpNotification* = ref object of TLFunction
    AccountSetContactSignUpNotification* = ref object of TLFunction
        silent*: bool
    AccountGetNotifyExceptions* = ref object of TLFunction
        flags: int32
        compare_sound*: bool
        peer*: Option[InputNotifyPeerI]
    AccountGetWallPaper* = ref object of TLFunction
        wallpaper*: InputWallPaperI
    AccountUploadWallPaper* = ref object of TLFunction
        file*: InputFileI
        mime_type*: string
        settings*: WallPaperSettingsI
    AccountSaveWallPaper* = ref object of TLFunction
        wallpaper*: InputWallPaperI
        unsave*: bool
        settings*: WallPaperSettingsI
    AccountInstallWallPaper* = ref object of TLFunction
        wallpaper*: InputWallPaperI
        settings*: WallPaperSettingsI
    AccountResetWallPapers* = ref object of TLFunction
    AccountGetAutoDownloadSettings* = ref object of TLFunction
    AccountSaveAutoDownloadSettings* = ref object of TLFunction
        flags: int32
        low*: bool
        high*: bool
        settings*: AutoDownloadSettingsI
    AccountUploadTheme* = ref object of TLFunction
        flags: int32
        file*: InputFileI
        thumb*: Option[InputFileI]
        file_name*: string
        mime_type*: string
    AccountCreateTheme* = ref object of TLFunction
        flags: int32
        slug*: string
        title*: string
        document*: Option[InputDocumentI]
        settings*: Option[InputThemeSettingsI]
    AccountUpdateTheme* = ref object of TLFunction
        flags: int32
        format*: string
        theme*: InputThemeI
        slug*: Option[string]
        title*: Option[string]
        document*: Option[InputDocumentI]
        settings*: Option[InputThemeSettingsI]
    AccountSaveTheme* = ref object of TLFunction
        theme*: InputThemeI
        unsave*: bool
    AccountInstallTheme* = ref object of TLFunction
        flags: int32
        dark*: bool
        format*: Option[string]
        theme*: Option[InputThemeI]
    AccountGetTheme* = ref object of TLFunction
        format*: string
        theme*: InputThemeI
        document_id*: int64
    AccountGetThemes* = ref object of TLFunction
        format*: string
        hash*: int32
    AccountSetContentSettings* = ref object of TLFunction
        flags: int32
        sensitive_enabled*: bool
    AccountGetContentSettings* = ref object of TLFunction
    AccountGetMultiWallPapers* = ref object of TLFunction
        wallpapers*: seq[InputWallPaperI]
    AccountGetGlobalPrivacySettings* = ref object of TLFunction
    AccountSetGlobalPrivacySettings* = ref object of TLFunction
        settings*: GlobalPrivacySettingsI
    AccountReportProfilePhoto* = ref object of TLFunction
        peer*: InputPeerI
        photo_id*: InputPhotoI
        reason*: ReportReasonI
        message*: string
method getTypeName*(self: AccountRegisterDevice): string = "AccountRegisterDevice"
method getTypeName*(self: AccountUnregisterDevice): string = "AccountUnregisterDevice"
method getTypeName*(self: AccountUpdateNotifySettings): string = "AccountUpdateNotifySettings"
method getTypeName*(self: AccountGetNotifySettings): string = "AccountGetNotifySettings"
method getTypeName*(self: AccountResetNotifySettings): string = "AccountResetNotifySettings"
method getTypeName*(self: AccountUpdateProfile): string = "AccountUpdateProfile"
method getTypeName*(self: AccountUpdateStatus): string = "AccountUpdateStatus"
method getTypeName*(self: AccountGetWallPapers): string = "AccountGetWallPapers"
method getTypeName*(self: AccountReportPeer): string = "AccountReportPeer"
method getTypeName*(self: AccountCheckUsername): string = "AccountCheckUsername"
method getTypeName*(self: AccountUpdateUsername): string = "AccountUpdateUsername"
method getTypeName*(self: AccountGetPrivacy): string = "AccountGetPrivacy"
method getTypeName*(self: AccountSetPrivacy): string = "AccountSetPrivacy"
method getTypeName*(self: AccountDeleteAccount): string = "AccountDeleteAccount"
method getTypeName*(self: AccountGetAccountTTL): string = "AccountGetAccountTTL"
method getTypeName*(self: AccountSetAccountTTL): string = "AccountSetAccountTTL"
method getTypeName*(self: AccountSendChangePhoneCode): string = "AccountSendChangePhoneCode"
method getTypeName*(self: AccountChangePhone): string = "AccountChangePhone"
method getTypeName*(self: AccountUpdateDeviceLocked): string = "AccountUpdateDeviceLocked"
method getTypeName*(self: AccountGetAuthorizations): string = "AccountGetAuthorizations"
method getTypeName*(self: AccountResetAuthorization): string = "AccountResetAuthorization"
method getTypeName*(self: AccountGetPassword): string = "AccountGetPassword"
method getTypeName*(self: AccountGetPasswordSettings): string = "AccountGetPasswordSettings"
method getTypeName*(self: AccountUpdatePasswordSettings): string = "AccountUpdatePasswordSettings"
method getTypeName*(self: AccountSendConfirmPhoneCode): string = "AccountSendConfirmPhoneCode"
method getTypeName*(self: AccountConfirmPhone): string = "AccountConfirmPhone"
method getTypeName*(self: AccountGetTmpPassword): string = "AccountGetTmpPassword"
method getTypeName*(self: AccountGetWebAuthorizations): string = "AccountGetWebAuthorizations"
method getTypeName*(self: AccountResetWebAuthorization): string = "AccountResetWebAuthorization"
method getTypeName*(self: AccountResetWebAuthorizations): string = "AccountResetWebAuthorizations"
method getTypeName*(self: AccountGetAllSecureValues): string = "AccountGetAllSecureValues"
method getTypeName*(self: AccountGetSecureValue): string = "AccountGetSecureValue"
method getTypeName*(self: AccountSaveSecureValue): string = "AccountSaveSecureValue"
method getTypeName*(self: AccountDeleteSecureValue): string = "AccountDeleteSecureValue"
method getTypeName*(self: AccountGetAuthorizationForm): string = "AccountGetAuthorizationForm"
method getTypeName*(self: AccountAcceptAuthorization): string = "AccountAcceptAuthorization"
method getTypeName*(self: AccountSendVerifyPhoneCode): string = "AccountSendVerifyPhoneCode"
method getTypeName*(self: AccountVerifyPhone): string = "AccountVerifyPhone"
method getTypeName*(self: AccountSendVerifyEmailCode): string = "AccountSendVerifyEmailCode"
method getTypeName*(self: AccountVerifyEmail): string = "AccountVerifyEmail"
method getTypeName*(self: AccountInitTakeoutSession): string = "AccountInitTakeoutSession"
method getTypeName*(self: AccountFinishTakeoutSession): string = "AccountFinishTakeoutSession"
method getTypeName*(self: AccountConfirmPasswordEmail): string = "AccountConfirmPasswordEmail"
method getTypeName*(self: AccountResendPasswordEmail): string = "AccountResendPasswordEmail"
method getTypeName*(self: AccountCancelPasswordEmail): string = "AccountCancelPasswordEmail"
method getTypeName*(self: AccountGetContactSignUpNotification): string = "AccountGetContactSignUpNotification"
method getTypeName*(self: AccountSetContactSignUpNotification): string = "AccountSetContactSignUpNotification"
method getTypeName*(self: AccountGetNotifyExceptions): string = "AccountGetNotifyExceptions"
method getTypeName*(self: AccountGetWallPaper): string = "AccountGetWallPaper"
method getTypeName*(self: AccountUploadWallPaper): string = "AccountUploadWallPaper"
method getTypeName*(self: AccountSaveWallPaper): string = "AccountSaveWallPaper"
method getTypeName*(self: AccountInstallWallPaper): string = "AccountInstallWallPaper"
method getTypeName*(self: AccountResetWallPapers): string = "AccountResetWallPapers"
method getTypeName*(self: AccountGetAutoDownloadSettings): string = "AccountGetAutoDownloadSettings"
method getTypeName*(self: AccountSaveAutoDownloadSettings): string = "AccountSaveAutoDownloadSettings"
method getTypeName*(self: AccountUploadTheme): string = "AccountUploadTheme"
method getTypeName*(self: AccountCreateTheme): string = "AccountCreateTheme"
method getTypeName*(self: AccountUpdateTheme): string = "AccountUpdateTheme"
method getTypeName*(self: AccountSaveTheme): string = "AccountSaveTheme"
method getTypeName*(self: AccountInstallTheme): string = "AccountInstallTheme"
method getTypeName*(self: AccountGetTheme): string = "AccountGetTheme"
method getTypeName*(self: AccountGetThemes): string = "AccountGetThemes"
method getTypeName*(self: AccountSetContentSettings): string = "AccountSetContentSettings"
method getTypeName*(self: AccountGetContentSettings): string = "AccountGetContentSettings"
method getTypeName*(self: AccountGetMultiWallPapers): string = "AccountGetMultiWallPapers"
method getTypeName*(self: AccountGetGlobalPrivacySettings): string = "AccountGetGlobalPrivacySettings"
method getTypeName*(self: AccountSetGlobalPrivacySettings): string = "AccountSetGlobalPrivacySettings"
method getTypeName*(self: AccountReportProfilePhoto): string = "AccountReportProfilePhoto"

method TLEncode*(self: AccountRegisterDevice): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x68976c6f))
    if self.no_muted:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.token_type)
    result = result & TLEncode(self.token)
    result = result & TLEncode(self.app_sandbox)
    result = result & TLEncode(self.secret)
    result = result & TLEncode(self.other_uids)
method TLDecode*(self: AccountRegisterDevice, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.no_muted = true
    bytes.TLDecode(addr self.token_type)
    self.token = cast[string](bytes.TLDecode())
    bytes.TLDecode(self.app_sandbox)
    self.secret = bytes.TLDecode()
    bytes.TLDecode(self.other_uids)
method TLEncode*(self: AccountUnregisterDevice): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x3076c4bf))
    result = result & TLEncode(self.token_type)
    result = result & TLEncode(self.token)
    result = result & TLEncode(self.other_uids)
method TLDecode*(self: AccountUnregisterDevice, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.token_type)
    self.token = cast[string](bytes.TLDecode())
    bytes.TLDecode(self.other_uids)
method TLEncode*(self: AccountUpdateNotifySettings): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x84be5b93))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.settings)
method TLDecode*(self: AccountUpdateNotifySettings, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputNotifyPeerI](tempObj)
    tempObj.TLDecode(bytes)
    self.settings = cast[InputPeerNotifySettingsI](tempObj)
method TLEncode*(self: AccountGetNotifySettings): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x12b3ad31))
    result = result & TLEncode(self.peer)
method TLDecode*(self: AccountGetNotifySettings, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputNotifyPeerI](tempObj)
method TLEncode*(self: AccountResetNotifySettings): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xdb7e1747))
method TLDecode*(self: AccountResetNotifySettings, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: AccountUpdateProfile): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x78515775))
    if self.first_name.isSome():
        self.flags = self.flags or 1 shl 0
    if self.last_name.isSome():
        self.flags = self.flags or 1 shl 1
    if self.about.isSome():
        self.flags = self.flags or 1 shl 2
    result = result & TLEncode(self.flags)
    if self.first_name.isSome():
        result = result & TLEncode(self.first_name.get())
    if self.last_name.isSome():
        result = result & TLEncode(self.last_name.get())
    if self.about.isSome():
        result = result & TLEncode(self.about.get())
method TLDecode*(self: AccountUpdateProfile, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.first_name = some(cast[string](bytes.TLDecode()))
    if (self.flags and (1 shl 1)) != 0:
        self.last_name = some(cast[string](bytes.TLDecode()))
    if (self.flags and (1 shl 2)) != 0:
        self.about = some(cast[string](bytes.TLDecode()))
method TLEncode*(self: AccountUpdateStatus): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x6628562c))
    result = result & TLEncode(self.offline)
method TLDecode*(self: AccountUpdateStatus, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(self.offline)
method TLEncode*(self: AccountGetWallPapers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xaabb1763))
    result = result & TLEncode(self.hash)
method TLDecode*(self: AccountGetWallPapers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: AccountReportPeer): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc5ba3d86))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.reason)
    result = result & TLEncode(self.message)
method TLDecode*(self: AccountReportPeer, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    tempObj.TLDecode(bytes)
    self.reason = cast[ReportReasonI](tempObj)
    self.message = cast[string](bytes.TLDecode())
method TLEncode*(self: AccountCheckUsername): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x2714d86c))
    result = result & TLEncode(self.username)
method TLDecode*(self: AccountCheckUsername, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.username = cast[string](bytes.TLDecode())
method TLEncode*(self: AccountUpdateUsername): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x3e0bdd7c))
    result = result & TLEncode(self.username)
method TLDecode*(self: AccountUpdateUsername, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.username = cast[string](bytes.TLDecode())
method TLEncode*(self: AccountGetPrivacy): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xdadbc950))
    result = result & TLEncode(self.key)
method TLDecode*(self: AccountGetPrivacy, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.key = cast[InputPrivacyKeyI](tempObj)
method TLEncode*(self: AccountSetPrivacy): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc9f81ce8))
    result = result & TLEncode(self.key)
    result = result & TLEncode(cast[seq[TL]](self.rules))
method TLDecode*(self: AccountSetPrivacy, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.key = cast[InputPrivacyKeyI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.rules = cast[seq[InputPrivacyRuleI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: AccountDeleteAccount): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x418d4e0b))
    result = result & TLEncode(self.reason)
method TLDecode*(self: AccountDeleteAccount, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.reason = cast[string](bytes.TLDecode())
method TLEncode*(self: AccountGetAccountTTL): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x8fc711d))
method TLDecode*(self: AccountGetAccountTTL, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: AccountSetAccountTTL): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x2442485e))
    result = result & TLEncode(self.ttl)
method TLDecode*(self: AccountSetAccountTTL, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.ttl = cast[AccountDaysTTLI](tempObj)
method TLEncode*(self: AccountSendChangePhoneCode): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x82574ae5))
    result = result & TLEncode(self.phone_number)
    result = result & TLEncode(self.settings)
method TLDecode*(self: AccountSendChangePhoneCode, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.phone_number = cast[string](bytes.TLDecode())
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.settings = cast[CodeSettingsI](tempObj)
method TLEncode*(self: AccountChangePhone): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x70c32edb))
    result = result & TLEncode(self.phone_number)
    result = result & TLEncode(self.phone_code_hash)
    result = result & TLEncode(self.phone_code)
method TLDecode*(self: AccountChangePhone, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.phone_number = cast[string](bytes.TLDecode())
    self.phone_code_hash = cast[string](bytes.TLDecode())
    self.phone_code = cast[string](bytes.TLDecode())
method TLEncode*(self: AccountUpdateDeviceLocked): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x38df3532))
    result = result & TLEncode(self.period)
method TLDecode*(self: AccountUpdateDeviceLocked, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.period)
method TLEncode*(self: AccountGetAuthorizations): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xe320c158))
method TLDecode*(self: AccountGetAuthorizations, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: AccountResetAuthorization): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xdf77f3bc))
    result = result & TLEncode(self.hash)
method TLDecode*(self: AccountResetAuthorization, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: AccountGetPassword): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x548a30f5))
method TLDecode*(self: AccountGetPassword, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: AccountGetPasswordSettings): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x9cd4eaf9))
    result = result & TLEncode(self.password)
method TLDecode*(self: AccountGetPasswordSettings, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.password = cast[InputCheckPasswordSRPI](tempObj)
method TLEncode*(self: AccountUpdatePasswordSettings): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xa59b102f))
    result = result & TLEncode(self.password)
    result = result & TLEncode(self.new_settings)
method TLDecode*(self: AccountUpdatePasswordSettings, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.password = cast[InputCheckPasswordSRPI](tempObj)
    tempObj.TLDecode(bytes)
    self.new_settings = cast[AccountPasswordInputSettingsI](tempObj)
method TLEncode*(self: AccountSendConfirmPhoneCode): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x1b3faa88))
    result = result & TLEncode(self.hash)
    result = result & TLEncode(self.settings)
method TLDecode*(self: AccountSendConfirmPhoneCode, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.hash = cast[string](bytes.TLDecode())
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.settings = cast[CodeSettingsI](tempObj)
method TLEncode*(self: AccountConfirmPhone): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x5f2178c3))
    result = result & TLEncode(self.phone_code_hash)
    result = result & TLEncode(self.phone_code)
method TLDecode*(self: AccountConfirmPhone, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.phone_code_hash = cast[string](bytes.TLDecode())
    self.phone_code = cast[string](bytes.TLDecode())
method TLEncode*(self: AccountGetTmpPassword): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x449e0b51))
    result = result & TLEncode(self.password)
    result = result & TLEncode(self.period)
method TLDecode*(self: AccountGetTmpPassword, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.password = cast[InputCheckPasswordSRPI](tempObj)
    bytes.TLDecode(addr self.period)
method TLEncode*(self: AccountGetWebAuthorizations): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x182e6d6f))
method TLDecode*(self: AccountGetWebAuthorizations, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: AccountResetWebAuthorization): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x2d01b9ef))
    result = result & TLEncode(self.hash)
method TLDecode*(self: AccountResetWebAuthorization, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: AccountResetWebAuthorizations): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x682d2594))
method TLDecode*(self: AccountResetWebAuthorizations, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: AccountGetAllSecureValues): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb288bc7d))
method TLDecode*(self: AccountGetAllSecureValues, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: AccountGetSecureValue): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x73665bc2))
    result = result & TLEncode(cast[seq[TL]](self.types))
method TLDecode*(self: AccountGetSecureValue, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.types = cast[seq[SecureValueTypeI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: AccountSaveSecureValue): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x899fe31d))
    result = result & TLEncode(self.value)
    result = result & TLEncode(self.secure_secret_id)
method TLDecode*(self: AccountSaveSecureValue, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.value = cast[InputSecureValueI](tempObj)
    bytes.TLDecode(addr self.secure_secret_id)
method TLEncode*(self: AccountDeleteSecureValue): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb880bc4b))
    result = result & TLEncode(cast[seq[TL]](self.types))
method TLDecode*(self: AccountDeleteSecureValue, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.types = cast[seq[SecureValueTypeI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: AccountGetAuthorizationForm): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb86ba8e1))
    result = result & TLEncode(self.bot_id)
    result = result & TLEncode(self.scope)
    result = result & TLEncode(self.public_key)
method TLDecode*(self: AccountGetAuthorizationForm, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.bot_id)
    self.scope = cast[string](bytes.TLDecode())
    self.public_key = cast[string](bytes.TLDecode())
method TLEncode*(self: AccountAcceptAuthorization): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xe7027c94))
    result = result & TLEncode(self.bot_id)
    result = result & TLEncode(self.scope)
    result = result & TLEncode(self.public_key)
    result = result & TLEncode(cast[seq[TL]](self.value_hashes))
    result = result & TLEncode(self.credentials)
method TLDecode*(self: AccountAcceptAuthorization, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.bot_id)
    self.scope = cast[string](bytes.TLDecode())
    self.public_key = cast[string](bytes.TLDecode())
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.value_hashes = cast[seq[SecureValueHashI]](tempVector)
    tempVector.setLen(0)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.credentials = cast[SecureCredentialsEncryptedI](tempObj)
method TLEncode*(self: AccountSendVerifyPhoneCode): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xa5a356f9))
    result = result & TLEncode(self.phone_number)
    result = result & TLEncode(self.settings)
method TLDecode*(self: AccountSendVerifyPhoneCode, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.phone_number = cast[string](bytes.TLDecode())
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.settings = cast[CodeSettingsI](tempObj)
method TLEncode*(self: AccountVerifyPhone): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x4dd3a7f6))
    result = result & TLEncode(self.phone_number)
    result = result & TLEncode(self.phone_code_hash)
    result = result & TLEncode(self.phone_code)
method TLDecode*(self: AccountVerifyPhone, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.phone_number = cast[string](bytes.TLDecode())
    self.phone_code_hash = cast[string](bytes.TLDecode())
    self.phone_code = cast[string](bytes.TLDecode())
method TLEncode*(self: AccountSendVerifyEmailCode): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x7011509f))
    result = result & TLEncode(self.email)
method TLDecode*(self: AccountSendVerifyEmailCode, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.email = cast[string](bytes.TLDecode())
method TLEncode*(self: AccountVerifyEmail): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xecba39db))
    result = result & TLEncode(self.email)
    result = result & TLEncode(self.code)
method TLDecode*(self: AccountVerifyEmail, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.email = cast[string](bytes.TLDecode())
    self.code = cast[string](bytes.TLDecode())
method TLEncode*(self: AccountInitTakeoutSession): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf05b4804))
    if self.contacts:
        self.flags = self.flags or 1 shl 0
    if self.message_users:
        self.flags = self.flags or 1 shl 1
    if self.message_chats:
        self.flags = self.flags or 1 shl 2
    if self.message_megagroups:
        self.flags = self.flags or 1 shl 3
    if self.message_channels:
        self.flags = self.flags or 1 shl 4
    if self.files:
        self.flags = self.flags or 1 shl 5
    if self.file_max_size.isSome():
        self.flags = self.flags or 1 shl 5
    result = result & TLEncode(self.flags)
    if self.file_max_size.isSome():
        result = result & TLEncode(self.file_max_size.get())
method TLDecode*(self: AccountInitTakeoutSession, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.contacts = true
    if (self.flags and (1 shl 1)) != 0:
        self.message_users = true
    if (self.flags and (1 shl 2)) != 0:
        self.message_chats = true
    if (self.flags and (1 shl 3)) != 0:
        self.message_megagroups = true
    if (self.flags and (1 shl 4)) != 0:
        self.message_channels = true
    if (self.flags and (1 shl 5)) != 0:
        self.files = true
    if (self.flags and (1 shl 5)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.file_max_size = some(tempVal)
method TLEncode*(self: AccountFinishTakeoutSession): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x1d2652ee))
    if self.success:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
method TLDecode*(self: AccountFinishTakeoutSession, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.success = true
method TLEncode*(self: AccountConfirmPasswordEmail): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x8fdf1920))
    result = result & TLEncode(self.code)
method TLDecode*(self: AccountConfirmPasswordEmail, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.code = cast[string](bytes.TLDecode())
method TLEncode*(self: AccountResendPasswordEmail): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x7a7f2a15))
method TLDecode*(self: AccountResendPasswordEmail, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: AccountCancelPasswordEmail): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc1cbd5b6))
method TLDecode*(self: AccountCancelPasswordEmail, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: AccountGetContactSignUpNotification): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x9f07c728))
method TLDecode*(self: AccountGetContactSignUpNotification, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: AccountSetContactSignUpNotification): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xcff43f61))
    result = result & TLEncode(self.silent)
method TLDecode*(self: AccountSetContactSignUpNotification, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(self.silent)
method TLEncode*(self: AccountGetNotifyExceptions): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x53577479))
    if self.compare_sound:
        self.flags = self.flags or 1 shl 1
    if self.peer.isSome():
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    if self.peer.isSome():
        result = result & TLEncode(self.peer.get())
method TLDecode*(self: AccountGetNotifyExceptions, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 1)) != 0:
        self.compare_sound = true
    if (self.flags and (1 shl 0)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.peer = some(tempVal.InputNotifyPeerI)
method TLEncode*(self: AccountGetWallPaper): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xfc8ddbea))
    result = result & TLEncode(self.wallpaper)
method TLDecode*(self: AccountGetWallPaper, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.wallpaper = cast[InputWallPaperI](tempObj)
method TLEncode*(self: AccountUploadWallPaper): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xdd853661))
    result = result & TLEncode(self.file)
    result = result & TLEncode(self.mime_type)
    result = result & TLEncode(self.settings)
method TLDecode*(self: AccountUploadWallPaper, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.file = cast[InputFileI](tempObj)
    self.mime_type = cast[string](bytes.TLDecode())
    tempObj.TLDecode(bytes)
    self.settings = cast[WallPaperSettingsI](tempObj)
method TLEncode*(self: AccountSaveWallPaper): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x6c5a5b37))
    result = result & TLEncode(self.wallpaper)
    result = result & TLEncode(self.unsave)
    result = result & TLEncode(self.settings)
method TLDecode*(self: AccountSaveWallPaper, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.wallpaper = cast[InputWallPaperI](tempObj)
    bytes.TLDecode(self.unsave)
    tempObj.TLDecode(bytes)
    self.settings = cast[WallPaperSettingsI](tempObj)
method TLEncode*(self: AccountInstallWallPaper): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xfeed5769))
    result = result & TLEncode(self.wallpaper)
    result = result & TLEncode(self.settings)
method TLDecode*(self: AccountInstallWallPaper, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.wallpaper = cast[InputWallPaperI](tempObj)
    tempObj.TLDecode(bytes)
    self.settings = cast[WallPaperSettingsI](tempObj)
method TLEncode*(self: AccountResetWallPapers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xbb3b9804))
method TLDecode*(self: AccountResetWallPapers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: AccountGetAutoDownloadSettings): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x56da0b3f))
method TLDecode*(self: AccountGetAutoDownloadSettings, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: AccountSaveAutoDownloadSettings): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x76f36233))
    if self.low:
        self.flags = self.flags or 1 shl 0
    if self.high:
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.settings)
method TLDecode*(self: AccountSaveAutoDownloadSettings, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.low = true
    if (self.flags and (1 shl 1)) != 0:
        self.high = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.settings = cast[AutoDownloadSettingsI](tempObj)
method TLEncode*(self: AccountUploadTheme): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x1c3db333))
    if self.thumb.isSome():
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.file)
    if self.thumb.isSome():
        result = result & TLEncode(self.thumb.get())
    result = result & TLEncode(self.file_name)
    result = result & TLEncode(self.mime_type)
method TLDecode*(self: AccountUploadTheme, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.file = cast[InputFileI](tempObj)
    if (self.flags and (1 shl 0)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.thumb = some(tempVal.InputFileI)
    self.file_name = cast[string](bytes.TLDecode())
    self.mime_type = cast[string](bytes.TLDecode())
method TLEncode*(self: AccountCreateTheme): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x8432c21f))
    if self.document.isSome():
        self.flags = self.flags or 1 shl 2
    if self.settings.isSome():
        self.flags = self.flags or 1 shl 3
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.slug)
    result = result & TLEncode(self.title)
    if self.document.isSome():
        result = result & TLEncode(self.document.get())
    if self.settings.isSome():
        result = result & TLEncode(self.settings.get())
method TLDecode*(self: AccountCreateTheme, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    self.slug = cast[string](bytes.TLDecode())
    self.title = cast[string](bytes.TLDecode())
    if (self.flags and (1 shl 2)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.document = some(tempVal.InputDocumentI)
    if (self.flags and (1 shl 3)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.settings = some(tempVal.InputThemeSettingsI)
method TLEncode*(self: AccountUpdateTheme): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x5cb367d5))
    if self.slug.isSome():
        self.flags = self.flags or 1 shl 0
    if self.title.isSome():
        self.flags = self.flags or 1 shl 1
    if self.document.isSome():
        self.flags = self.flags or 1 shl 2
    if self.settings.isSome():
        self.flags = self.flags or 1 shl 3
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.format)
    result = result & TLEncode(self.theme)
    if self.slug.isSome():
        result = result & TLEncode(self.slug.get())
    if self.title.isSome():
        result = result & TLEncode(self.title.get())
    if self.document.isSome():
        result = result & TLEncode(self.document.get())
    if self.settings.isSome():
        result = result & TLEncode(self.settings.get())
method TLDecode*(self: AccountUpdateTheme, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    self.format = cast[string](bytes.TLDecode())
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.theme = cast[InputThemeI](tempObj)
    if (self.flags and (1 shl 0)) != 0:
        self.slug = some(cast[string](bytes.TLDecode()))
    if (self.flags and (1 shl 1)) != 0:
        self.title = some(cast[string](bytes.TLDecode()))
    if (self.flags and (1 shl 2)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.document = some(tempVal.InputDocumentI)
    if (self.flags and (1 shl 3)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.settings = some(tempVal.InputThemeSettingsI)
method TLEncode*(self: AccountSaveTheme): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf257106c))
    result = result & TLEncode(self.theme)
    result = result & TLEncode(self.unsave)
method TLDecode*(self: AccountSaveTheme, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.theme = cast[InputThemeI](tempObj)
    bytes.TLDecode(self.unsave)
method TLEncode*(self: AccountInstallTheme): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x7ae43737))
    if self.dark:
        self.flags = self.flags or 1 shl 0
    if self.format.isSome():
        self.flags = self.flags or 1 shl 1
    if self.theme.isSome():
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    if self.format.isSome():
        result = result & TLEncode(self.format.get())
    if self.theme.isSome():
        result = result & TLEncode(self.theme.get())
method TLDecode*(self: AccountInstallTheme, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.dark = true
    if (self.flags and (1 shl 1)) != 0:
        self.format = some(cast[string](bytes.TLDecode()))
    if (self.flags and (1 shl 1)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.theme = some(tempVal.InputThemeI)
method TLEncode*(self: AccountGetTheme): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x8d9d742b))
    result = result & TLEncode(self.format)
    result = result & TLEncode(self.theme)
    result = result & TLEncode(self.document_id)
method TLDecode*(self: AccountGetTheme, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.format = cast[string](bytes.TLDecode())
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.theme = cast[InputThemeI](tempObj)
    bytes.TLDecode(addr self.document_id)
method TLEncode*(self: AccountGetThemes): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x285946f8))
    result = result & TLEncode(self.format)
    result = result & TLEncode(self.hash)
method TLDecode*(self: AccountGetThemes, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.format = cast[string](bytes.TLDecode())
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: AccountSetContentSettings): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb574b16b))
    if self.sensitive_enabled:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
method TLDecode*(self: AccountSetContentSettings, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.sensitive_enabled = true
method TLEncode*(self: AccountGetContentSettings): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x8b9b4dae))
method TLDecode*(self: AccountGetContentSettings, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: AccountGetMultiWallPapers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x65ad71dc))
    result = result & TLEncode(cast[seq[TL]](self.wallpapers))
method TLDecode*(self: AccountGetMultiWallPapers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.wallpapers = cast[seq[InputWallPaperI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: AccountGetGlobalPrivacySettings): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xeb2b4cf6))
method TLDecode*(self: AccountGetGlobalPrivacySettings, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: AccountSetGlobalPrivacySettings): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x1edaaac2))
    result = result & TLEncode(self.settings)
method TLDecode*(self: AccountSetGlobalPrivacySettings, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.settings = cast[GlobalPrivacySettingsI](tempObj)
method TLEncode*(self: AccountReportProfilePhoto): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xfa8cc6f5))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.photo_id)
    result = result & TLEncode(self.reason)
    result = result & TLEncode(self.message)
method TLDecode*(self: AccountReportProfilePhoto, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    tempObj.TLDecode(bytes)
    self.photo_id = cast[InputPhotoI](tempObj)
    tempObj.TLDecode(bytes)
    self.reason = cast[ReportReasonI](tempObj)
    self.message = cast[string](bytes.TLDecode())
