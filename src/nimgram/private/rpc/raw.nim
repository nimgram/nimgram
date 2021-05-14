
## Nimgram
## Copyright (C) 2020-2021 Daniele Cortesi <https://github.com/dadadani>
## This file is part of Nimgram, under the MIT License
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY
## OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
## SOFTWARE.

import options
import encoding
import decoding
import strformat
import stint
import zippy

type TL* = ref object of RootObj

type TLObject* = ref object of TL

type TLFunction* = ref object of TL

method getTypeName*(self: TL): string {.base.} = "TL"

method TLEncode*(self: TL): seq[uint8] {.base, locks: "unknown".} = raise newException(CatchableError, "Trying to encode a generic object")

proc TLEncode*(self: seq[TL]): seq[uint8] 

method getTypeName*(self: TLObject): string = "TLObject"

method getTypeName*(self: TLFunction): string = "TLFunction"

method TLDecode*(self: TL, bytes: var ScalingSeq[uint8]) {.base, locks: "unknown".} = discard

proc TLDecode*(self: var TL, bytes: var ScalingSeq[uint8])    

proc TLDecode*(self: var seq[TL], bytes: var ScalingSeq[uint8])
    

type GZipPacked* = ref object of TLObject
        body*: TL
        
method getTypeName*(self: GZipPacked): string = "GZipPacked"

method TLEncode*(self: GZipPacked): seq[uint8] {.locks: "unknown".} =
    result.add(TLEncode(uint32(0x3072CFA1)))
    result.add(TLEncode(compress(self.body.TLEncode())))

method TLDecode*(self: GZipPacked, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} =
    var data = newScalingSeq(uncompress(bytes.TLDecode()))
    self.body.TLDecode(data)

type 
    RPCException* = ref object of CatchableError
        errorCode* : int32
        errorMessage*: string

    FutureSalt* = ref object of TLObject
        validSince*: int32
        validUntil*: int32
        salt*: uint64
    FutureSalts* = ref object of TLObject
        reqMsgID*: uint64
        now*: int32
        salts*: seq[FutureSalt]
    CoreMessage* = ref object
        msgID*: uint64 
        seqNo*: uint32
        lenght*: uint32
        body*: TL
    MessageContainer* = ref object of TLObject
        messages*: seq[CoreMessage]

method getTypeName*(self: FutureSalt): string = "FutureSalt"
method getTypeName*(self: FutureSalts): string = "FutureSalts"
method getTypeName*(self: MessageContainer): string = "MessageContainer"


method TLDecode*(self: FutureSalt, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} =
    bytes.TLDecode(addr self.validSince) 
    bytes.TLDecode(addr self.validUntil)
    bytes.TLDecode(addr self.salt)  


method TLDecode*(self: FutureSalts, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} =
    bytes.TLDecode(addr self.reqMsgID)
    bytes.TLDecode(addr self.now)
    
    var lenght: int32
    bytes.TLDecode(addr lenght)

    for _ in countup(1, lenght):
        var tmp = new FutureSalt
        tmp.TLDecode(bytes)
        self.salts.add(tmp)

proc TLEncode*(self: CoreMessage): seq[uint8] =
    result.add(self.msgID.TLEncode())
    result.add(self.seqNo.TLEncode())
    var body = TLEncode(self.body)
    result.add(TLEncode(uint32(len(body)))) 
    result.add(body)

proc TLDecode*(self: CoreMessage, bytes: var ScalingSeq[uint8])

method TLDecode*(self: MessageContainer, bytes: var ScalingSeq[uint8]) =
    var lenght: uint32
    bytes.TLDecode(addr lenght)
    for _ in countup(1, int(lenght)):
        var tmp = new CoreMessage
        tmp.TLDecode(bytes)
        self.messages.add(tmp)

proc TLDecode*(self: CoreMessage, bytes: var ScalingSeq[uint8]) =
    bytes.TLDecode(addr self.msgID)
    bytes.TLDecode(addr self.seqNo)
    bytes.TLDecode(addr self.lenght)
    var objectBytes = newScalingSeq(bytes.readN(int(self.lenght)))
    self.body.TLDecode(objectBytes)

method TLEncode*(self: MessageContainer): seq[uint8] =
    result = TLEncode(uint32(0x73F1F8DC))
    result.add(TLEncode(uint32(len(self.messages))))

    for i in self.messages:
        result.add(TLEncode(i))


include types/base
include functions/base
include core/types/base
include core/functions/base

proc TLEncode(self: seq[TL]): seq[uint8] =
    result.add(TLEncode(uint32(481674261)))
    result.add(TLEncode(uint32(self.len)))
    for obj in self:
        result.add(obj.TLEncode())

proc TLDecode*(self: var seq[TL], bytes: var ScalingSeq[uint8]) =
    var id: uint32
    bytes.TLDecode(addr id)
    var lenght: int32
    bytes.TLDecode(addr lenght)
    var obj = new TL
    for i in countup(1, lenght):
        obj.TLDecode(bytes)
        self.add(obj)


proc seqNo*(self: TL, currentInt: int): int =
    var related = 1
    if self of MessageContainer or self of Ping or self of Msgs_ack:
        related = 0
    var fdasfd = currentInt + (2 * related)
    return fdasfd
const LAYER_VERSION* = 126

