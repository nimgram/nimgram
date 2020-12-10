type
    AuthSentCode* = ref object of AuthSentCodeI
        flags: int32
        typeof*: AuthSentCodeTypeI
        phone_code_hash*: string
        next_type*: Option[AuthCodeTypeI]
        timeout*: Option[int32]
    AuthAuthorization* = ref object of AuthAuthorizationI
        flags: int32
        tmp_sessions*: Option[int32]
        user*: UserI
    AuthAuthorizationSignUpRequired* = ref object of AuthAuthorizationI
        flags: int32
        terms_of_service*: Option[HelpTermsOfServiceI]
    AuthExportedAuthorization* = ref object of AuthExportedAuthorizationI
        id*: int32
        bytes*: seq[uint8]
    AuthPasswordRecovery* = ref object of AuthPasswordRecoveryI
        email_pattern*: string
    AuthCodeTypeSms* = ref object of AuthCodeTypeI
    AuthCodeTypeCall* = ref object of AuthCodeTypeI
    AuthCodeTypeFlashCall* = ref object of AuthCodeTypeI
    AuthSentCodeTypeApp* = ref object of AuthSentCodeTypeI
        length*: int32
    AuthSentCodeTypeSms* = ref object of AuthSentCodeTypeI
        length*: int32
    AuthSentCodeTypeCall* = ref object of AuthSentCodeTypeI
        length*: int32
    AuthSentCodeTypeFlashCall* = ref object of AuthSentCodeTypeI
        pattern*: string
    AuthLoginToken* = ref object of AuthLoginTokenI
        expires*: int32
        token*: seq[uint8]
    AuthLoginTokenMigrateTo* = ref object of AuthLoginTokenI
        dc_id*: int32
        token*: seq[uint8]
    AuthLoginTokenSuccess* = ref object of AuthLoginTokenI
        authorization*: AuthAuthorizationI
method getTypeName*(self: AuthSentCode): string = "AuthSentCode"
method getTypeName*(self: AuthAuthorization): string = "AuthAuthorization"
method getTypeName*(self: AuthAuthorizationSignUpRequired): string = "AuthAuthorizationSignUpRequired"
method getTypeName*(self: AuthExportedAuthorization): string = "AuthExportedAuthorization"
method getTypeName*(self: AuthPasswordRecovery): string = "AuthPasswordRecovery"
method getTypeName*(self: AuthCodeTypeSms): string = "AuthCodeTypeSms"
method getTypeName*(self: AuthCodeTypeCall): string = "AuthCodeTypeCall"
method getTypeName*(self: AuthCodeTypeFlashCall): string = "AuthCodeTypeFlashCall"
method getTypeName*(self: AuthSentCodeTypeApp): string = "AuthSentCodeTypeApp"
method getTypeName*(self: AuthSentCodeTypeSms): string = "AuthSentCodeTypeSms"
method getTypeName*(self: AuthSentCodeTypeCall): string = "AuthSentCodeTypeCall"
method getTypeName*(self: AuthSentCodeTypeFlashCall): string = "AuthSentCodeTypeFlashCall"
method getTypeName*(self: AuthLoginToken): string = "AuthLoginToken"
method getTypeName*(self: AuthLoginTokenMigrateTo): string = "AuthLoginTokenMigrateTo"
method getTypeName*(self: AuthLoginTokenSuccess): string = "AuthLoginTokenSuccess"

method TLEncode*(self: AuthSentCode): seq[uint8] =
    result = TLEncode(uint32(0x5e002502))
    if self.next_type.isSome():
        self.flags = self.flags or 1 shl 1
    if self.timeout.isSome():
        self.flags = self.flags or 1 shl 2
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.typeof)
    result = result & TLEncode(self.phone_code_hash)
    if self.next_type.isSome():
        result = result & TLEncode(self.next_type.get())
    if self.timeout.isSome():
        result = result & TLEncode(self.timeout.get())
