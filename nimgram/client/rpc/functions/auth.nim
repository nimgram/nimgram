type
    AuthSendCode* = ref object of TLFunction
        phone_number*: string
        api_id*: int32
        api_hash*: string
        settings*: CodeSettingsI
    AuthSignUp* = ref object of TLFunction
        phone_number*: string
        phone_code_hash*: string
        first_name*: string
        last_name*: string
    AuthSignIn* = ref object of TLFunction
        phone_number*: string
        phone_code_hash*: string
        phone_code*: string
    AuthLogOut* = ref object of TLFunction
    AuthResetAuthorizations* = ref object of TLFunction
    AuthExportAuthorization* = ref object of TLFunction
        dc_id*: int32
    AuthImportAuthorization* = ref object of TLFunction
        id*: int32
        bytes*: seq[uint8]
    AuthBindTempAuthKey* = ref object of TLFunction
        perm_auth_key_id*: int64
        nonce*: int64
        expires_at*: int32
        encrypted_message*: seq[uint8]
    AuthImportBotAuthorization* = ref object of TLFunction
        flags: int32
        api_id*: int32
        api_hash*: string
        bot_auth_token*: string
    AuthCheckPassword* = ref object of TLFunction
        password*: InputCheckPasswordSRPI
    AuthRequestPasswordRecovery* = ref object of TLFunction
    AuthRecoverPassword* = ref object of TLFunction
        code*: string
    AuthResendCode* = ref object of TLFunction
        phone_number*: string
        phone_code_hash*: string
    AuthCancelCode* = ref object of TLFunction
        phone_number*: string
        phone_code_hash*: string
    AuthDropTempAuthKeys* = ref object of TLFunction
        except_auth_keys*: seq[int64]
    AuthExportLoginToken* = ref object of TLFunction
        api_id*: int32
        api_hash*: string
        except_ids*: seq[int32]
    AuthImportLoginToken* = ref object of TLFunction
        token*: seq[uint8]
    AuthAcceptLoginToken* = ref object of TLFunction
        token*: seq[uint8]
method getTypeName*(self: AuthSendCode): string = "AuthSendCode"
method getTypeName*(self: AuthSignUp): string = "AuthSignUp"
method getTypeName*(self: AuthSignIn): string = "AuthSignIn"
method getTypeName*(self: AuthLogOut): string = "AuthLogOut"
method getTypeName*(self: AuthResetAuthorizations): string = "AuthResetAuthorizations"
method getTypeName*(self: AuthExportAuthorization): string = "AuthExportAuthorization"
method getTypeName*(self: AuthImportAuthorization): string = "AuthImportAuthorization"
method getTypeName*(self: AuthBindTempAuthKey): string = "AuthBindTempAuthKey"
method getTypeName*(self: AuthImportBotAuthorization): string = "AuthImportBotAuthorization"
method getTypeName*(self: AuthCheckPassword): string = "AuthCheckPassword"
method getTypeName*(self: AuthRequestPasswordRecovery): string = "AuthRequestPasswordRecovery"
method getTypeName*(self: AuthRecoverPassword): string = "AuthRecoverPassword"
method getTypeName*(self: AuthResendCode): string = "AuthResendCode"
method getTypeName*(self: AuthCancelCode): string = "AuthCancelCode"
method getTypeName*(self: AuthDropTempAuthKeys): string = "AuthDropTempAuthKeys"
method getTypeName*(self: AuthExportLoginToken): string = "AuthExportLoginToken"
method getTypeName*(self: AuthImportLoginToken): string = "AuthImportLoginToken"
method getTypeName*(self: AuthAcceptLoginToken): string = "AuthAcceptLoginToken"

method TLEncode*(self: AuthSendCode): seq[uint8] =
    result = TLEncode(uint32(0xa677244f))
    result = result & TLEncode(self.phone_number)
    result = result & TLEncode(self.api_id)
    result = result & TLEncode(self.api_hash)
    result = result & TLEncode(self.settings)
method TLDecode*(self: AuthSendCode, bytes: var ScalingSeq[uint8]) = 
    self.phone_number = cast[string](bytes.TLDecode())
    bytes.TLDecode(addr self.api_id)
    self.api_hash = cast[string](bytes.TLDecode())
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.settings = cast[CodeSettingsI](tempObj)
method TLEncode*(self: AuthSignUp): seq[uint8] =
    result = TLEncode(uint32(0x80eee427))
    result = result & TLEncode(self.phone_number)
    result = result & TLEncode(self.phone_code_hash)
    result = result & TLEncode(self.first_name)
    result = result & TLEncode(self.last_name)
method TLDecode*(self: AuthSignUp, bytes: var ScalingSeq[uint8]) = 
    self.phone_number = cast[string](bytes.TLDecode())
    self.phone_code_hash = cast[string](bytes.TLDecode())
    self.first_name = cast[string](bytes.TLDecode())
    self.last_name = cast[string](bytes.TLDecode())
method TLEncode*(self: AuthSignIn): seq[uint8] =
    result = TLEncode(uint32(0xbcd51581))
    result = result & TLEncode(self.phone_number)
    result = result & TLEncode(self.phone_code_hash)
    result = result & TLEncode(self.phone_code)
method TLDecode*(self: AuthSignIn, bytes: var ScalingSeq[uint8]) = 
    self.phone_number = cast[string](bytes.TLDecode())
    self.phone_code_hash = cast[string](bytes.TLDecode())
    self.phone_code = cast[string](bytes.TLDecode())
