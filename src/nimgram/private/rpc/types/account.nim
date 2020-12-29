type
    AccountPrivacyRules* = ref object of AccountPrivacyRulesI
        rules*: seq[PrivacyRuleI]
        chats*: seq[ChatI]
        users*: seq[UserI]
    AccountAuthorizations* = ref object of AccountAuthorizationsI
        authorizations*: seq[AuthorizationI]
    AccountPassword* = ref object of AccountPasswordI
        flags: int32
        has_recovery*: bool
        has_secure_values*: bool
        has_password*: bool
        current_algo*: Option[PasswordKdfAlgoI]
        srp_B*: Option[seq[uint8]]
        srp_id*: Option[int64]
        hint*: Option[string]
        email_unconfirmed_pattern*: Option[string]
        new_algo*: PasswordKdfAlgoI
        new_secure_algo*: SecurePasswordKdfAlgoI
        secure_random*: seq[uint8]
    AccountPasswordSettings* = ref object of AccountPasswordSettingsI
        flags: int32
        email*: Option[string]
        secure_settings*: Option[SecureSecretSettingsI]
    AccountPasswordInputSettings* = ref object of AccountPasswordInputSettingsI
        flags: int32
        new_algo*: Option[PasswordKdfAlgoI]
        new_password_hash*: Option[seq[uint8]]
        hint*: Option[string]
        email*: Option[string]
        new_secure_settings*: Option[SecureSecretSettingsI]
    AccountTmpPassword* = ref object of AccountTmpPasswordI
        tmp_password*: seq[uint8]
        valid_until*: int32
    AccountWebAuthorizations* = ref object of AccountWebAuthorizationsI
        authorizations*: seq[WebAuthorizationI]
        users*: seq[UserI]
    AccountAuthorizationForm* = ref object of AccountAuthorizationFormI
        flags: int32
        required_types*: seq[SecureRequiredTypeI]
        values*: seq[SecureValueI]
        errors*: seq[SecureValueErrorI]
        users*: seq[UserI]
        privacy_policy_url*: Option[string]
    AccountSentEmailCode* = ref object of AccountSentEmailCodeI
        email_pattern*: string
        length*: int32
    AccountTakeout* = ref object of AccountTakeoutI
        id*: int64
    AccountWallPapersNotModified* = ref object of AccountWallPapersI
    AccountWallPapers* = ref object of AccountWallPapersI
        hash*: int32
        wallpapers*: seq[WallPaperI]
    AccountAutoDownloadSettings* = ref object of AccountAutoDownloadSettingsI
        low*: AutoDownloadSettingsI
        medium*: AutoDownloadSettingsI
        high*: AutoDownloadSettingsI
    AccountThemesNotModified* = ref object of AccountThemesI
    AccountThemes* = ref object of AccountThemesI
        hash*: int32
        themes*: seq[ThemeI]
    AccountContentSettings* = ref object of AccountContentSettingsI
        flags: int32
        sensitive_enabled*: bool
        sensitive_can_change*: bool
method getTypeName*(self: AccountPrivacyRules): string = "AccountPrivacyRules"
method getTypeName*(self: AccountAuthorizations): string = "AccountAuthorizations"
method getTypeName*(self: AccountPassword): string = "AccountPassword"
method getTypeName*(self: AccountPasswordSettings): string = "AccountPasswordSettings"
method getTypeName*(self: AccountPasswordInputSettings): string = "AccountPasswordInputSettings"
method getTypeName*(self: AccountTmpPassword): string = "AccountTmpPassword"
method getTypeName*(self: AccountWebAuthorizations): string = "AccountWebAuthorizations"
method getTypeName*(self: AccountAuthorizationForm): string = "AccountAuthorizationForm"
method getTypeName*(self: AccountSentEmailCode): string = "AccountSentEmailCode"
method getTypeName*(self: AccountTakeout): string = "AccountTakeout"
method getTypeName*(self: AccountWallPapersNotModified): string = "AccountWallPapersNotModified"
method getTypeName*(self: AccountWallPapers): string = "AccountWallPapers"
method getTypeName*(self: AccountAutoDownloadSettings): string = "AccountAutoDownloadSettings"
method getTypeName*(self: AccountThemesNotModified): string = "AccountThemesNotModified"
method getTypeName*(self: AccountThemes): string = "AccountThemes"
method getTypeName*(self: AccountContentSettings): string = "AccountContentSettings"