method TLDecode*(self: AuthSentCode, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.flags)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.typeof = cast[AuthSentCodeTypeI](tempObj)
    self.phone_code_hash = cast[string](bytes.TLDecode())
    if (self.flags and (1 shl 1)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.next_type = some(tempVal.AuthCodeTypeI)
    if (self.flags and (1 shl 2)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.timeout = some(tempVal)
method TLEncode*(self: AuthAuthorization): seq[uint8] =
    result = TLEncode(uint32(0xcd050916))
    if self.tmp_sessions.isSome():
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    if self.tmp_sessions.isSome():
        result = result & TLEncode(self.tmp_sessions.get())
    result = result & TLEncode(self.user)
method TLDecode*(self: AuthAuthorization, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.tmp_sessions = some(tempVal)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.user = cast[UserI](tempObj)
method TLEncode*(self: AuthAuthorizationSignUpRequired): seq[uint8] =
    result = TLEncode(uint32(0x44747e9a))
    if self.terms_of_service.isSome():
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    if self.terms_of_service.isSome():
        result = result & TLEncode(self.terms_of_service.get())
method TLDecode*(self: AuthAuthorizationSignUpRequired, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.terms_of_service = some(tempVal.HelpTermsOfServiceI)
method TLEncode*(self: AuthExportedAuthorization): seq[uint8] =
    result = TLEncode(uint32(0xdf969c2d))
    result = result & TLEncode(self.id)
    result = result & TLEncode(self.bytes)
method TLDecode*(self: AuthExportedAuthorization, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.id)
    self.bytes = bytes.TLDecode()
method TLEncode*(self: AuthPasswordRecovery): seq[uint8] =
    result = TLEncode(uint32(0x137948a5))
    result = result & TLEncode(self.email_pattern)
method TLDecode*(self: AuthPasswordRecovery, bytes: var ScalingSeq[uint8]) = 
    self.email_pattern = cast[string](bytes.TLDecode())
method TLEncode*(self: AuthCodeTypeSms): seq[uint8] =
    result = TLEncode(uint32(0x72a3158c))
method TLDecode*(self: AuthCodeTypeSms, bytes: var ScalingSeq[uint8]) = 
    discard
method TLEncode*(self: AuthCodeTypeCall): seq[uint8] =
    result = TLEncode(uint32(0x741cd3e3))
method TLDecode*(self: AuthCodeTypeCall, bytes: var ScalingSeq[uint8]) = 
    discard
method TLEncode*(self: AuthCodeTypeFlashCall): seq[uint8] =
    result = TLEncode(uint32(0x226ccefb))
method TLDecode*(self: AuthCodeTypeFlashCall, bytes: var ScalingSeq[uint8]) = 
    discard
method TLEncode*(self: AuthSentCodeTypeApp): seq[uint8] =
    result = TLEncode(uint32(0x3dbb5986))
    result = result & TLEncode(self.length)
method TLDecode*(self: AuthSentCodeTypeApp, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.length)
method TLEncode*(self: AuthSentCodeTypeSms): seq[uint8] =
    result = TLEncode(uint32(0xc000bba2))
    result = result & TLEncode(self.length)
method TLDecode*(self: AuthSentCodeTypeSms, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.length)
method TLEncode*(self: AuthSentCodeTypeCall): seq[uint8] =
    result = TLEncode(uint32(0x5353e5a7))
    result = result & TLEncode(self.length)
method TLDecode*(self: AuthSentCodeTypeCall, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.length)
method TLEncode*(self: AuthSentCodeTypeFlashCall): seq[uint8] =
    result = TLEncode(uint32(0xab03c6d9))
    result = result & TLEncode(self.pattern)
method TLDecode*(self: AuthSentCodeTypeFlashCall, bytes: var ScalingSeq[uint8]) = 
    self.pattern = cast[string](bytes.TLDecode())
method TLEncode*(self: AuthLoginToken): seq[uint8] =
    result = TLEncode(uint32(0x629f1980))
    result = result & TLEncode(self.expires)
    result = result & TLEncode(self.token)
method TLDecode*(self: AuthLoginToken, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.expires)
    self.token = bytes.TLDecode()
method TLEncode*(self: AuthLoginTokenMigrateTo): seq[uint8] =
    result = TLEncode(uint32(0x68e9916))
    result = result & TLEncode(self.dc_id)
    result = result & TLEncode(self.token)
method TLDecode*(self: AuthLoginTokenMigrateTo, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.dc_id)
    self.token = bytes.TLDecode()
method TLEncode*(self: AuthLoginTokenSuccess): seq[uint8] =
    result = TLEncode(uint32(0x390d5c5e))
    result = result & TLEncode(self.authorization)
method TLDecode*(self: AuthLoginTokenSuccess, bytes: var ScalingSeq[uint8]) = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.authorization = cast[AuthAuthorizationI](tempObj)