proc TLDecode*(self: var TL, bytes: var ScalingSeq[uint8]) = 
        var id: uint32
        bytes.TLDecode(addr id)
        case id:
        of uint32(0x60469778):
            var tmp = new Req_pq
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbe7e8ef1):
            var tmp = new Req_pq_multi
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd712e4be):
            var tmp = new Req_DH_params
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf5045f1f):
            var tmp = new Set_client_DH_params
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x58e4a740):
            var tmp = new Rpc_drop_answer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb921bd04):
            var tmp = new Get_future_salts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7abe77ec):
            var tmp = new Ping
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf3427b8c):
            var tmp = new Ping_delay_disconnect
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe7512126):
            var tmp = new Destroy_session
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9299359f):
            var tmp = new Http_wait
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x05162463):
            var tmp = new ResPQ
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x83c95aec):
            var tmp = new P_q_inner_data
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x79cb045d):
            var tmp = new Server_DH_params_fail
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd0e8075c):
            var tmp = new Server_DH_params_ok
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb5890dba):
            var tmp = new Server_DH_inner_data
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6643b654):
            var tmp = new Client_DH_inner_data
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3bcbf734):
            var tmp = new Dh_gen_ok
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x46dc1fb9):
            var tmp = new Dh_gen_retry
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa69dae02):
            var tmp = new Dh_gen_fail
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf35c6d01):
            var tmp = new Rpc_result
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2144ca19):
            var tmp = new Rpc_error
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5e2ad36e):
            var tmp = new Rpc_answer_unknown
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xcd78e586):
            var tmp = new Rpc_answer_dropped_running
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa43ad8b7):
            var tmp = new Rpc_answer_dropped
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x347773c5):
            var tmp = new Pong
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe22045fc):
            var tmp = new Destroy_session_ok
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x62d350c9):
            var tmp = new Destroy_session_none
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9ec20908):
            var tmp = new New_session_created
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x62d6b459):
            var tmp = new Msgs_ack
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa7eff811):
            var tmp = new Bad_msg_notification
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xedab447b):
            var tmp = new Bad_server_salt
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7d861a08):
            var tmp = new Msg_resend_req
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xda69fb52):
            var tmp = new Msgs_state_req
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x04deb57d):
            var tmp = new Msgs_state_info
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8cc0d131):
            var tmp = new Msgs_all_info
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x276d3ec6):
            var tmp = new Msg_detailed_info
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x809db6df):
            var tmp = new Msg_new_detailed_info
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xcb9f372d):
            var tmp = new InvokeAfterMsg
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3dc4b4f0):
            var tmp = new InvokeAfterMsgs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc1cd5ea9):
            var tmp = new InitConnection
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xda9b0d0d):
            var tmp = new InvokeWithLayer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbf9459b7):
            var tmp = new InvokeWithoutUpdates
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x365275f2):
            var tmp = new InvokeWithMessagesRange
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xaca9fd2e):
            var tmp = new InvokeWithTakeout
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa677244f):
            var tmp = new AuthSendCode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x80eee427):
            var tmp = new AuthSignUp
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbcd51581):
            var tmp = new AuthSignIn
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5717da40):
            var tmp = new AuthLogOut
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9fab0d1a):
            var tmp = new AuthResetAuthorizations
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe5bfffcd):
            var tmp = new AuthExportAuthorization
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe3ef9613):
            var tmp = new AuthImportAuthorization
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xcdd42a05):
            var tmp = new AuthBindTempAuthKey
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x67a3ff2c):
            var tmp = new AuthImportBotAuthorization
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd18b4d16):
            var tmp = new AuthCheckPassword
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd897bc66):
            var tmp = new AuthRequestPasswordRecovery
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4ea56e92):
            var tmp = new AuthRecoverPassword
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3ef1a9bf):
            var tmp = new AuthResendCode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1f040578):
            var tmp = new AuthCancelCode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8e48a188):
            var tmp = new AuthDropTempAuthKeys
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb1b41517):
            var tmp = new AuthExportLoginToken
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x95ac5ce4):
            var tmp = new AuthImportLoginToken
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe894ad4d):
            var tmp = new AuthAcceptLoginToken
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x68976c6f):
            var tmp = new AccountRegisterDevice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3076c4bf):
            var tmp = new AccountUnregisterDevice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x84be5b93):
            var tmp = new AccountUpdateNotifySettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x12b3ad31):
            var tmp = new AccountGetNotifySettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdb7e1747):
            var tmp = new AccountResetNotifySettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x78515775):
            var tmp = new AccountUpdateProfile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6628562c):
            var tmp = new AccountUpdateStatus
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xaabb1763):
            var tmp = new AccountGetWallPapers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc5ba3d86):
            var tmp = new AccountReportPeer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2714d86c):
            var tmp = new AccountCheckUsername
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3e0bdd7c):
            var tmp = new AccountUpdateUsername
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdadbc950):
            var tmp = new AccountGetPrivacy
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc9f81ce8):
            var tmp = new AccountSetPrivacy
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x418d4e0b):
            var tmp = new AccountDeleteAccount
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8fc711d):
            var tmp = new AccountGetAccountTTL
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2442485e):
            var tmp = new AccountSetAccountTTL
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x82574ae5):
            var tmp = new AccountSendChangePhoneCode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x70c32edb):
            var tmp = new AccountChangePhone
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x38df3532):
            var tmp = new AccountUpdateDeviceLocked
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe320c158):
            var tmp = new AccountGetAuthorizations
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdf77f3bc):
            var tmp = new AccountResetAuthorization
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x548a30f5):
            var tmp = new AccountGetPassword
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9cd4eaf9):
            var tmp = new AccountGetPasswordSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa59b102f):
            var tmp = new AccountUpdatePasswordSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1b3faa88):
            var tmp = new AccountSendConfirmPhoneCode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5f2178c3):
            var tmp = new AccountConfirmPhone
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x449e0b51):
            var tmp = new AccountGetTmpPassword
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x182e6d6f):
            var tmp = new AccountGetWebAuthorizations
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2d01b9ef):
            var tmp = new AccountResetWebAuthorization
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x682d2594):
            var tmp = new AccountResetWebAuthorizations
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb288bc7d):
            var tmp = new AccountGetAllSecureValues
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x73665bc2):
            var tmp = new AccountGetSecureValue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x899fe31d):
            var tmp = new AccountSaveSecureValue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb880bc4b):
            var tmp = new AccountDeleteSecureValue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb86ba8e1):
            var tmp = new AccountGetAuthorizationForm
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe7027c94):
            var tmp = new AccountAcceptAuthorization
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa5a356f9):
            var tmp = new AccountSendVerifyPhoneCode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4dd3a7f6):
            var tmp = new AccountVerifyPhone
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7011509f):
            var tmp = new AccountSendVerifyEmailCode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xecba39db):
            var tmp = new AccountVerifyEmail
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf05b4804):
            var tmp = new AccountInitTakeoutSession
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1d2652ee):
            var tmp = new AccountFinishTakeoutSession
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8fdf1920):
            var tmp = new AccountConfirmPasswordEmail
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7a7f2a15):
            var tmp = new AccountResendPasswordEmail
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc1cbd5b6):
            var tmp = new AccountCancelPasswordEmail
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9f07c728):
            var tmp = new AccountGetContactSignUpNotification
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xcff43f61):
            var tmp = new AccountSetContactSignUpNotification
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x53577479):
            var tmp = new AccountGetNotifyExceptions
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfc8ddbea):
            var tmp = new AccountGetWallPaper
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdd853661):
            var tmp = new AccountUploadWallPaper
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6c5a5b37):
            var tmp = new AccountSaveWallPaper
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfeed5769):
            var tmp = new AccountInstallWallPaper
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbb3b9804):
            var tmp = new AccountResetWallPapers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x56da0b3f):
            var tmp = new AccountGetAutoDownloadSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x76f36233):
            var tmp = new AccountSaveAutoDownloadSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1c3db333):
            var tmp = new AccountUploadTheme
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8432c21f):
            var tmp = new AccountCreateTheme
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5cb367d5):
            var tmp = new AccountUpdateTheme
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf257106c):
            var tmp = new AccountSaveTheme
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7ae43737):
            var tmp = new AccountInstallTheme
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8d9d742b):
            var tmp = new AccountGetTheme
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x285946f8):
            var tmp = new AccountGetThemes
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb574b16b):
            var tmp = new AccountSetContentSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8b9b4dae):
            var tmp = new AccountGetContentSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x65ad71dc):
            var tmp = new AccountGetMultiWallPapers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xeb2b4cf6):
            var tmp = new AccountGetGlobalPrivacySettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1edaaac2):
            var tmp = new AccountSetGlobalPrivacySettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfa8cc6f5):
            var tmp = new AccountReportProfilePhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd91a548):
            var tmp = new UsersGetUsers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xca30a5b1):
            var tmp = new UsersGetFullUser
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x90c894b5):
            var tmp = new UsersSetSecureValueErrors
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2caa4a42):
            var tmp = new ContactsGetContactIDs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc4a353ee):
            var tmp = new ContactsGetStatuses
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc023849f):
            var tmp = new ContactsGetContacts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2c800be5):
            var tmp = new ContactsImportContacts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x96a0e00):
            var tmp = new ContactsDeleteContacts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1013fd9e):
            var tmp = new ContactsDeleteByPhones
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x68cc1411):
            var tmp = new ContactsBlock
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbea65d50):
            var tmp = new ContactsUnblock
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf57c350f):
            var tmp = new ContactsGetBlocked
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x11f812d8):
            var tmp = new ContactsSearch
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf93ccba3):
            var tmp = new ContactsResolveUsername
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd4982db5):
            var tmp = new ContactsGetTopPeers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1ae373ac):
            var tmp = new ContactsResetTopPeerRating
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x879537f1):
            var tmp = new ContactsResetSaved
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x82f1e39f):
            var tmp = new ContactsGetSaved
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8514bdda):
            var tmp = new ContactsToggleTopPeers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe8f463d0):
            var tmp = new ContactsAddContact
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf831a20f):
            var tmp = new ContactsAcceptContact
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd348bc44):
            var tmp = new ContactsGetLocated
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x29a8962c):
            var tmp = new ContactsBlockFromReplies
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x63c66506):
            var tmp = new MessagesGetMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa0ee3b73):
            var tmp = new MessagesGetDialogs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdcbb8260):
            var tmp = new MessagesGetHistory
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc352eec):
            var tmp = new MessagesSearch
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe306d3a):
            var tmp = new MessagesReadHistory
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1c015b09):
            var tmp = new MessagesDeleteHistory
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe58e95d2):
            var tmp = new MessagesDeleteMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5a954c0):
            var tmp = new MessagesReceivedMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x58943ee2):
            var tmp = new MessagesSetTyping
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x520c3870):
            var tmp = new MessagesSendMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3491eba9):
            var tmp = new MessagesSendMedia
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd9fee60e):
            var tmp = new MessagesForwardMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xcf1592db):
            var tmp = new MessagesReportSpam
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3672e09c):
            var tmp = new MessagesGetPeerSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8953ab4e):
            var tmp = new MessagesReport
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3c6aa187):
            var tmp = new MessagesGetChats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3b831c66):
            var tmp = new MessagesGetFullChat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdc452855):
            var tmp = new MessagesEditChatTitle
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xca4c79d8):
            var tmp = new MessagesEditChatPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf9a0aa09):
            var tmp = new MessagesAddChatUser
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc534459a):
            var tmp = new MessagesDeleteChatUser
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9cb126e):
            var tmp = new MessagesCreateChat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x26cf8950):
            var tmp = new MessagesGetDhConfig
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf64daf43):
            var tmp = new MessagesRequestEncryption
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3dbc0415):
            var tmp = new MessagesAcceptEncryption
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf393aea0):
            var tmp = new MessagesDiscardEncryption
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x791451ed):
            var tmp = new MessagesSetEncryptedTyping
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7f4b690a):
            var tmp = new MessagesReadEncryptedHistory
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x44fa7a15):
            var tmp = new MessagesSendEncrypted
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5559481d):
            var tmp = new MessagesSendEncryptedFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x32d439a4):
            var tmp = new MessagesSendEncryptedService
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x55a5bb66):
            var tmp = new MessagesReceivedQueue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4b0c8c0f):
            var tmp = new MessagesReportEncryptedSpam
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x36a73f77):
            var tmp = new MessagesReadMessageContents
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x43d4f2c):
            var tmp = new MessagesGetStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1c9618b1):
            var tmp = new MessagesGetAllStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8b68b0cc):
            var tmp = new MessagesGetWebPagePreview
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x14b9bcd7):
            var tmp = new MessagesExportChatInvite
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3eadb1bb):
            var tmp = new MessagesCheckChatInvite
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6c50051c):
            var tmp = new MessagesImportChatInvite
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2619a90e):
            var tmp = new MessagesGetStickerSet
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc78fe460):
            var tmp = new MessagesInstallStickerSet
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf96e55de):
            var tmp = new MessagesUninstallStickerSet
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe6df7378):
            var tmp = new MessagesStartBot
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5784d3e1):
            var tmp = new MessagesGetMessagesViews
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa9e69f2e):
            var tmp = new MessagesEditChatAdmin
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x15a3b8e3):
            var tmp = new MessagesMigrateChat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4bc6589a):
            var tmp = new MessagesSearchGlobal
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x78337739):
            var tmp = new MessagesReorderStickerSets
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x338e2464):
            var tmp = new MessagesGetDocumentByHash
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x83bf3d52):
            var tmp = new MessagesGetSavedGifs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x327a30cb):
            var tmp = new MessagesSaveGif
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x514e999d):
            var tmp = new MessagesGetInlineBotResults
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xeb5ea206):
            var tmp = new MessagesSetInlineBotResults
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x220815b0):
            var tmp = new MessagesSendInlineBotResult
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfda68d36):
            var tmp = new MessagesGetMessageEditData
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x48f71778):
            var tmp = new MessagesEditMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x83557dba):
            var tmp = new MessagesEditInlineBotMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9342ca07):
            var tmp = new MessagesGetBotCallbackAnswer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd58f130a):
            var tmp = new MessagesSetBotCallbackAnswer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe470bcfd):
            var tmp = new MessagesGetPeerDialogs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbc39e14b):
            var tmp = new MessagesSaveDraft
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6a3f8d65):
            var tmp = new MessagesGetAllDrafts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2dacca4f):
            var tmp = new MessagesGetFeaturedStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5b118126):
            var tmp = new MessagesReadFeaturedStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5ea192c9):
            var tmp = new MessagesGetRecentStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x392718f8):
            var tmp = new MessagesSaveRecentSticker
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8999602d):
            var tmp = new MessagesClearRecentStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x57f17692):
            var tmp = new MessagesGetArchivedStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x65b8c79f):
            var tmp = new MessagesGetMaskStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xcc5b67cc):
            var tmp = new MessagesGetAttachedStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8ef8ecc0):
            var tmp = new MessagesSetGameScore
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x15ad9f64):
            var tmp = new MessagesSetInlineGameScore
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe822649d):
            var tmp = new MessagesGetGameHighScores
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf635e1b):
            var tmp = new MessagesGetInlineGameHighScores
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd0a48c4):
            var tmp = new MessagesGetCommonChats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xeba80ff0):
            var tmp = new MessagesGetAllChats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x32ca8f91):
            var tmp = new MessagesGetWebPage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa731e257):
            var tmp = new MessagesToggleDialogPin
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3b1adf37):
            var tmp = new MessagesReorderPinnedDialogs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd6b94df2):
            var tmp = new MessagesGetPinnedDialogs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe5f672fa):
            var tmp = new MessagesSetBotShippingResults
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9c2dd95):
            var tmp = new MessagesSetBotPrecheckoutResults
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x519bc2b1):
            var tmp = new MessagesUploadMedia
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc97df020):
            var tmp = new MessagesSendScreenshotNotification
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x21ce0b0e):
            var tmp = new MessagesGetFavedStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb9ffc55b):
            var tmp = new MessagesFaveSticker
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x46578472):
            var tmp = new MessagesGetUnreadMentions
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf0189d3):
            var tmp = new MessagesReadMentions
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbbc45b09):
            var tmp = new MessagesGetRecentLocations
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xcc0110cb):
            var tmp = new MessagesSendMultiMedia
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5057c497):
            var tmp = new MessagesUploadEncryptedFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc2b7d08b):
            var tmp = new MessagesSearchStickerSets
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1cff7e08):
            var tmp = new MessagesGetSplitRanges
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc286d98f):
            var tmp = new MessagesMarkDialogUnread
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x22e24e22):
            var tmp = new MessagesGetDialogUnreadMarks
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7e58ee9c):
            var tmp = new MessagesClearAllDrafts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd2aaf7ec):
            var tmp = new MessagesUpdatePinnedMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x10ea6184):
            var tmp = new MessagesSendVote
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x73bb643b):
            var tmp = new MessagesGetPollResults
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6e2be050):
            var tmp = new MessagesGetOnlines
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x812c2ae6):
            var tmp = new MessagesGetStatsURL
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdef60797):
            var tmp = new MessagesEditChatAbout
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa5866b41):
            var tmp = new MessagesEditChatDefaultBannedRights
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x35a0e062):
            var tmp = new MessagesGetEmojiKeywords
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1508b6af):
            var tmp = new MessagesGetEmojiKeywordsDifference
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4e9963b2):
            var tmp = new MessagesGetEmojiKeywordsLanguages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd5b10c26):
            var tmp = new MessagesGetEmojiURL
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x732eef00):
            var tmp = new MessagesGetSearchCounters
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x198fb446):
            var tmp = new MessagesRequestUrlAuth
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb12c7125):
            var tmp = new MessagesAcceptUrlAuth
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4facb138):
            var tmp = new MessagesHidePeerSettingsBar
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe2c2685b):
            var tmp = new MessagesGetScheduledHistory
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbdbb0464):
            var tmp = new MessagesGetScheduledMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbd38850a):
            var tmp = new MessagesSendScheduledMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x59ae2b16):
            var tmp = new MessagesDeleteScheduledMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb86e380e):
            var tmp = new MessagesGetPollVotes
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb5052fea):
            var tmp = new MessagesToggleStickerSets
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf19ed96d):
            var tmp = new MessagesGetDialogFilters
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa29cd42c):
            var tmp = new MessagesGetSuggestedDialogFilters
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1ad4a04a):
            var tmp = new MessagesUpdateDialogFilter
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc563c1e4):
            var tmp = new MessagesUpdateDialogFiltersOrder
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5fe7025b):
            var tmp = new MessagesGetOldFeaturedStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x24b581ba):
            var tmp = new MessagesGetReplies
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x446972fd):
            var tmp = new MessagesGetDiscussionMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf731a9f4):
            var tmp = new MessagesReadDiscussion
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf025bc8b):
            var tmp = new MessagesUnpinAllMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x83247d11):
            var tmp = new MessagesDeleteChat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf9cbe409):
            var tmp = new MessagesDeletePhoneCallHistory
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x43fe19f3):
            var tmp = new MessagesCheckHistoryImport
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x34090c3b):
            var tmp = new MessagesInitHistoryImport
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2a862092):
            var tmp = new MessagesUploadImportedMedia
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb43df344):
            var tmp = new MessagesStartHistoryImport
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa2b5a3f6):
            var tmp = new MessagesGetExportedChatInvites
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x73746f5c):
            var tmp = new MessagesGetExportedChatInvite
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2e4ffbe):
            var tmp = new MessagesEditExportedChatInvite
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x56987bd5):
            var tmp = new MessagesDeleteRevokedExportedChatInvites
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd464a42b):
            var tmp = new MessagesDeleteExportedChatInvite
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3920e6ef):
            var tmp = new MessagesGetAdminsWithInvites
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x26fb7289):
            var tmp = new MessagesGetChatInviteImporters
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb80e5fe4):
            var tmp = new MessagesSetHistoryTTL
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5dc60f03):
            var tmp = new MessagesCheckHistoryImportPeer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xedd4882a):
            var tmp = new UpdatesGetState
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x25939651):
            var tmp = new UpdatesGetDifference
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3173d78):
            var tmp = new UpdatesGetChannelDifference
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x72d4742c):
            var tmp = new PhotosUpdateProfilePhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x89f30f69):
            var tmp = new PhotosUploadProfilePhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x87cf7f2f):
            var tmp = new PhotosDeletePhotos
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x91cd32a8):
            var tmp = new PhotosGetUserPhotos
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb304a621):
            var tmp = new UploadSaveFilePart
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb15a9afc):
            var tmp = new UploadGetFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xde7b673d):
            var tmp = new UploadSaveBigFilePart
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x24e6818d):
            var tmp = new UploadGetWebFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2000bcc3):
            var tmp = new UploadGetCdnFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9b2754a8):
            var tmp = new UploadReuploadCdnFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4da54231):
            var tmp = new UploadGetCdnFileHashes
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc7025931):
            var tmp = new UploadGetFileHashes
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc4f9186b):
            var tmp = new HelpGetConfig
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1fb33026):
            var tmp = new HelpGetNearestDc
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x522d5a7d):
            var tmp = new HelpGetAppUpdate
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4d392343):
            var tmp = new HelpGetInviteText
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9cdf08cd):
            var tmp = new HelpGetSupport
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9010ef6f):
            var tmp = new HelpGetAppChangelog
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xec22cfcd):
            var tmp = new HelpSetBotUpdatesStatus
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x52029342):
            var tmp = new HelpGetCdnConfig
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3dc0f114):
            var tmp = new HelpGetRecentMeUrls
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2ca51fd1):
            var tmp = new HelpGetTermsOfServiceUpdate
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xee72f79a):
            var tmp = new HelpAcceptTermsOfService
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3fedc75f):
            var tmp = new HelpGetDeepLinkInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x98914110):
            var tmp = new HelpGetAppConfig
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6f02f748):
            var tmp = new HelpSaveAppLog
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc661ad08):
            var tmp = new HelpGetPassportConfig
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd360e72c):
            var tmp = new HelpGetSupportName
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x38a08d3):
            var tmp = new HelpGetUserInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x66b91b70):
            var tmp = new HelpEditUserInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc0977421):
            var tmp = new HelpGetPromoData
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1e251c95):
            var tmp = new HelpHidePromoData
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf50dbaa1):
            var tmp = new HelpDismissSuggestion
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x735787a8):
            var tmp = new HelpGetCountriesList
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xcc104937):
            var tmp = new ChannelsReadHistory
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x84c1fd4e):
            var tmp = new ChannelsDeleteMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd10dd71b):
            var tmp = new ChannelsDeleteUserHistory
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfe087810):
            var tmp = new ChannelsReportSpam
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xad8c9a23):
            var tmp = new ChannelsGetMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x123e05e9):
            var tmp = new ChannelsGetParticipants
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa0ab6cc6):
            var tmp = new ChannelsGetParticipant
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa7f6bbb):
            var tmp = new ChannelsGetChannels
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8736a09):
            var tmp = new ChannelsGetFullChannel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3d5fb10f):
            var tmp = new ChannelsCreateChannel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd33c8902):
            var tmp = new ChannelsEditAdmin
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x566decd0):
            var tmp = new ChannelsEditTitle
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf12e57c9):
            var tmp = new ChannelsEditPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x10e6bd2c):
            var tmp = new ChannelsCheckUsername
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3514b3de):
            var tmp = new ChannelsUpdateUsername
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x24b524c5):
            var tmp = new ChannelsJoinChannel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf836aa95):
            var tmp = new ChannelsLeaveChannel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x199f3a6c):
            var tmp = new ChannelsInviteToChannel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc0111fe3):
            var tmp = new ChannelsDeleteChannel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe63fadeb):
            var tmp = new ChannelsExportMessageLink
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1f69b606):
            var tmp = new ChannelsToggleSignatures
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf8b036af):
            var tmp = new ChannelsGetAdminedPublicChannels
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x96e6cd81):
            var tmp = new ChannelsEditBanned
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x33ddf480):
            var tmp = new ChannelsGetAdminLog
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xea8ca4f9):
            var tmp = new ChannelsSetStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xeab5dc38):
            var tmp = new ChannelsReadMessageContents
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xaf369d42):
            var tmp = new ChannelsDeleteHistory
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xeabbb94c):
            var tmp = new ChannelsTogglePreHistoryHidden
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8341ecc0):
            var tmp = new ChannelsGetLeftChannels
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf5dad378):
            var tmp = new ChannelsGetGroupsForDiscussion
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x40582bb2):
            var tmp = new ChannelsSetDiscussionGroup
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8f38cd1f):
            var tmp = new ChannelsEditCreator
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x58e63f6d):
            var tmp = new ChannelsEditLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xedd49ef0):
            var tmp = new ChannelsToggleSlowMode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x11e831ee):
            var tmp = new ChannelsGetInactiveChannels
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb290c69):
            var tmp = new ChannelsConvertToGigagroup
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xaa2769ed):
            var tmp = new BotsSendCustomRequest
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe6213f4d):
            var tmp = new BotsAnswerWebhookJSONQuery
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x805d46f6):
            var tmp = new BotsSetBotCommands
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x99f09745):
            var tmp = new PaymentsGetPaymentForm
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa092a980):
            var tmp = new PaymentsGetPaymentReceipt
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x770a8e74):
            var tmp = new PaymentsValidateRequestedInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2b8879b3):
            var tmp = new PaymentsSendPaymentForm
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x227d824b):
            var tmp = new PaymentsGetSavedInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd83d70c1):
            var tmp = new PaymentsClearSavedInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2e79d779):
            var tmp = new PaymentsGetBankCardData
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf1036780):
            var tmp = new StickersCreateStickerSet
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf7760f51):
            var tmp = new StickersRemoveStickerFromSet
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xffb6d4ca):
            var tmp = new StickersChangeStickerPosition
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8653febe):
            var tmp = new StickersAddStickerToSet
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9a364e30):
            var tmp = new StickersSetStickerSetThumb
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x55451fa9):
            var tmp = new PhoneGetCallConfig
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x42ff96ed):
            var tmp = new PhoneRequestCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3bd2b4a0):
            var tmp = new PhoneAcceptCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2efe1722):
            var tmp = new PhoneConfirmCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x17d54f61):
            var tmp = new PhoneReceivedCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb2cbc1c0):
            var tmp = new PhoneDiscardCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x59ead627):
            var tmp = new PhoneSetCallRating
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x277add7e):
            var tmp = new PhoneSaveCallDebug
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xff7a9383):
            var tmp = new PhoneSendSignalingData
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbd3dabe0):
            var tmp = new PhoneCreateGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb132ff7b):
            var tmp = new PhoneJoinGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x500377f9):
            var tmp = new PhoneLeaveGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7b393160):
            var tmp = new PhoneInviteToGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7a777135):
            var tmp = new PhoneDiscardGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x74bbb43d):
            var tmp = new PhoneToggleGroupCallSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc7cb017):
            var tmp = new PhoneGetGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc558d8ab):
            var tmp = new PhoneGetGroupParticipants
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb74a7bea):
            var tmp = new PhoneCheckGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc02a66d7):
            var tmp = new PhoneToggleGroupCallRecord
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd975eb80):
            var tmp = new PhoneEditGroupCallParticipant
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1ca6ac0a):
            var tmp = new PhoneEditGroupCallTitle
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xef7c213a):
            var tmp = new PhoneGetGroupCallJoinAs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe6aa647f):
            var tmp = new PhoneExportGroupCallInvite
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf2f2330a):
            var tmp = new LangpackGetLangPack
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xefea3803):
            var tmp = new LangpackGetStrings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xcd984aa5):
            var tmp = new LangpackGetDifference
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x42c6978f):
            var tmp = new LangpackGetLanguages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6a596502):
            var tmp = new LangpackGetLanguage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6847d0ab):
            var tmp = new FoldersEditPeerFolders
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1c295881):
            var tmp = new FoldersDeleteFolder
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xab42441a):
            var tmp = new StatsGetBroadcastStats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x621d5fa0):
            var tmp = new StatsLoadAsyncGraph
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdcdf8607):
            var tmp = new StatsGetMegagroupStats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5630281b):
            var tmp = new StatsGetMessagePublicForwards
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb6e0a3f5):
            var tmp = new StatsGetMessageStats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7f3b18ea):
            var tmp = new InputPeerEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7da07ec9):
            var tmp = new InputPeerSelf
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x179be863):
            var tmp = new InputPeerChat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7b8e7de6):
            var tmp = new InputPeerUser
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x20adaef8):
            var tmp = new InputPeerChannel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x17bae2e6):
            var tmp = new InputPeerUserFromMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9c95f7bb):
            var tmp = new InputPeerChannelFromMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb98886cf):
            var tmp = new InputUserEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf7c1b13f):
            var tmp = new InputUserSelf
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd8292816):
            var tmp = new InputUser
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2d117597):
            var tmp = new InputUserFromMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf392b7f4):
            var tmp = new InputPhoneContact
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf52ff27f):
            var tmp = new InputFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfa4f0bb5):
            var tmp = new InputFileBig
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9664f57f):
            var tmp = new InputMediaEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1e287d04):
            var tmp = new InputMediaUploadedPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb3ba0635):
            var tmp = new InputMediaPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf9c44144):
            var tmp = new InputMediaGeoPoint
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf8ab7dfb):
            var tmp = new InputMediaContact
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5b38c6c1):
            var tmp = new InputMediaUploadedDocument
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x33473058):
            var tmp = new InputMediaDocument
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc13d1c11):
            var tmp = new InputMediaVenue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe5bbfe1a):
            var tmp = new InputMediaPhotoExternal
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfb52dc99):
            var tmp = new InputMediaDocumentExternal
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd33f43f3):
            var tmp = new InputMediaGame
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf4e096c3):
            var tmp = new InputMediaInvoice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x971fa843):
            var tmp = new InputMediaGeoLive
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf94e5f1):
            var tmp = new InputMediaPoll
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe66fbf7b):
            var tmp = new InputMediaDice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1ca48f57):
            var tmp = new InputChatPhotoEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc642724e):
            var tmp = new InputChatUploadedPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8953ad37):
            var tmp = new InputChatPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe4c123d6):
            var tmp = new InputGeoPointEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x48222faf):
            var tmp = new InputGeoPoint
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1cd7bf0d):
            var tmp = new InputPhotoEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3bb3b94a):
            var tmp = new InputPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdfdaabe1):
            var tmp = new InputFileLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf5235d55):
            var tmp = new InputEncryptedFileLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbad07584):
            var tmp = new InputDocumentFileLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xcbc7ee28):
            var tmp = new InputSecureFileLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x29be5899):
            var tmp = new InputTakeoutFileLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x40181ffe):
            var tmp = new InputPhotoFileLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd83466f3):
            var tmp = new InputPhotoLegacyFileLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x27d69997):
            var tmp = new InputPeerPhotoFileLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdbaeae9):
            var tmp = new InputStickerSetThumb
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbba51639):
            var tmp = new InputGroupCallStream
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9db1bc6d):
            var tmp = new PeerUser
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbad0e5bb):
            var tmp = new PeerChat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbddde532):
            var tmp = new PeerChannel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xaa963b05):
            var tmp = new StorageFileUnknown
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x40bc6f52):
            var tmp = new StorageFilePartial
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7efe0e):
            var tmp = new StorageFileJpeg
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xcae1aadf):
            var tmp = new StorageFileGif
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa4f63c0):
            var tmp = new StorageFilePng
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xae1e508d):
            var tmp = new StorageFilePdf
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x528a0677):
            var tmp = new StorageFileMp3
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4b09ebbc):
            var tmp = new StorageFileMov
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb3cea0e4):
            var tmp = new StorageFileMp4
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1081464c):
            var tmp = new StorageFileWebp
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x200250ba):
            var tmp = new UserEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x938458c1):
            var tmp = new User
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4f11bae1):
            var tmp = new UserProfilePhotoEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x69d3ab26):
            var tmp = new UserProfilePhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9d05049):
            var tmp = new UserStatusEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xedb93949):
            var tmp = new UserStatusOnline
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8c703f):
            var tmp = new UserStatusOffline
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe26f42f1):
            var tmp = new UserStatusRecently
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7bf09fc):
            var tmp = new UserStatusLastWeek
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x77ebc742):
            var tmp = new UserStatusLastMonth
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9ba2d800):
            var tmp = new ChatEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3bda1bde):
            var tmp = new Chat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7328bdb):
            var tmp = new ChatForbidden
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd31a961e):
            var tmp = new Channel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x289da732):
            var tmp = new ChannelForbidden
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8a1e2983):
            var tmp = new ChatFull
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x548c3f93):
            var tmp = new ChannelFull
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc8d7493e):
            var tmp = new ChatParticipant
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xda13538a):
            var tmp = new ChatParticipantCreator
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe2d6e436):
            var tmp = new ChatParticipantAdmin
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfc900c2b):
            var tmp = new ChatParticipantsForbidden
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3f460fed):
            var tmp = new ChatParticipants
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x37c1011c):
            var tmp = new ChatPhotoEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd20b9f3c):
            var tmp = new ChatPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x90a6ca84):
            var tmp = new MessageEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbce383d2):
            var tmp = new Message
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2b085862):
            var tmp = new MessageService
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3ded6320):
            var tmp = new MessageMediaEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x695150d7):
            var tmp = new MessageMediaPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x56e0d474):
            var tmp = new MessageMediaGeo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xcbf24940):
            var tmp = new MessageMediaContact
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9f84f49e):
            var tmp = new MessageMediaUnsupported
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9cb070d7):
            var tmp = new MessageMediaDocument
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa32dd600):
            var tmp = new MessageMediaWebPage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2ec0533f):
            var tmp = new MessageMediaVenue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfdb19008):
            var tmp = new MessageMediaGame
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x84551347):
            var tmp = new MessageMediaInvoice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb940c666):
            var tmp = new MessageMediaGeoLive
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4bd6e798):
            var tmp = new MessageMediaPoll
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3f7ee58b):
            var tmp = new MessageMediaDice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb6aef7b0):
            var tmp = new MessageActionEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa6638b9a):
            var tmp = new MessageActionChatCreate
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb5a1ce5a):
            var tmp = new MessageActionChatEditTitle
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7fcb13a8):
            var tmp = new MessageActionChatEditPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x95e3fbef):
            var tmp = new MessageActionChatDeletePhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x488a7337):
            var tmp = new MessageActionChatAddUser
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb2ae9b0c):
            var tmp = new MessageActionChatDeleteUser
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf89cf5e8):
            var tmp = new MessageActionChatJoinedByLink
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x95d2ac92):
            var tmp = new MessageActionChannelCreate
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x51bdb021):
            var tmp = new MessageActionChatMigrateTo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb055eaee):
            var tmp = new MessageActionChannelMigrateFrom
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x94bd38ed):
            var tmp = new MessageActionPinMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9fbab604):
            var tmp = new MessageActionHistoryClear
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x92a72876):
            var tmp = new MessageActionGameScore
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8f31b327):
            var tmp = new MessageActionPaymentSentMe
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x40699cd0):
            var tmp = new MessageActionPaymentSent
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x80e11a7f):
            var tmp = new MessageActionPhoneCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4792929b):
            var tmp = new MessageActionScreenshotTaken
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfae69f56):
            var tmp = new MessageActionCustomAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xabe9affe):
            var tmp = new MessageActionBotAllowed
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1b287353):
            var tmp = new MessageActionSecureValuesSentMe
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd95c6154):
            var tmp = new MessageActionSecureValuesSent
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf3f25f76):
            var tmp = new MessageActionContactSignUp
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x98e0d697):
            var tmp = new MessageActionGeoProximityReached
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7a0d7f42):
            var tmp = new MessageActionGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x76b9f11a):
            var tmp = new MessageActionInviteToGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xaa1afbfd):
            var tmp = new MessageActionSetMessagesTTL
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2c171f72):
            var tmp = new Dialog
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x71bd134c):
            var tmp = new DialogFolder
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2331b22d):
            var tmp = new PhotoEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfb197a65):
            var tmp = new Photo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe17e23c):
            var tmp = new PhotoSizeEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x77bfb61b):
            var tmp = new PhotoSize
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe9a734fa):
            var tmp = new PhotoCachedSize
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe0b0bc2e):
            var tmp = new PhotoStrippedSize
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5aa86a51):
            var tmp = new PhotoSizeProgressive
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd8214d41):
            var tmp = new PhotoPathSize
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1117dd5f):
            var tmp = new GeoPointEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb2a2f663):
            var tmp = new GeoPoint
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5e002502):
            var tmp = new AuthSentCode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xcd050916):
            var tmp = new AuthAuthorization
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x44747e9a):
            var tmp = new AuthAuthorizationSignUpRequired
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdf969c2d):
            var tmp = new AuthExportedAuthorization
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb8bc5b0c):
            var tmp = new InputNotifyPeer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x193b4417):
            var tmp = new InputNotifyUsers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4a95e84e):
            var tmp = new InputNotifyChats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb1db7c7e):
            var tmp = new InputNotifyBroadcasts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9c3d198e):
            var tmp = new InputPeerNotifySettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xaf509d20):
            var tmp = new PeerNotifySettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x733f2961):
            var tmp = new PeerSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa437c3ed):
            var tmp = new WallPaper
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8af40b25):
            var tmp = new WallPaperNoFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x58dbcab8):
            var tmp = new InputReportReasonSpam
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1e22c78d):
            var tmp = new InputReportReasonViolence
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2e59d922):
            var tmp = new InputReportReasonPornography
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xadf44ee3):
            var tmp = new InputReportReasonChildAbuse
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc1e4a2b1):
            var tmp = new InputReportReasonOther
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9b89f93a):
            var tmp = new InputReportReasonCopyright
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdbd4feed):
            var tmp = new InputReportReasonGeoIrrelevant
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf5ddd6e7):
            var tmp = new InputReportReasonFake
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x139a9a77):
            var tmp = new UserFull
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf911c994):
            var tmp = new Contact
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd0028438):
            var tmp = new ImportedContact
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd3680c61):
            var tmp = new ContactStatus
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb74ba9d2):
            var tmp = new ContactsContactsNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xeae87e42):
            var tmp = new ContactsContacts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x77d01c3b):
            var tmp = new ContactsImportedContacts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xade1591):
            var tmp = new ContactsBlocked
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe1664194):
            var tmp = new ContactsBlockedSlice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x15ba6c40):
            var tmp = new MessagesDialogs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x71e094f3):
            var tmp = new MessagesDialogsSlice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf0e3e596):
            var tmp = new MessagesDialogsNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8c718e87):
            var tmp = new MessagesMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3a54685e):
            var tmp = new MessagesMessagesSlice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x64479808):
            var tmp = new MessagesChannelMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x74535f21):
            var tmp = new MessagesMessagesNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x64ff9fd5):
            var tmp = new MessagesChats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9cd81144):
            var tmp = new MessagesChatsSlice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe5d7d19c):
            var tmp = new MessagesChatFull
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb45c69d1):
            var tmp = new MessagesAffectedHistory
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x57e2f66c):
            var tmp = new InputMessagesFilterEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9609a51c):
            var tmp = new InputMessagesFilterPhotos
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9fc00e65):
            var tmp = new InputMessagesFilterVideo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x56e9f0e4):
            var tmp = new InputMessagesFilterPhotoVideo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9eddf188):
            var tmp = new InputMessagesFilterDocument
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7ef0dd87):
            var tmp = new InputMessagesFilterUrl
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xffc86587):
            var tmp = new InputMessagesFilterGif
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x50f5c392):
            var tmp = new InputMessagesFilterVoice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3751b49e):
            var tmp = new InputMessagesFilterMusic
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3a20ecb8):
            var tmp = new InputMessagesFilterChatPhotos
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x80c99768):
            var tmp = new InputMessagesFilterPhoneCalls
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7a7c17a4):
            var tmp = new InputMessagesFilterRoundVoice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb549da53):
            var tmp = new InputMessagesFilterRoundVideo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc1f8e69a):
            var tmp = new InputMessagesFilterMyMentions
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe7026d0d):
            var tmp = new InputMessagesFilterGeo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe062db83):
            var tmp = new InputMessagesFilterContacts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1bb00451):
            var tmp = new InputMessagesFilterPinned
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1f2b0afd):
            var tmp = new UpdateNewMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4e90bfd6):
            var tmp = new UpdateMessageID
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa20db0e5):
            var tmp = new UpdateDeleteMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5c486927):
            var tmp = new UpdateUserTyping
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x86cadb6c):
            var tmp = new UpdateChatUserTyping
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7761198):
            var tmp = new UpdateChatParticipants
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1bfbd823):
            var tmp = new UpdateUserStatus
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa7332b73):
            var tmp = new UpdateUserName
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x95313b0c):
            var tmp = new UpdateUserPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x12bcbd9a):
            var tmp = new UpdateNewEncryptedMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1710f156):
            var tmp = new UpdateEncryptedChatTyping
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb4a2e88d):
            var tmp = new UpdateEncryption
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x38fe25b7):
            var tmp = new UpdateEncryptedMessagesRead
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xea4b0e5c):
            var tmp = new UpdateChatParticipantAdd
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6e5f8c22):
            var tmp = new UpdateChatParticipantDelete
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8e5e9873):
            var tmp = new UpdateDcOptions
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbec268ef):
            var tmp = new UpdateNotifySettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xebe46819):
            var tmp = new UpdateServiceNotification
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xee3b272a):
            var tmp = new UpdatePrivacy
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x12b9417b):
            var tmp = new UpdateUserPhone
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9c974fdf):
            var tmp = new UpdateReadHistoryInbox
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2f2f21bf):
            var tmp = new UpdateReadHistoryOutbox
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7f891213):
            var tmp = new UpdateWebPage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x68c13933):
            var tmp = new UpdateReadMessagesContents
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xeb0467fb):
            var tmp = new UpdateChannelTooLong
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb6d45656):
            var tmp = new UpdateChannel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x62ba04d9):
            var tmp = new UpdateNewChannelMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x330b5424):
            var tmp = new UpdateReadChannelInbox
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc37521c9):
            var tmp = new UpdateDeleteChannelMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x98a12b4b):
            var tmp = new UpdateChannelMessageViews
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb6901959):
            var tmp = new UpdateChatParticipantAdmin
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x688a30aa):
            var tmp = new UpdateNewStickerSet
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbb2d201):
            var tmp = new UpdateStickerSetsOrder
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x43ae3dec):
            var tmp = new UpdateStickerSets
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9375341e):
            var tmp = new UpdateSavedGifs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3f2038db):
            var tmp = new UpdateBotInlineQuery
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe48f964):
            var tmp = new UpdateBotInlineSend
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1b3f4df7):
            var tmp = new UpdateEditChannelMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe73547e1):
            var tmp = new UpdateBotCallbackQuery
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe40370a3):
            var tmp = new UpdateEditMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf9d27a5a):
            var tmp = new UpdateInlineBotCallbackQuery
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x25d6c9c7):
            var tmp = new UpdateReadChannelOutbox
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xee2bb969):
            var tmp = new UpdateDraftMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x571d2742):
            var tmp = new UpdateReadFeaturedStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9a422c20):
            var tmp = new UpdateRecentStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa229dd06):
            var tmp = new UpdateConfig
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3354678f):
            var tmp = new UpdatePtsChanged
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x40771900):
            var tmp = new UpdateChannelWebPage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6e6fe51c):
            var tmp = new UpdateDialogPinned
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfa0f3ca2):
            var tmp = new UpdatePinnedDialogs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8317c0c3):
            var tmp = new UpdateBotWebhookJSON
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9b9240a6):
            var tmp = new UpdateBotWebhookJSONQuery
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe0cdc940):
            var tmp = new UpdateBotShippingQuery
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5d2f3aa9):
            var tmp = new UpdateBotPrecheckoutQuery
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xab0f6b1e):
            var tmp = new UpdatePhoneCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x46560264):
            var tmp = new UpdateLangPackTooLong
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x56022f4d):
            var tmp = new UpdateLangPack
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe511996d):
            var tmp = new UpdateFavedStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x89893b45):
            var tmp = new UpdateChannelReadMessagesContents
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7084a7be):
            var tmp = new UpdateContactsReset
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x70db6837):
            var tmp = new UpdateChannelAvailableMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe16459c3):
            var tmp = new UpdateDialogUnreadMark
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xaca1657b):
            var tmp = new UpdateMessagePoll
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x54c01850):
            var tmp = new UpdateChatDefaultBannedRights
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x19360dc0):
            var tmp = new UpdateFolderPeers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6a7e7366):
            var tmp = new UpdatePeerSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb4afcfb0):
            var tmp = new UpdatePeerLocated
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x39a51dfb):
            var tmp = new UpdateNewScheduledMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x90866cee):
            var tmp = new UpdateDeleteScheduledMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8216fba3):
            var tmp = new UpdateTheme
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x871fb939):
            var tmp = new UpdateGeoLiveViewed
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x564fe691):
            var tmp = new UpdateLoginToken
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x42f88f2c):
            var tmp = new UpdateMessagePollVote
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x26ffde7d):
            var tmp = new UpdateDialogFilter
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa5d72105):
            var tmp = new UpdateDialogFilterOrder
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3504914f):
            var tmp = new UpdateDialogFilters
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2661bf09):
            var tmp = new UpdatePhoneCallSignalingData
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6e8a84df):
            var tmp = new UpdateChannelMessageForwards
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1cc7de54):
            var tmp = new UpdateReadChannelDiscussionInbox
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4638a26c):
            var tmp = new UpdateReadChannelDiscussionOutbox
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x246a4b22):
            var tmp = new UpdatePeerBlocked
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6b171718):
            var tmp = new UpdateChannelUserTyping
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xed85eab5):
            var tmp = new UpdatePinnedMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8588878b):
            var tmp = new UpdatePinnedChannelMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1330a196):
            var tmp = new UpdateChat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf2ebdb4e):
            var tmp = new UpdateGroupCallParticipants
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa45eb99b):
            var tmp = new UpdateGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbb9bb9a5):
            var tmp = new UpdatePeerHistoryTTL
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf3b3781f):
            var tmp = new UpdateChatParticipant
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7fecb1ec):
            var tmp = new UpdateChannelParticipant
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7f9488a):
            var tmp = new UpdateBotStopped
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa56c2a3e):
            var tmp = new UpdatesState
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5d75a138):
            var tmp = new UpdatesDifferenceEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf49ca0):
            var tmp = new UpdatesDifference
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa8fb1981):
            var tmp = new UpdatesDifferenceSlice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4afe8f6d):
            var tmp = new UpdatesDifferenceTooLong
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe317af7e):
            var tmp = new UpdatesTooLong
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfaeff833):
            var tmp = new UpdateShortMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1157b858):
            var tmp = new UpdateShortChatMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x78d4dec1):
            var tmp = new UpdateShort
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x725b04c3):
            var tmp = new UpdatesCombined
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x74ae4240):
            var tmp = new Updates
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9015e101):
            var tmp = new UpdateShortSentMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8dca6aa5):
            var tmp = new PhotosPhotos
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x15051f54):
            var tmp = new PhotosPhotosSlice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x20212ca8):
            var tmp = new PhotosPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x96a18d5):
            var tmp = new UploadFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf18cda44):
            var tmp = new UploadFileCdnRedirect
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x18b7a10d):
            var tmp = new DcOption
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x330b4067):
            var tmp = new Config
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8e1a1775):
            var tmp = new NearestDc
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1da7158f):
            var tmp = new HelpAppUpdate
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc45a6536):
            var tmp = new HelpNoAppUpdate
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x18cb9f78):
            var tmp = new HelpInviteText
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xab7ec0a0):
            var tmp = new EncryptedChatEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3bf703dc):
            var tmp = new EncryptedChatWaiting
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x62718a82):
            var tmp = new EncryptedChatRequested
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfa56ce36):
            var tmp = new EncryptedChat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1e1c7c45):
            var tmp = new EncryptedChatDiscarded
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf141b5e1):
            var tmp = new InputEncryptedChat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc21f497e):
            var tmp = new EncryptedFileEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4a70994c):
            var tmp = new EncryptedFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1837c364):
            var tmp = new InputEncryptedFileEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x64bd0306):
            var tmp = new InputEncryptedFileUploaded
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5a17b5e5):
            var tmp = new InputEncryptedFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2dc173c8):
            var tmp = new InputEncryptedFileBigUploaded
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xed18c118):
            var tmp = new EncryptedMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x23734b06):
            var tmp = new EncryptedMessageService
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc0e24635):
            var tmp = new MessagesDhConfigNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2c221edd):
            var tmp = new MessagesDhConfig
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x560f8935):
            var tmp = new MessagesSentEncryptedMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9493ff32):
            var tmp = new MessagesSentEncryptedFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x72f0eaae):
            var tmp = new InputDocumentEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1abfb575):
            var tmp = new InputDocument
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x36f8c871):
            var tmp = new DocumentEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1e87342b):
            var tmp = new Document
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x17c6b5f6):
            var tmp = new HelpSupport
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9fd40bd8):
            var tmp = new NotifyPeer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb4c83b4c):
            var tmp = new NotifyUsers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc007cec3):
            var tmp = new NotifyChats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd612e8ef):
            var tmp = new NotifyBroadcasts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x16bf744e):
            var tmp = new SendMessageTypingAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfd5ec8f5):
            var tmp = new SendMessageCancelAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa187d66f):
            var tmp = new SendMessageRecordVideoAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe9763aec):
            var tmp = new SendMessageUploadVideoAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd52f73f7):
            var tmp = new SendMessageRecordAudioAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf351d7ab):
            var tmp = new SendMessageUploadAudioAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd1d34a26):
            var tmp = new SendMessageUploadPhotoAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xaa0cd9e4):
            var tmp = new SendMessageUploadDocumentAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x176f8ba1):
            var tmp = new SendMessageGeoLocationAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x628cbc6f):
            var tmp = new SendMessageChooseContactAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdd6a8f48):
            var tmp = new SendMessageGamePlayAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x88f27fbc):
            var tmp = new SendMessageRecordRoundAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x243e1c66):
            var tmp = new SendMessageUploadRoundAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd92c2285):
            var tmp = new SpeakingInGroupCallAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdbda9246):
            var tmp = new SendMessageHistoryImportAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb3134d9d):
            var tmp = new ContactsFound
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4f96cb18):
            var tmp = new InputPrivacyKeyStatusTimestamp
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbdfb0426):
            var tmp = new InputPrivacyKeyChatInvite
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfabadc5f):
            var tmp = new InputPrivacyKeyPhoneCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdb9e70d2):
            var tmp = new InputPrivacyKeyPhoneP2P
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa4dd4c08):
            var tmp = new InputPrivacyKeyForwards
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5719bacc):
            var tmp = new InputPrivacyKeyProfilePhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x352dafa):
            var tmp = new InputPrivacyKeyPhoneNumber
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd1219bdd):
            var tmp = new InputPrivacyKeyAddedByPhone
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbc2eab30):
            var tmp = new PrivacyKeyStatusTimestamp
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x500e6dfa):
            var tmp = new PrivacyKeyChatInvite
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3d662b7b):
            var tmp = new PrivacyKeyPhoneCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x39491cc8):
            var tmp = new PrivacyKeyPhoneP2P
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x69ec56a3):
            var tmp = new PrivacyKeyForwards
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x96151fed):
            var tmp = new PrivacyKeyProfilePhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd19ae46d):
            var tmp = new PrivacyKeyPhoneNumber
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x42ffd42b):
            var tmp = new PrivacyKeyAddedByPhone
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd09e07b):
            var tmp = new InputPrivacyValueAllowContacts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x184b35ce):
            var tmp = new InputPrivacyValueAllowAll
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x131cc67f):
            var tmp = new InputPrivacyValueAllowUsers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xba52007):
            var tmp = new InputPrivacyValueDisallowContacts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd66b66c9):
            var tmp = new InputPrivacyValueDisallowAll
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x90110467):
            var tmp = new InputPrivacyValueDisallowUsers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4c81c1ba):
            var tmp = new InputPrivacyValueAllowChatParticipants
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd82363af):
            var tmp = new InputPrivacyValueDisallowChatParticipants
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfffe1bac):
            var tmp = new PrivacyValueAllowContacts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x65427b82):
            var tmp = new PrivacyValueAllowAll
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4d5bbe0c):
            var tmp = new PrivacyValueAllowUsers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf888fa1a):
            var tmp = new PrivacyValueDisallowContacts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8b73e763):
            var tmp = new PrivacyValueDisallowAll
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc7f49b7):
            var tmp = new PrivacyValueDisallowUsers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x18be796b):
            var tmp = new PrivacyValueAllowChatParticipants
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xacae0690):
            var tmp = new PrivacyValueDisallowChatParticipants
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x50a04e45):
            var tmp = new AccountPrivacyRules
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb8d0afdf):
            var tmp = new AccountDaysTTL
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6c37c15c):
            var tmp = new DocumentAttributeImageSize
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x11b58939):
            var tmp = new DocumentAttributeAnimated
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6319d612):
            var tmp = new DocumentAttributeSticker
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xef02ce6):
            var tmp = new DocumentAttributeVideo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9852f9c6):
            var tmp = new DocumentAttributeAudio
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x15590068):
            var tmp = new DocumentAttributeFilename
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9801d2f7):
            var tmp = new DocumentAttributeHasStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf1749a22):
            var tmp = new MessagesStickersNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe4599bbd):
            var tmp = new MessagesStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x12b299d4):
            var tmp = new StickerPack
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe86602c3):
            var tmp = new MessagesAllStickersNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xedfd405f):
            var tmp = new MessagesAllStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x84d19185):
            var tmp = new MessagesAffectedMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xeb1477e8):
            var tmp = new WebPageEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc586da1c):
            var tmp = new WebPagePending
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe89c45b2):
            var tmp = new WebPage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7311ca11):
            var tmp = new WebPageNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xad01d61d):
            var tmp = new Authorization
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1250abde):
            var tmp = new AccountAuthorizations
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xad2641f8):
            var tmp = new AccountPassword
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9a5c33e5):
            var tmp = new AccountPasswordSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc23727c9):
            var tmp = new AccountPasswordInputSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x137948a5):
            var tmp = new AuthPasswordRecovery
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa384b779):
            var tmp = new ReceivedNotifyMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6e24fc9d):
            var tmp = new ChatInviteExported
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5a686d7c):
            var tmp = new ChatInviteAlready
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdfc2f58e):
            var tmp = new ChatInvite
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x61695cb0):
            var tmp = new ChatInvitePeek
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xffb62b95):
            var tmp = new InputStickerSetEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9de7a269):
            var tmp = new InputStickerSetID
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x861cc8a0):
            var tmp = new InputStickerSetShortName
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x28703c8):
            var tmp = new InputStickerSetAnimatedEmoji
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe67f520e):
            var tmp = new InputStickerSetDice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x40e237a8):
            var tmp = new StickerSet
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb60a24a6):
            var tmp = new MessagesStickerSet
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc27ac8c7):
            var tmp = new BotCommand
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x98e81d3a):
            var tmp = new BotInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa2fa4880):
            var tmp = new KeyboardButton
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x258aff05):
            var tmp = new KeyboardButtonUrl
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x35bbdb6b):
            var tmp = new KeyboardButtonCallback
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb16a6c29):
            var tmp = new KeyboardButtonRequestPhone
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfc796b3f):
            var tmp = new KeyboardButtonRequestGeoLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x568a748):
            var tmp = new KeyboardButtonSwitchInline
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x50f41ccf):
            var tmp = new KeyboardButtonGame
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xafd93fbb):
            var tmp = new KeyboardButtonBuy
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x10b78d29):
            var tmp = new KeyboardButtonUrlAuth
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd02e7fd4):
            var tmp = new InputKeyboardButtonUrlAuth
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbbc7515d):
            var tmp = new KeyboardButtonRequestPoll
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x77608b83):
            var tmp = new KeyboardButtonRow
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa03e5b85):
            var tmp = new ReplyKeyboardHide
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf4108aa0):
            var tmp = new ReplyKeyboardForceReply
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3502758c):
            var tmp = new ReplyKeyboardMarkup
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x48a30254):
            var tmp = new ReplyInlineMarkup
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbb92ba95):
            var tmp = new MessageEntityUnknown
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfa04579d):
            var tmp = new MessageEntityMention
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6f635b0d):
            var tmp = new MessageEntityHashtag
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6cef8ac7):
            var tmp = new MessageEntityBotCommand
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6ed02538):
            var tmp = new MessageEntityUrl
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x64e475c2):
            var tmp = new MessageEntityEmail
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbd610bc9):
            var tmp = new MessageEntityBold
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x826f8b60):
            var tmp = new MessageEntityItalic
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x28a20571):
            var tmp = new MessageEntityCode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x73924be0):
            var tmp = new MessageEntityPre
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x76a6d327):
            var tmp = new MessageEntityTextUrl
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x352dca58):
            var tmp = new MessageEntityMentionName
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x208e68c9):
            var tmp = new InputMessageEntityMentionName
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9b69e34b):
            var tmp = new MessageEntityPhone
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4c4e743f):
            var tmp = new MessageEntityCashtag
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9c4e7e8b):
            var tmp = new MessageEntityUnderline
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbf0693d4):
            var tmp = new MessageEntityStrike
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x20df5d0):
            var tmp = new MessageEntityBlockquote
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x761e6af4):
            var tmp = new MessageEntityBankCard
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xee8c1e86):
            var tmp = new InputChannelEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xafeb712e):
            var tmp = new InputChannel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2a286531):
            var tmp = new InputChannelFromMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7f077ad9):
            var tmp = new ContactsResolvedPeer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xae30253):
            var tmp = new MessageRange
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3e11affb):
            var tmp = new UpdatesChannelDifferenceEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa4bcc6fe):
            var tmp = new UpdatesChannelDifferenceTooLong
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2064674e):
            var tmp = new UpdatesChannelDifference
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x94d42ee7):
            var tmp = new ChannelMessagesFilterEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xcd77d957):
            var tmp = new ChannelMessagesFilter
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x15ebac1d):
            var tmp = new ChannelParticipant
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa3289a6d):
            var tmp = new ChannelParticipantSelf
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x447dca4b):
            var tmp = new ChannelParticipantCreator
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xccbebbaf):
            var tmp = new ChannelParticipantAdmin
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x50a1dfd6):
            var tmp = new ChannelParticipantBanned
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1b03f006):
            var tmp = new ChannelParticipantLeft
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xde3f3c79):
            var tmp = new ChannelParticipantsRecent
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb4608969):
            var tmp = new ChannelParticipantsAdmins
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa3b54985):
            var tmp = new ChannelParticipantsKicked
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb0d1865b):
            var tmp = new ChannelParticipantsBots
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1427a5e1):
            var tmp = new ChannelParticipantsBanned
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x656ac4b):
            var tmp = new ChannelParticipantsSearch
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbb6ae88d):
            var tmp = new ChannelParticipantsContacts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe04b5ceb):
            var tmp = new ChannelParticipantsMentions
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9ab0feaf):
            var tmp = new ChannelsChannelParticipants
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf0173fe9):
            var tmp = new ChannelsChannelParticipantsNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdfb80317):
            var tmp = new ChannelsChannelParticipant
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x780a0310):
            var tmp = new HelpTermsOfService
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe8025ca2):
            var tmp = new MessagesSavedGifsNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2e0709a5):
            var tmp = new MessagesSavedGifs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3380c786):
            var tmp = new InputBotInlineMessageMediaAuto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3dcd7a87):
            var tmp = new InputBotInlineMessageText
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x96929a85):
            var tmp = new InputBotInlineMessageMediaGeo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x417bbf11):
            var tmp = new InputBotInlineMessageMediaVenue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa6edbffd):
            var tmp = new InputBotInlineMessageMediaContact
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4b425864):
            var tmp = new InputBotInlineMessageGame
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x88bf9319):
            var tmp = new InputBotInlineResult
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa8d864a7):
            var tmp = new InputBotInlineResultPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfff8fdc4):
            var tmp = new InputBotInlineResultDocument
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4fa417f2):
            var tmp = new InputBotInlineResultGame
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x764cf810):
            var tmp = new BotInlineMessageMediaAuto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8c7f65e2):
            var tmp = new BotInlineMessageText
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x51846fd):
            var tmp = new BotInlineMessageMediaGeo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8a86659c):
            var tmp = new BotInlineMessageMediaVenue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x18d1cdc2):
            var tmp = new BotInlineMessageMediaContact
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x11965f3a):
            var tmp = new BotInlineResult
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x17db940b):
            var tmp = new BotInlineMediaResult
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x947ca848):
            var tmp = new MessagesBotResults
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5dab1af4):
            var tmp = new ExportedMessageLink
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5f777dce):
            var tmp = new MessageFwdHeader
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x72a3158c):
            var tmp = new AuthCodeTypeSms
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x741cd3e3):
            var tmp = new AuthCodeTypeCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x226ccefb):
            var tmp = new AuthCodeTypeFlashCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3dbb5986):
            var tmp = new AuthSentCodeTypeApp
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc000bba2):
            var tmp = new AuthSentCodeTypeSms
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5353e5a7):
            var tmp = new AuthSentCodeTypeCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xab03c6d9):
            var tmp = new AuthSentCodeTypeFlashCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x36585ea4):
            var tmp = new MessagesBotCallbackAnswer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x26b5dde6):
            var tmp = new MessagesMessageEditData
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x890c3d89):
            var tmp = new InputBotInlineMessageID
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3c20629f):
            var tmp = new InlineBotSwitchPM
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3371c354):
            var tmp = new MessagesPeerDialogs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xedcdc05b):
            var tmp = new TopPeer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xab661b5b):
            var tmp = new TopPeerCategoryBotsPM
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x148677e2):
            var tmp = new TopPeerCategoryBotsInline
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x637b7ed):
            var tmp = new TopPeerCategoryCorrespondents
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbd17a14a):
            var tmp = new TopPeerCategoryGroups
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x161d9628):
            var tmp = new TopPeerCategoryChannels
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1e76a78c):
            var tmp = new TopPeerCategoryPhoneCalls
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa8406ca9):
            var tmp = new TopPeerCategoryForwardUsers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfbeec0f0):
            var tmp = new TopPeerCategoryForwardChats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfb834291):
            var tmp = new TopPeerCategoryPeers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xde266ef5):
            var tmp = new ContactsTopPeersNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x70b772a8):
            var tmp = new ContactsTopPeers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb52c939d):
            var tmp = new ContactsTopPeersDisabled
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1b0c841a):
            var tmp = new DraftMessageEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfd8e711f):
            var tmp = new DraftMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc6dc0c66):
            var tmp = new MessagesFeaturedStickersNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb6abc341):
            var tmp = new MessagesFeaturedStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb17f890):
            var tmp = new MessagesRecentStickersNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x22f3afb3):
            var tmp = new MessagesRecentStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4fcba9c8):
            var tmp = new MessagesArchivedStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x38641628):
            var tmp = new MessagesStickerSetInstallResultSuccess
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x35e410a8):
            var tmp = new MessagesStickerSetInstallResultArchive
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6410a5d2):
            var tmp = new StickerSetCovered
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3407e51b):
            var tmp = new StickerSetMultiCovered
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xaed6dbb2):
            var tmp = new MaskCoords
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4a992157):
            var tmp = new InputStickeredMediaPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x438865b):
            var tmp = new InputStickeredMediaDocument
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbdf9653b):
            var tmp = new Game
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x32c3e77):
            var tmp = new InputGameID
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc331e80a):
            var tmp = new InputGameShortName
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x58fffcd0):
            var tmp = new HighScore
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9a3bfd99):
            var tmp = new MessagesHighScores
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdc3d824f):
            var tmp = new TextEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x744694e0):
            var tmp = new TextPlain
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6724abc4):
            var tmp = new TextBold
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd912a59c):
            var tmp = new TextItalic
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc12622c4):
            var tmp = new TextUnderline
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9bf8bb95):
            var tmp = new TextStrike
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6c3f19b9):
            var tmp = new TextFixed
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3c2884c1):
            var tmp = new TextUrl
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xde5a0dd6):
            var tmp = new TextEmail
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7e6260d7):
            var tmp = new TextConcat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xed6a8504):
            var tmp = new TextSubscript
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc7fb5e01):
            var tmp = new TextSuperscript
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x34b8621):
            var tmp = new TextMarked
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1ccb966a):
            var tmp = new TextPhone
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x81ccf4f):
            var tmp = new TextImage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x35553762):
            var tmp = new TextAnchor
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x13567e8a):
            var tmp = new PageBlockUnsupported
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x70abc3fd):
            var tmp = new PageBlockTitle
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8ffa9a1f):
            var tmp = new PageBlockSubtitle
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbaafe5e0):
            var tmp = new PageBlockAuthorDate
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbfd064ec):
            var tmp = new PageBlockHeader
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf12bb6e1):
            var tmp = new PageBlockSubheader
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x467a0766):
            var tmp = new PageBlockParagraph
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc070d93e):
            var tmp = new PageBlockPreformatted
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x48870999):
            var tmp = new PageBlockFooter
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdb20b188):
            var tmp = new PageBlockDivider
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xce0d37b0):
            var tmp = new PageBlockAnchor
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe4e88011):
            var tmp = new PageBlockList
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x263d7c26):
            var tmp = new PageBlockBlockquote
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4f4456d3):
            var tmp = new PageBlockPullquote
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1759c560):
            var tmp = new PageBlockPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7c8fe7b6):
            var tmp = new PageBlockVideo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x39f23300):
            var tmp = new PageBlockCover
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa8718dc5):
            var tmp = new PageBlockEmbed
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf259a80b):
            var tmp = new PageBlockEmbedPost
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x65a0fa4d):
            var tmp = new PageBlockCollage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x31f9590):
            var tmp = new PageBlockSlideshow
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xef1751b5):
            var tmp = new PageBlockChannel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x804361ea):
            var tmp = new PageBlockAudio
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1e148390):
            var tmp = new PageBlockKicker
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbf4dea82):
            var tmp = new PageBlockTable
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9a8ae1e1):
            var tmp = new PageBlockOrderedList
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x76768bed):
            var tmp = new PageBlockDetails
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x16115a96):
            var tmp = new PageBlockRelatedArticles
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa44f3ef6):
            var tmp = new PageBlockMap
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x85e42301):
            var tmp = new PhoneCallDiscardReasonMissed
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe095c1a0):
            var tmp = new PhoneCallDiscardReasonDisconnect
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x57adc690):
            var tmp = new PhoneCallDiscardReasonHangup
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfaf7e8c9):
            var tmp = new PhoneCallDiscardReasonBusy
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7d748d04):
            var tmp = new DataJSON
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xcb296bf8):
            var tmp = new LabeledPrice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc30aa358):
            var tmp = new Invoice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xea02c27e):
            var tmp = new PaymentCharge
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1e8caaeb):
            var tmp = new PostAddress
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x909c3f94):
            var tmp = new PaymentRequestedInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xcdc27a1f):
            var tmp = new PaymentSavedCredentialsCard
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1c570ed1):
            var tmp = new WebDocument
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf9c8bcc6):
            var tmp = new WebDocumentNoProxy
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9bed434d):
            var tmp = new InputWebDocument
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc239d686):
            var tmp = new InputWebFileLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9f2221c9):
            var tmp = new InputWebFileGeoPointLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x21e753bc):
            var tmp = new UploadWebFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3f56aea3):
            var tmp = new PaymentsPaymentForm
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd1451883):
            var tmp = new PaymentsValidatedRequestedInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4e5f810d):
            var tmp = new PaymentsPaymentResult
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd8411139):
            var tmp = new PaymentsPaymentVerificationNeeded
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x500911e1):
            var tmp = new PaymentsPaymentReceipt
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfb8fe43c):
            var tmp = new PaymentsSavedInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc10eb2cf):
            var tmp = new InputPaymentCredentialsSaved
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3417d728):
            var tmp = new InputPaymentCredentials
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xaa1c39f):
            var tmp = new InputPaymentCredentialsApplePay
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8ac32801):
            var tmp = new InputPaymentCredentialsGooglePay
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdb64fd34):
            var tmp = new AccountTmpPassword
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb6213cdf):
            var tmp = new ShippingOption
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xffa0a496):
            var tmp = new InputStickerSetItem
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1e36fded):
            var tmp = new InputPhoneCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5366c915):
            var tmp = new PhoneCallEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1b8f4ad1):
            var tmp = new PhoneCallWaiting
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x87eabb53):
            var tmp = new PhoneCallRequested
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x997c454a):
            var tmp = new PhoneCallAccepted
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8742ae7f):
            var tmp = new PhoneCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x50ca4de1):
            var tmp = new PhoneCallDiscarded
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9d4c17c0):
            var tmp = new PhoneConnection
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x635fe375):
            var tmp = new PhoneConnectionWebrtc
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfc878fc8):
            var tmp = new PhoneCallProtocol
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xec82e140):
            var tmp = new PhonePhoneCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xeea8e46e):
            var tmp = new UploadCdnFileReuploadNeeded
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa99fca4f):
            var tmp = new UploadCdnFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc982eaba):
            var tmp = new CdnPublicKey
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5725e40a):
            var tmp = new CdnConfig
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xcad181f6):
            var tmp = new LangPackString
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6c47ac9f):
            var tmp = new LangPackStringPluralized
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2979eeb2):
            var tmp = new LangPackStringDeleted
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf385c1f6):
            var tmp = new LangPackDifference
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xeeca5ce3):
            var tmp = new LangPackLanguage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe6dfb825):
            var tmp = new ChannelAdminLogEventActionChangeTitle
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x55188a2e):
            var tmp = new ChannelAdminLogEventActionChangeAbout
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6a4afc38):
            var tmp = new ChannelAdminLogEventActionChangeUsername
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x434bd2af):
            var tmp = new ChannelAdminLogEventActionChangePhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1b7907ae):
            var tmp = new ChannelAdminLogEventActionToggleInvites
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x26ae0971):
            var tmp = new ChannelAdminLogEventActionToggleSignatures
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe9e82c18):
            var tmp = new ChannelAdminLogEventActionUpdatePinned
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x709b2405):
            var tmp = new ChannelAdminLogEventActionEditMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x42e047bb):
            var tmp = new ChannelAdminLogEventActionDeleteMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x183040d3):
            var tmp = new ChannelAdminLogEventActionParticipantJoin
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf89777f2):
            var tmp = new ChannelAdminLogEventActionParticipantLeave
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe31c34d8):
            var tmp = new ChannelAdminLogEventActionParticipantInvite
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe6d83d7e):
            var tmp = new ChannelAdminLogEventActionParticipantToggleBan
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd5676710):
            var tmp = new ChannelAdminLogEventActionParticipantToggleAdmin
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb1c3caa7):
            var tmp = new ChannelAdminLogEventActionChangeStickerSet
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5f5c95f1):
            var tmp = new ChannelAdminLogEventActionTogglePreHistoryHidden
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2df5fc0a):
            var tmp = new ChannelAdminLogEventActionDefaultBannedRights
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8f079643):
            var tmp = new ChannelAdminLogEventActionStopPoll
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa26f881b):
            var tmp = new ChannelAdminLogEventActionChangeLinkedChat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe6b76ae):
            var tmp = new ChannelAdminLogEventActionChangeLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x53909779):
            var tmp = new ChannelAdminLogEventActionToggleSlowMode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x23209745):
            var tmp = new ChannelAdminLogEventActionStartGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdb9f9140):
            var tmp = new ChannelAdminLogEventActionDiscardGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf92424d2):
            var tmp = new ChannelAdminLogEventActionParticipantMute
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe64429c0):
            var tmp = new ChannelAdminLogEventActionParticipantUnmute
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x56d6a247):
            var tmp = new ChannelAdminLogEventActionToggleGroupCallSetting
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5cdada77):
            var tmp = new ChannelAdminLogEventActionParticipantJoinByInvite
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5a50fca4):
            var tmp = new ChannelAdminLogEventActionExportedInviteDelete
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x410a134e):
            var tmp = new ChannelAdminLogEventActionExportedInviteRevoke
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe90ebb59):
            var tmp = new ChannelAdminLogEventActionExportedInviteEdit
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3e7f6847):
            var tmp = new ChannelAdminLogEventActionParticipantVolume
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6e941a38):
            var tmp = new ChannelAdminLogEventActionChangeHistoryTTL
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3b5a3e40):
            var tmp = new ChannelAdminLogEvent
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xed8af74d):
            var tmp = new ChannelsAdminLogResults
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xea107ae4):
            var tmp = new ChannelAdminLogEventsFilter
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5ce14175):
            var tmp = new PopularContact
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9e8fa6d3):
            var tmp = new MessagesFavedStickersNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf37f2f16):
            var tmp = new MessagesFavedStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x46e1d13d):
            var tmp = new RecentMeUrlUnknown
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8dbc3336):
            var tmp = new RecentMeUrlUser
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa01b22f9):
            var tmp = new RecentMeUrlChat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xeb49081d):
            var tmp = new RecentMeUrlChatInvite
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbc0a57dc):
            var tmp = new RecentMeUrlStickerSet
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe0310d7):
            var tmp = new HelpRecentMeUrls
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1cc6e91f):
            var tmp = new InputSingleMedia
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xcac943f2):
            var tmp = new WebAuthorization
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xed56c9fc):
            var tmp = new AccountWebAuthorizations
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa676a322):
            var tmp = new InputMessageID
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbad88395):
            var tmp = new InputMessageReplyTo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x86872538):
            var tmp = new InputMessagePinned
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xacfa1a7e):
            var tmp = new InputMessageCallbackQuery
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfcaafeb7):
            var tmp = new InputDialogPeer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x64600527):
            var tmp = new InputDialogPeerFolder
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe56dbf05):
            var tmp = new DialogPeer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x514519e2):
            var tmp = new DialogPeerFolder
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd54b65d):
            var tmp = new MessagesFoundStickerSetsNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5108d648):
            var tmp = new MessagesFoundStickerSets
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6242c773):
            var tmp = new FileHash
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x75588b3f):
            var tmp = new InputClientProxy
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe3309f7f):
            var tmp = new HelpTermsOfServiceUpdateEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x28ecf961):
            var tmp = new HelpTermsOfServiceUpdate
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3334b0f0):
            var tmp = new InputSecureFileUploaded
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5367e5be):
            var tmp = new InputSecureFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x64199744):
            var tmp = new SecureFileEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe0277a62):
            var tmp = new SecureFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8aeabec3):
            var tmp = new SecureData
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7d6099dd):
            var tmp = new SecurePlainPhone
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x21ec5a5f):
            var tmp = new SecurePlainEmail
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9d2a81e3):
            var tmp = new SecureValueTypePersonalDetails
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3dac6a00):
            var tmp = new SecureValueTypePassport
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6e425c4):
            var tmp = new SecureValueTypeDriverLicense
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa0d0744b):
            var tmp = new SecureValueTypeIdentityCard
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x99a48f23):
            var tmp = new SecureValueTypeInternalPassport
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xcbe31e26):
            var tmp = new SecureValueTypeAddress
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfc36954e):
            var tmp = new SecureValueTypeUtilityBill
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x89137c0d):
            var tmp = new SecureValueTypeBankStatement
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8b883488):
            var tmp = new SecureValueTypeRentalAgreement
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x99e3806a):
            var tmp = new SecureValueTypePassportRegistration
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xea02ec33):
            var tmp = new SecureValueTypeTemporaryRegistration
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb320aadb):
            var tmp = new SecureValueTypePhone
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8e3ca7ee):
            var tmp = new SecureValueTypeEmail
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x187fa0ca):
            var tmp = new SecureValue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdb21d0a7):
            var tmp = new InputSecureValue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xed1ecdb0):
            var tmp = new SecureValueHash
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe8a40bd9):
            var tmp = new SecureValueErrorData
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbe3dfa):
            var tmp = new SecureValueErrorFrontSide
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x868a2aa5):
            var tmp = new SecureValueErrorReverseSide
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe537ced6):
            var tmp = new SecureValueErrorSelfie
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7a700873):
            var tmp = new SecureValueErrorFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x666220e9):
            var tmp = new SecureValueErrorFiles
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x869d758f):
            var tmp = new SecureValueError
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa1144770):
            var tmp = new SecureValueErrorTranslationFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x34636dd8):
            var tmp = new SecureValueErrorTranslationFiles
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x33f0ea47):
            var tmp = new SecureCredentialsEncrypted
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xad2e1cd8):
            var tmp = new AccountAuthorizationForm
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x811f854f):
            var tmp = new AccountSentEmailCode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x66afa166):
            var tmp = new HelpDeepLinkInfoEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6a4ee832):
            var tmp = new HelpDeepLinkInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1142bd56):
            var tmp = new SavedPhoneContact
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4dba4501):
            var tmp = new AccountTakeout
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd45ab096):
            var tmp = new PasswordKdfAlgoUnknown
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3a912d4a):
            var tmp = new PasswordKdfAlgoSHA256SHA256PBKDF2HMACSHA512iter100000SHA256ModPow
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4a8537):
            var tmp = new SecurePasswordKdfAlgoUnknown
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbbf2dda0):
            var tmp = new SecurePasswordKdfAlgoPBKDF2HMACSHA512iter100000
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x86471d92):
            var tmp = new SecurePasswordKdfAlgoSHA512
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1527bcac):
            var tmp = new SecureSecretSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9880f658):
            var tmp = new InputCheckPasswordEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd27ff082):
            var tmp = new InputCheckPasswordSRP
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x829d99da):
            var tmp = new SecureRequiredType
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x27477b4):
            var tmp = new SecureRequiredTypeOneOf
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbfb9f457):
            var tmp = new HelpPassportConfigNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa098d6af):
            var tmp = new HelpPassportConfig
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1d1b1245):
            var tmp = new InputAppEvent
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc0de1bd9):
            var tmp = new JsonObjectValue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3f6d7b68):
            var tmp = new JsonNull
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc7345e6a):
            var tmp = new JsonBool
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x2be0dfa4):
            var tmp = new JsonNumber
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb71e767a):
            var tmp = new JsonString
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf7444763):
            var tmp = new JsonArray
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x99c1d49d):
            var tmp = new JsonObject
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x34566b6a):
            var tmp = new PageTableCell
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe0c0c5e5):
            var tmp = new PageTableRow
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6f747657):
            var tmp = new PageCaption
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb92fb6cd):
            var tmp = new PageListItemText
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x25e073fc):
            var tmp = new PageListItemBlocks
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5e068047):
            var tmp = new PageListOrderedItemText
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x98dd8936):
            var tmp = new PageListOrderedItemBlocks
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb390dc08):
            var tmp = new PageRelatedArticle
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x98657f0d):
            var tmp = new Page
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8c05f1c9):
            var tmp = new HelpSupportName
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf3ae2eed):
            var tmp = new HelpUserInfoEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1eb3758):
            var tmp = new HelpUserInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6ca9c2e9):
            var tmp = new PollAnswer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x86e18161):
            var tmp = new Poll
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3b6ddad2):
            var tmp = new PollAnswerVoters
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbadcc1a3):
            var tmp = new PollResults
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf041e250):
            var tmp = new ChatOnlines
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x47a971e0):
            var tmp = new StatsURL
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5fb224d5):
            var tmp = new ChatAdminRights
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9f120418):
            var tmp = new ChatBannedRights
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe630b979):
            var tmp = new InputWallPaper
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x72091c80):
            var tmp = new InputWallPaperSlug
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8427bbac):
            var tmp = new InputWallPaperNoFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1c199183):
            var tmp = new AccountWallPapersNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x702b65a9):
            var tmp = new AccountWallPapers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdebebe83):
            var tmp = new CodeSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5086cf8):
            var tmp = new WallPaperSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe04232f3):
            var tmp = new AutoDownloadSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x63cacf26):
            var tmp = new AccountAutoDownloadSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd5b3b9f9):
            var tmp = new EmojiKeyword
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x236df622):
            var tmp = new EmojiKeywordDeleted
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5cc761bd):
            var tmp = new EmojiKeywordsDifference
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa575739d):
            var tmp = new EmojiURL
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb3fb5361):
            var tmp = new EmojiLanguage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbc7fc6cd):
            var tmp = new FileLocationToBeDeprecated
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xff544e65):
            var tmp = new Folder
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfbd2c296):
            var tmp = new InputFolderPeer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe9baa668):
            var tmp = new FolderPeer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe844ebff):
            var tmp = new MessagesSearchCounter
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x92d33a0e):
            var tmp = new UrlAuthResultRequest
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8f8c0e4e):
            var tmp = new UrlAuthResultAccepted
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa9d6db1f):
            var tmp = new UrlAuthResultDefault
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbfb5ad8b):
            var tmp = new ChannelLocationEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x209b82db):
            var tmp = new ChannelLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xca461b5d):
            var tmp = new PeerLocated
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf8ec284b):
            var tmp = new PeerSelfLocated
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd072acb4):
            var tmp = new RestrictionReason
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3c5693e9):
            var tmp = new InputTheme
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf5890df1):
            var tmp = new InputThemeSlug
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x28f1114):
            var tmp = new Theme
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf41eb622):
            var tmp = new AccountThemesNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7f676421):
            var tmp = new AccountThemes
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x629f1980):
            var tmp = new AuthLoginToken
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x68e9916):
            var tmp = new AuthLoginTokenMigrateTo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x390d5c5e):
            var tmp = new AuthLoginTokenSuccess
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x57e28221):
            var tmp = new AccountContentSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa927fec5):
            var tmp = new MessagesInactiveChats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc3a12462):
            var tmp = new BaseThemeClassic
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xfbd81688):
            var tmp = new BaseThemeDay
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb7b31ea8):
            var tmp = new BaseThemeNight
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6d5f77ee):
            var tmp = new BaseThemeTinted
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5b11125a):
            var tmp = new BaseThemeArctic
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbd507cd1):
            var tmp = new InputThemeSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9c14984a):
            var tmp = new ThemeSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x54b56617):
            var tmp = new WebPageAttributeTheme
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa28e5559):
            var tmp = new MessageUserVote
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x36377430):
            var tmp = new MessageUserVoteInputOption
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe8fe0de):
            var tmp = new MessageUserVoteMultiple
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x823f649):
            var tmp = new MessagesVotesList
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf568028a):
            var tmp = new BankCardOpenUrl
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3e24e573):
            var tmp = new PaymentsBankCardData
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7438f7e8):
            var tmp = new DialogFilter
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x77744d4a):
            var tmp = new DialogFilterSuggested
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb637edaf):
            var tmp = new StatsDateRangeDays
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xcb43acde):
            var tmp = new StatsAbsValueAndPrev
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xcbce2fe0):
            var tmp = new StatsPercentValue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4a27eb2d):
            var tmp = new StatsGraphAsync
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbedc9822):
            var tmp = new StatsGraphError
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8ea464b6):
            var tmp = new StatsGraph
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xad4fc9bd):
            var tmp = new MessageInteractionCounters
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbdf78394):
            var tmp = new StatsBroadcastStats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x98f6ac75):
            var tmp = new HelpPromoDataEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8c39793f):
            var tmp = new HelpPromoData
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe831c556):
            var tmp = new VideoSize
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x18f3d0f7):
            var tmp = new StatsGroupTopPoster
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6014f412):
            var tmp = new StatsGroupTopAdmin
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x31962a4c):
            var tmp = new StatsGroupTopInviter
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xef7ff916):
            var tmp = new StatsMegagroupStats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbea2f424):
            var tmp = new GlobalPrivacySettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4203c5ef):
            var tmp = new HelpCountryCode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc3878e23):
            var tmp = new HelpCountry
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x93cc1f32):
            var tmp = new HelpCountriesListNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x87d0759e):
            var tmp = new HelpCountriesList
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x455b853d):
            var tmp = new MessageViews
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb6c4f543):
            var tmp = new MessagesMessageViews
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf5dd8f9d):
            var tmp = new MessagesDiscussionMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa6d57763):
            var tmp = new MessageReplyHeader
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x4128faac):
            var tmp = new MessageReplies
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xe8fd8014):
            var tmp = new PeerBlocked
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x8999f295):
            var tmp = new StatsMessageStats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x7780bcb4):
            var tmp = new GroupCallDiscarded
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xc0c2052e):
            var tmp = new GroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd8aa840f):
            var tmp = new InputGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x19adba89):
            var tmp = new GroupCallParticipant
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x9e727aad):
            var tmp = new PhoneGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xf47751b6):
            var tmp = new PhoneGroupParticipants
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x3081ed9d):
            var tmp = new InlineQueryPeerTypeSameBotPM
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x833c0fac):
            var tmp = new InlineQueryPeerTypePM
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xd766c50a):
            var tmp = new InlineQueryPeerTypeChat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5ec4be43):
            var tmp = new InlineQueryPeerTypeMegagroup
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x6334ee9a):
            var tmp = new InlineQueryPeerTypeBroadcast
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1662af0b):
            var tmp = new MessagesHistoryImport
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x5e0fb7b9):
            var tmp = new MessagesHistoryImportParsed
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xef8d3e6c):
            var tmp = new MessagesAffectedFoundMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1e3e6680):
            var tmp = new ChatInviteImporter
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xbdc62dcc):
            var tmp = new MessagesExportedChatInvites
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x1871be50):
            var tmp = new MessagesExportedChatInvite
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x222600ef):
            var tmp = new MessagesExportedChatInviteReplaced
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x81b6b00a):
            var tmp = new MessagesChatInviteImporters
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xdfd2330f):
            var tmp = new ChatAdminWithInvites
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xb69b72d7):
            var tmp = new MessagesChatAdminsWithInvites
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xa24de717):
            var tmp = new MessagesCheckedHistoryImportPeer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0xafe5623f):
            var tmp = new PhoneJoinAsPeers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(0x204bd158):
            var tmp = new PhoneExportedGroupCallInvite
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(812830625):
            var tmp = new GZipPacked
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1945237724):
            var tmp = new MessageContainer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2924480661):
            var tmp = new FutureSalts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(155834844):
            var tmp = new FutureSalt
            tmp.TLDecode(bytes)
            self = tmp
            return

        else:
            raise newException(CatchableError, &"Key {id} was not found")