method TLEncode*(self: AccountPrivacyRules): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x50a04e45))
    result = result & TLEncode(cast[seq[TL]](self.rules))
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: AccountPrivacyRules, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.rules = cast[seq[PrivacyRuleI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: AccountAuthorizations): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x1250abde))
    result = result & TLEncode(cast[seq[TL]](self.authorizations))
method TLDecode*(self: AccountAuthorizations, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.authorizations = cast[seq[AuthorizationI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: AccountPassword): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xad2641f8))
    if self.has_recovery:
        self.flags = self.flags or 1 shl 0
    if self.has_secure_values:
        self.flags = self.flags or 1 shl 1
    if self.has_password:
        self.flags = self.flags or 1 shl 2
    if self.current_algo.isSome():
        self.flags = self.flags or 1 shl 2
    if self.srp_B.isSome():
        self.flags = self.flags or 1 shl 2
    if self.srp_id.isSome():
        self.flags = self.flags or 1 shl 2
    if self.hint.isSome():
        self.flags = self.flags or 1 shl 3
    if self.email_unconfirmed_pattern.isSome():
        self.flags = self.flags or 1 shl 4
    result = result & TLEncode(self.flags)
    if self.current_algo.isSome():
        result = result & TLEncode(self.current_algo.get())
    if self.srp_B.isSome():
        result = result & TLEncode(self.srp_B.get())
    if self.srp_id.isSome():
        result = result & TLEncode(self.srp_id.get())
    if self.hint.isSome():
        result = result & TLEncode(self.hint.get())
    if self.email_unconfirmed_pattern.isSome():
        result = result & TLEncode(self.email_unconfirmed_pattern.get())
    result = result & TLEncode(self.new_algo)
    result = result & TLEncode(self.new_secure_algo)
    result = result & TLEncode(self.secure_random)
method TLDecode*(self: AccountPassword, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.has_recovery = true
    if (self.flags and (1 shl 1)) != 0:
        self.has_secure_values = true
    if (self.flags and (1 shl 2)) != 0:
        self.has_password = true
    if (self.flags and (1 shl 2)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.current_algo = some(tempVal.PasswordKdfAlgoI)
    if (self.flags and (1 shl 2)) != 0:
        self.srp_B = some(bytes.TLDecode())
    if (self.flags and (1 shl 2)) != 0:
        var tempVal: int64 = 0
        bytes.TLDecode(addr tempVal)
        self.srp_id = some(tempVal)
    if (self.flags and (1 shl 3)) != 0:
        self.hint = some(cast[string](bytes.TLDecode()))
    if (self.flags and (1 shl 4)) != 0:
        self.email_unconfirmed_pattern = some(cast[string](bytes.TLDecode()))
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.new_algo = cast[PasswordKdfAlgoI](tempObj)
    tempObj.TLDecode(bytes)
    self.new_secure_algo = cast[SecurePasswordKdfAlgoI](tempObj)
    self.secure_random = bytes.TLDecode()
method TLEncode*(self: AccountPasswordSettings): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x9a5c33e5))
    if self.email.isSome():
        self.flags = self.flags or 1 shl 0
    if self.secure_settings.isSome():
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    if self.email.isSome():
        result = result & TLEncode(self.email.get())
    if self.secure_settings.isSome():
        result = result & TLEncode(self.secure_settings.get())
method TLDecode*(self: AccountPasswordSettings, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.email = some(cast[string](bytes.TLDecode()))
    if (self.flags and (1 shl 1)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.secure_settings = some(tempVal.SecureSecretSettingsI)
method TLEncode*(self: AccountPasswordInputSettings): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc23727c9))
    if self.new_algo.isSome():
        self.flags = self.flags or 1 shl 0
    if self.new_password_hash.isSome():
        self.flags = self.flags or 1 shl 0
    if self.hint.isSome():
        self.flags = self.flags or 1 shl 0
    if self.email.isSome():
        self.flags = self.flags or 1 shl 1
    if self.new_secure_settings.isSome():
        self.flags = self.flags or 1 shl 2
    result = result & TLEncode(self.flags)
    if self.new_algo.isSome():
        result = result & TLEncode(self.new_algo.get())
    if self.new_password_hash.isSome():
        result = result & TLEncode(self.new_password_hash.get())
    if self.hint.isSome():
        result = result & TLEncode(self.hint.get())
    if self.email.isSome():
        result = result & TLEncode(self.email.get())
    if self.new_secure_settings.isSome():
        result = result & TLEncode(self.new_secure_settings.get())