method TLEncode*(self: AuthLogOut): seq[uint8] =
    result = TLEncode(uint32(0x5717da40))
method TLDecode*(self: AuthLogOut, bytes: var ScalingSeq[uint8]) = 
    discard
method TLEncode*(self: AuthResetAuthorizations): seq[uint8] =
    result = TLEncode(uint32(0x9fab0d1a))
method TLDecode*(self: AuthResetAuthorizations, bytes: var ScalingSeq[uint8]) = 
    discard
method TLEncode*(self: AuthExportAuthorization): seq[uint8] =
    result = TLEncode(uint32(0xe5bfffcd))
    result = result & TLEncode(self.dc_id)
method TLDecode*(self: AuthExportAuthorization, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.dc_id)
method TLEncode*(self: AuthImportAuthorization): seq[uint8] =
    result = TLEncode(uint32(0xe3ef9613))
    result = result & TLEncode(self.id)
    result = result & TLEncode(self.bytes)
method TLDecode*(self: AuthImportAuthorization, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.id)
    self.bytes = bytes.TLDecode()
method TLEncode*(self: AuthBindTempAuthKey): seq[uint8] =
    result = TLEncode(uint32(0xcdd42a05))
    result = result & TLEncode(self.perm_auth_key_id)
    result = result & TLEncode(self.nonce)
    result = result & TLEncode(self.expires_at)
    result = result & TLEncode(self.encrypted_message)
method TLDecode*(self: AuthBindTempAuthKey, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.perm_auth_key_id)
    bytes.TLDecode(addr self.nonce)
    bytes.TLDecode(addr self.expires_at)
    self.encrypted_message = bytes.TLDecode()
method TLEncode*(self: AuthImportBotAuthorization): seq[uint8] =
    result = TLEncode(uint32(0x67a3ff2c))
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.api_id)
    result = result & TLEncode(self.api_hash)
    result = result & TLEncode(self.bot_auth_token)
method TLDecode*(self: AuthImportBotAuthorization, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.flags)
    bytes.TLDecode(addr self.api_id)
    self.api_hash = cast[string](bytes.TLDecode())
    self.bot_auth_token = cast[string](bytes.TLDecode())
method TLEncode*(self: AuthCheckPassword): seq[uint8] =
    result = TLEncode(uint32(0xd18b4d16))
    result = result & TLEncode(self.password)
method TLDecode*(self: AuthCheckPassword, bytes: var ScalingSeq[uint8]) = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.password = cast[InputCheckPasswordSRPI](tempObj)
method TLEncode*(self: AuthRequestPasswordRecovery): seq[uint8] =
    result = TLEncode(uint32(0xd897bc66))
method TLDecode*(self: AuthRequestPasswordRecovery, bytes: var ScalingSeq[uint8]) = 
    discard
method TLEncode*(self: AuthRecoverPassword): seq[uint8] =
    result = TLEncode(uint32(0x4ea56e92))
    result = result & TLEncode(self.code)
method TLDecode*(self: AuthRecoverPassword, bytes: var ScalingSeq[uint8]) = 
    self.code = cast[string](bytes.TLDecode())
method TLEncode*(self: AuthResendCode): seq[uint8] =
    result = TLEncode(uint32(0x3ef1a9bf))
    result = result & TLEncode(self.phone_number)
    result = result & TLEncode(self.phone_code_hash)
method TLDecode*(self: AuthResendCode, bytes: var ScalingSeq[uint8]) = 
    self.phone_number = cast[string](bytes.TLDecode())
    self.phone_code_hash = cast[string](bytes.TLDecode())
method TLEncode*(self: AuthCancelCode): seq[uint8] =
    result = TLEncode(uint32(0x1f040578))
    result = result & TLEncode(self.phone_number)
    result = result & TLEncode(self.phone_code_hash)
method TLDecode*(self: AuthCancelCode, bytes: var ScalingSeq[uint8]) = 
    self.phone_number = cast[string](bytes.TLDecode())
    self.phone_code_hash = cast[string](bytes.TLDecode())
method TLEncode*(self: AuthDropTempAuthKeys): seq[uint8] =
    result = TLEncode(uint32(0x8e48a188))
    result = result & TLEncode(self.except_auth_keys)
method TLDecode*(self: AuthDropTempAuthKeys, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(self.except_auth_keys)
method TLEncode*(self: AuthExportLoginToken): seq[uint8] =
    result = TLEncode(uint32(0xb1b41517))
    result = result & TLEncode(self.api_id)
    result = result & TLEncode(self.api_hash)
    result = result & TLEncode(self.except_ids)
method TLDecode*(self: AuthExportLoginToken, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.api_id)
    self.api_hash = cast[string](bytes.TLDecode())
    bytes.TLDecode(self.except_ids)
method TLEncode*(self: AuthImportLoginToken): seq[uint8] =
    result = TLEncode(uint32(0x95ac5ce4))
    result = result & TLEncode(self.token)
method TLDecode*(self: AuthImportLoginToken, bytes: var ScalingSeq[uint8]) = 
    self.token = bytes.TLDecode()
method TLEncode*(self: AuthAcceptLoginToken): seq[uint8] =
    result = TLEncode(uint32(0xe894ad4d))
    result = result & TLEncode(self.token)
method TLDecode*(self: AuthAcceptLoginToken, bytes: var ScalingSeq[uint8]) = 
    self.token = bytes.TLDecode()