method TLDecode*(self: AccountPasswordInputSettings, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.new_algo = some(tempVal.PasswordKdfAlgoI)
    if (self.flags and (1 shl 0)) != 0:
        self.new_password_hash = some(bytes.TLDecode())
    if (self.flags and (1 shl 0)) != 0:
        self.hint = some(cast[string](bytes.TLDecode()))
    if (self.flags and (1 shl 1)) != 0:
        self.email = some(cast[string](bytes.TLDecode()))
    if (self.flags and (1 shl 2)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.new_secure_settings = some(tempVal.SecureSecretSettingsI)
method TLEncode*(self: AccountTmpPassword): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xdb64fd34))
    result = result & TLEncode(self.tmp_password)
    result = result & TLEncode(self.valid_until)
method TLDecode*(self: AccountTmpPassword, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.tmp_password = bytes.TLDecode()
    bytes.TLDecode(addr self.valid_until)
method TLEncode*(self: AccountWebAuthorizations): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xed56c9fc))
    result = result & TLEncode(cast[seq[TL]](self.authorizations))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: AccountWebAuthorizations, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.authorizations = cast[seq[WebAuthorizationI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: AccountAuthorizationForm): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xad2e1cd8))
    if self.privacy_policy_url.isSome():
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(cast[seq[TL]](self.required_types))
    result = result & TLEncode(cast[seq[TL]](self.values))
    result = result & TLEncode(cast[seq[TL]](self.errors))
    result = result & TLEncode(cast[seq[TL]](self.users))
    if self.privacy_policy_url.isSome():
        result = result & TLEncode(self.privacy_policy_url.get())
method TLDecode*(self: AccountAuthorizationForm, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.required_types = cast[seq[SecureRequiredTypeI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.values = cast[seq[SecureValueI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.errors = cast[seq[SecureValueErrorI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
    if (self.flags and (1 shl 0)) != 0:
        self.privacy_policy_url = some(cast[string](bytes.TLDecode()))
method TLEncode*(self: AccountSentEmailCode): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x811f854f))
    result = result & TLEncode(self.email_pattern)
    result = result & TLEncode(self.length)
method TLDecode*(self: AccountSentEmailCode, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.email_pattern = cast[string](bytes.TLDecode())
    bytes.TLDecode(addr self.length)
method TLEncode*(self: AccountTakeout): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x4dba4501))
    result = result & TLEncode(self.id)
method TLDecode*(self: AccountTakeout, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.id)
method TLEncode*(self: AccountWallPapersNotModified): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x1c199183))
method TLDecode*(self: AccountWallPapersNotModified, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: AccountWallPapers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x702b65a9))
    result = result & TLEncode(self.hash)
    result = result & TLEncode(cast[seq[TL]](self.wallpapers))
method TLDecode*(self: AccountWallPapers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.hash)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.wallpapers = cast[seq[WallPaperI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: AccountAutoDownloadSettings): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x63cacf26))
    result = result & TLEncode(self.low)
    result = result & TLEncode(self.medium)
    result = result & TLEncode(self.high)
method TLDecode*(self: AccountAutoDownloadSettings, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.low = cast[AutoDownloadSettingsI](tempObj)
    tempObj.TLDecode(bytes)
    self.medium = cast[AutoDownloadSettingsI](tempObj)
    tempObj.TLDecode(bytes)
    self.high = cast[AutoDownloadSettingsI](tempObj)
method TLEncode*(self: AccountThemesNotModified): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf41eb622))
method TLDecode*(self: AccountThemesNotModified, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: AccountThemes): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x7f676421))
    result = result & TLEncode(self.hash)
    result = result & TLEncode(cast[seq[TL]](self.themes))
method TLDecode*(self: AccountThemes, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.hash)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.themes = cast[seq[ThemeI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: AccountContentSettings): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x57e28221))
    if self.sensitive_enabled:
        self.flags = self.flags or 1 shl 0
    if self.sensitive_can_change:
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
method TLDecode*(self: AccountContentSettings, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.sensitive_enabled = true
    if (self.flags and (1 shl 1)) != 0:
        self.sensitive_can_change = true
