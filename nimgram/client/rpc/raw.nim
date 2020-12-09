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

method TLEncode*(self: TL): seq[uint8] {.base.} = raise newException(Exception, "Trying to encode a generic object")

proc TLEncode*(self: seq[TL]): seq[uint8]

method getTypeName*(self: TLObject): string = "TLObject"

method getTypeName*(self: TLFunction): string = "TLFunction"

method TLDecode*(self: TL, bytes: var ScalingSeq[uint8]) {.base.} = discard

proc TLDecode*(self: var TL, bytes: var ScalingSeq[uint8])    

proc TLDecode*(self: var seq[TL], bytes: var ScalingSeq[uint8])
    

type GZipPacked* = ref object of TLObject
        body*: TL
        
method getTypeName*(self: GZipPacked): string = "GZipPacked"

method TLEncode*(self: GZipPacked): seq[uint8] =
    result.add(TLEncode(uint32(0x3072CFA1)))
    result.add(TLEncode(compress(self.body.TLEncode())))

method TLDecode*(self: GZipPacked, bytes: var ScalingSeq[uint8]) =
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


method TLDecode*(self: FutureSalt, bytes: var ScalingSeq[uint8]) =
    bytes.TLDecode(addr self.validSince) 
    bytes.TLDecode(addr self.validUntil)
    bytes.TLDecode(addr self.salt)  


method TLDecode*(self: FutureSalts, bytes: var ScalingSeq[uint8]) =
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
const LAYER_VERSION* = 122

proc TLDecode*(self: var TL, bytes: var ScalingSeq[uint8]) = 
        var id: uint32
        bytes.TLDecode(addr id)
        case id:
        of uint32(1615239032):
            var tmp = new Req_pq
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3195965169):
            var tmp = new Req_pq_multi
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3608339646):
            var tmp = new Req_DH_params
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4110704415):
            var tmp = new Set_client_DH_params
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1491380032):
            var tmp = new Rpc_drop_answer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3105996036):
            var tmp = new Get_future_salts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2059302892):
            var tmp = new Ping
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4081220492):
            var tmp = new Ping_delay_disconnect
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3880853798):
            var tmp = new Destroy_session
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2459514271):
            var tmp = new Http_wait
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(85337187):
            var tmp = new ResPQ
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2211011308):
            var tmp = new P_q_inner_data
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2043348061):
            var tmp = new Server_DH_params_fail
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3504867164):
            var tmp = new Server_DH_params_ok
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3045658042):
            var tmp = new Server_DH_inner_data
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1715713620):
            var tmp = new Client_DH_inner_data
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1003222836):
            var tmp = new Dh_gen_ok
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1188831161):
            var tmp = new Dh_gen_retry
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2795351554):
            var tmp = new Dh_gen_fail
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4082920705):
            var tmp = new Rpc_result
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(558156313):
            var tmp = new Rpc_error
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1579864942):
            var tmp = new Rpc_answer_unknown
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3447252358):
            var tmp = new Rpc_answer_dropped_running
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2755319991):
            var tmp = new Rpc_answer_dropped
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(880243653):
            var tmp = new Pong
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3793765884):
            var tmp = new Destroy_session_ok
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1658015945):
            var tmp = new Destroy_session_none
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2663516424):
            var tmp = new New_session_created
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1658238041):
            var tmp = new Msgs_ack
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2817521681):
            var tmp = new Bad_msg_notification
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3987424379):
            var tmp = new Bad_server_salt
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2105940488):
            var tmp = new Msg_resend_req
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3664378706):
            var tmp = new Msgs_state_req
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(81704317):
            var tmp = new Msgs_state_info
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2361446705):
            var tmp = new Msgs_all_info
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(661470918):
            var tmp = new Msg_detailed_info
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2157819615):
            var tmp = new Msg_new_detailed_info
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3416209197):
            var tmp = new InvokeAfterMsg
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1036301552):
            var tmp = new InvokeAfterMsgs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3251461801):
            var tmp = new InitConnection
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3667594509):
            var tmp = new InvokeWithLayer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3214170551):
            var tmp = new InvokeWithoutUpdates
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(911373810):
            var tmp = new InvokeWithMessagesRange
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2896821550):
            var tmp = new InvokeWithTakeout
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2792825935):
            var tmp = new AuthSendCode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2163139623):
            var tmp = new AuthSignUp
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3168081281):
            var tmp = new AuthSignIn
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1461180992):
            var tmp = new AuthLogOut
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2678787354):
            var tmp = new AuthResetAuthorizations
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3854565325):
            var tmp = new AuthExportAuthorization
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3824129555):
            var tmp = new AuthImportAuthorization
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3453233669):
            var tmp = new AuthBindTempAuthKey
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1738800940):
            var tmp = new AuthImportBotAuthorization
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3515567382):
            var tmp = new AuthCheckPassword
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3633822822):
            var tmp = new AuthRequestPasswordRecovery
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1319464594):
            var tmp = new AuthRecoverPassword
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1056025023):
            var tmp = new AuthResendCode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(520357240):
            var tmp = new AuthCancelCode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2387124616):
            var tmp = new AuthDropTempAuthKeys
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2981369111):
            var tmp = new AuthExportLoginToken
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2511101156):
            var tmp = new AuthImportLoginToken
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3902057805):
            var tmp = new AuthAcceptLoginToken
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1754754159):
            var tmp = new AccountRegisterDevice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(813089983):
            var tmp = new AccountUnregisterDevice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2227067795):
            var tmp = new AccountUpdateNotifySettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(313765169):
            var tmp = new AccountGetNotifySettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3682473799):
            var tmp = new AccountResetNotifySettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2018596725):
            var tmp = new AccountUpdateProfile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1713919532):
            var tmp = new AccountUpdateStatus
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2864387939):
            var tmp = new AccountGetWallPapers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2920848735):
            var tmp = new AccountReportPeer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(655677548):
            var tmp = new AccountCheckUsername
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1040964988):
            var tmp = new AccountUpdateUsername
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3671837008):
            var tmp = new AccountGetPrivacy
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3388480744):
            var tmp = new AccountSetPrivacy
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1099779595):
            var tmp = new AccountDeleteAccount
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2412188112):
            var tmp = new AccountGetAccountTTL
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(608323678):
            var tmp = new AccountSetAccountTTL
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2186758885):
            var tmp = new AccountSendChangePhoneCode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1891839707):
            var tmp = new AccountChangePhone
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(954152242):
            var tmp = new AccountUpdateDeviceLocked
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3810574680):
            var tmp = new AccountGetAuthorizations
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3749180348):
            var tmp = new AccountResetAuthorization
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1418342645):
            var tmp = new AccountGetPassword
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2631199481):
            var tmp = new AccountGetPasswordSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2778402863):
            var tmp = new AccountUpdatePasswordSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(457157256):
            var tmp = new AccountSendConfirmPhoneCode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1596029123):
            var tmp = new AccountConfirmPhone
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1151208273):
            var tmp = new AccountGetTmpPassword
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(405695855):
            var tmp = new AccountGetWebAuthorizations
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(755087855):
            var tmp = new AccountResetWebAuthorization
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1747789204):
            var tmp = new AccountResetWebAuthorizations
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2995305597):
            var tmp = new AccountGetAllSecureValues
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1936088002):
            var tmp = new AccountGetSecureValue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2308956957):
            var tmp = new AccountSaveSecureValue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3095444555):
            var tmp = new AccountDeleteSecureValue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3094063329):
            var tmp = new AccountGetAuthorizationForm
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3875699860):
            var tmp = new AccountAcceptAuthorization
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2778945273):
            var tmp = new AccountSendVerifyPhoneCode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1305716726):
            var tmp = new AccountVerifyPhone
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1880182943):
            var tmp = new AccountSendVerifyEmailCode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3971627483):
            var tmp = new AccountVerifyEmail
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4032514052):
            var tmp = new AccountInitTakeoutSession
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(489050862):
            var tmp = new AccountFinishTakeoutSession
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2413762848):
            var tmp = new AccountConfirmPasswordEmail
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2055154197):
            var tmp = new AccountResendPasswordEmail
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3251361206):
            var tmp = new AccountCancelPasswordEmail
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2668087080):
            var tmp = new AccountGetContactSignUpNotification
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3488890721):
            var tmp = new AccountSetContactSignUpNotification
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1398240377):
            var tmp = new AccountGetNotifyExceptions
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4237155306):
            var tmp = new AccountGetWallPaper
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3716494945):
            var tmp = new AccountUploadWallPaper
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1817860919):
            var tmp = new AccountSaveWallPaper
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4276967273):
            var tmp = new AccountInstallWallPaper
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3141244932):
            var tmp = new AccountResetWallPapers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1457130303):
            var tmp = new AccountGetAutoDownloadSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1995661875):
            var tmp = new AccountSaveAutoDownloadSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(473805619):
            var tmp = new AccountUploadTheme
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2217919007):
            var tmp = new AccountCreateTheme
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1555261397):
            var tmp = new AccountUpdateTheme
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4065792108):
            var tmp = new AccountSaveTheme
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2061776695):
            var tmp = new AccountInstallTheme
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2375906347):
            var tmp = new AccountGetTheme
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(676939512):
            var tmp = new AccountGetThemes
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3044323691):
            var tmp = new AccountSetContentSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2342210990):
            var tmp = new AccountGetContentSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1705865692):
            var tmp = new AccountGetMultiWallPapers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3945483510):
            var tmp = new AccountGetGlobalPrivacySettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(517647042):
            var tmp = new AccountSetGlobalPrivacySettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3642381440):
            var tmp = new UsersGetUsers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3392185777):
            var tmp = new UsersGetFullUser
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2429064373):
            var tmp = new UsersSetSecureValueErrors
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(749357634):
            var tmp = new ContactsGetContactIDs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3299038190):
            var tmp = new ContactsGetStatuses
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3223553183):
            var tmp = new ContactsGetContacts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(746589157):
            var tmp = new ContactsImportContacts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2527125504):
            var tmp = new ContactsDeleteContacts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(269745566):
            var tmp = new ContactsDeleteByPhones
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1758204945):
            var tmp = new ContactsBlock
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3198573904):
            var tmp = new ContactsUnblock
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4118557967):
            var tmp = new ContactsGetBlocked
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(301470424):
            var tmp = new ContactsSearch
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4181511075):
            var tmp = new ContactsResolveUsername
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3566742965):
            var tmp = new ContactsGetTopPeers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(451113900):
            var tmp = new ContactsResetTopPeerRating
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2274703345):
            var tmp = new ContactsResetSaved
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2196890527):
            var tmp = new ContactsGetSaved
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2232729050):
            var tmp = new ContactsToggleTopPeers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3908330448):
            var tmp = new ContactsAddContact
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4164002319):
            var tmp = new ContactsAcceptContact
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3544759364):
            var tmp = new ContactsGetLocated
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(698914348):
            var tmp = new ContactsBlockFromReplies
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1673946374):
            var tmp = new MessagesGetMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2699967347):
            var tmp = new MessagesGetDialogs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3703276128):
            var tmp = new MessagesGetHistory
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3276992192):
            var tmp = new MessagesSearch
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3808875424):
            var tmp = new MessagesReadHistory
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(469850889):
            var tmp = new MessagesDeleteHistory
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3851326930):
            var tmp = new MessagesDeleteMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1519733760):
            var tmp = new MessagesReceivedMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1486110434):
            var tmp = new MessagesSetTyping
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1376532592):
            var tmp = new MessagesSendMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(881978281):
            var tmp = new MessagesSendMedia
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3657360910):
            var tmp = new MessagesForwardMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3474297563):
            var tmp = new MessagesReportSpam
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(913498268):
            var tmp = new MessagesGetPeerSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3179460184):
            var tmp = new MessagesReport
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1013621127):
            var tmp = new MessagesGetChats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(998448230):
            var tmp = new MessagesGetFullChat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3695519829):
            var tmp = new MessagesEditChatTitle
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3394009560):
            var tmp = new MessagesEditChatPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4188056073):
            var tmp = new MessagesAddChatUser
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3764461334):
            var tmp = new MessagesDeleteChatUser
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2628855520):
            var tmp = new MessagesCreateChat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(651135312):
            var tmp = new MessagesGetDhConfig
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4132286275):
            var tmp = new MessagesRequestEncryption
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1035731989):
            var tmp = new MessagesAcceptEncryption
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3990430661):
            var tmp = new MessagesDiscardEncryption
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2031374829):
            var tmp = new MessagesSetEncryptedTyping
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2135648522):
            var tmp = new MessagesReadEncryptedHistory
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1157265941):
            var tmp = new MessagesSendEncrypted
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1431914525):
            var tmp = new MessagesSendEncryptedFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(852769188):
            var tmp = new MessagesSendEncryptedService
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1436924774):
            var tmp = new MessagesReceivedQueue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1259113487):
            var tmp = new MessagesReportEncryptedSpam
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(916930423):
            var tmp = new MessagesReadMessageContents
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1138029248):
            var tmp = new MessagesGetStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(479598769):
            var tmp = new MessagesGetAllStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2338894028):
            var tmp = new MessagesGetWebPagePreview
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3749000384):
            var tmp = new MessagesExportChatInvite
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1051570619):
            var tmp = new MessagesCheckChatInvite
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1817183516):
            var tmp = new MessagesImportChatInvite
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(639215886):
            var tmp = new MessagesGetStickerSet
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3348096096):
            var tmp = new MessagesInstallStickerSet
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4184757726):
            var tmp = new MessagesUninstallStickerSet
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3873403768):
            var tmp = new MessagesStartBot
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1468322785):
            var tmp = new MessagesGetMessagesViews
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2850463534):
            var tmp = new MessagesEditChatAdmin
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(363051235):
            var tmp = new MessagesMigrateChat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1271290010):
            var tmp = new MessagesSearchGlobal
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2016638777):
            var tmp = new MessagesReorderStickerSets
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(864953444):
            var tmp = new MessagesGetDocumentByHash
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2210348370):
            var tmp = new MessagesGetSavedGifs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(846868683):
            var tmp = new MessagesSaveGif
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1364105629):
            var tmp = new MessagesGetInlineBotResults
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3948847622):
            var tmp = new MessagesSetInlineBotResults
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(570955184):
            var tmp = new MessagesSendInlineBotResult
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4255550774):
            var tmp = new MessagesGetMessageEditData
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1224152952):
            var tmp = new MessagesEditMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2203418042):
            var tmp = new MessagesEditInlineBotMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2470627847):
            var tmp = new MessagesGetBotCallbackAnswer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3582923530):
            var tmp = new MessagesSetBotCallbackAnswer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3832593661):
            var tmp = new MessagesGetPeerDialogs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3157909835):
            var tmp = new MessagesSaveDraft
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1782549861):
            var tmp = new MessagesGetAllDrafts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(766298703):
            var tmp = new MessagesGetFeaturedStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1527873830):
            var tmp = new MessagesReadFeaturedStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1587647177):
            var tmp = new MessagesGetRecentStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(958863608):
            var tmp = new MessagesSaveRecentSticker
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2308530221):
            var tmp = new MessagesClearRecentStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1475442322):
            var tmp = new MessagesGetArchivedStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1706608543):
            var tmp = new MessagesGetMaskStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3428542412):
            var tmp = new MessagesGetAttachedStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2398678208):
            var tmp = new MessagesSetGameScore
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(363700068):
            var tmp = new MessagesSetInlineGameScore
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3894568093):
            var tmp = new MessagesGetGameHighScores
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4130726320):
            var tmp = new MessagesGetInlineGameHighScores
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3500444736):
            var tmp = new MessagesGetCommonChats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3953659888):
            var tmp = new MessagesGetAllChats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(852135825):
            var tmp = new MessagesGetWebPage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2805064279):
            var tmp = new MessagesToggleDialogPin
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(991616823):
            var tmp = new MessagesReorderPinnedDialogs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3602468338):
            var tmp = new MessagesGetPinnedDialogs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3858133754):
            var tmp = new MessagesSetBotShippingResults
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2620250448):
            var tmp = new MessagesSetBotPrecheckoutResults
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1369162417):
            var tmp = new MessagesUploadMedia
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3380473888):
            var tmp = new MessagesSendScreenshotNotification
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(567151374):
            var tmp = new MessagesGetFavedStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3120547163):
            var tmp = new MessagesFaveSticker
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1180140658):
            var tmp = new MessagesGetUnreadMentions
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4028144944):
            var tmp = new MessagesReadMentions
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3150207753):
            var tmp = new MessagesGetRecentLocations
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3422621899):
            var tmp = new MessagesSendMultiMedia
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1347929239):
            var tmp = new MessagesUploadEncryptedFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3266826379):
            var tmp = new MessagesSearchStickerSets
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(486505992):
            var tmp = new MessagesGetSplitRanges
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3263617423):
            var tmp = new MessagesMarkDialogUnread
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(585256482):
            var tmp = new MessagesGetDialogUnreadMarks
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2119757468):
            var tmp = new MessagesClearAllDrafts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3534419948):
            var tmp = new MessagesUpdatePinnedMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(283795844):
            var tmp = new MessagesSendVote
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1941660731):
            var tmp = new MessagesGetPollResults
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1848369232):
            var tmp = new MessagesGetOnlines
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2167155430):
            var tmp = new MessagesGetStatsURL
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3740665751):
            var tmp = new MessagesEditChatAbout
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2777049921):
            var tmp = new MessagesEditChatDefaultBannedRights
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(899735650):
            var tmp = new MessagesGetEmojiKeywords
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(352892591):
            var tmp = new MessagesGetEmojiKeywordsDifference
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1318675378):
            var tmp = new MessagesGetEmojiKeywordsLanguages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3585149990):
            var tmp = new MessagesGetEmojiURL
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1932455680):
            var tmp = new MessagesGetSearchCounters
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3812578835):
            var tmp = new MessagesRequestUrlAuth
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4146719384):
            var tmp = new MessagesAcceptUrlAuth
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1336717624):
            var tmp = new MessagesHidePeerSettingsBar
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3804391515):
            var tmp = new MessagesGetScheduledHistory
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3183150180):
            var tmp = new MessagesGetScheduledMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3174597898):
            var tmp = new MessagesSendScheduledMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1504586518):
            var tmp = new MessagesDeleteScheduledMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3094231054):
            var tmp = new MessagesGetPollVotes
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3037016042):
            var tmp = new MessagesToggleStickerSets
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4053719405):
            var tmp = new MessagesGetDialogFilters
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2728186924):
            var tmp = new MessagesGetSuggestedDialogFilters
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(450142282):
            var tmp = new MessagesUpdateDialogFilter
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3311649252):
            var tmp = new MessagesUpdateDialogFiltersOrder
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1608974939):
            var tmp = new MessagesGetOldFeaturedStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(615875002):
            var tmp = new MessagesGetReplies
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1147761405):
            var tmp = new MessagesGetDiscussionMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4147227124):
            var tmp = new MessagesReadDiscussion
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4029004939):
            var tmp = new MessagesUnpinAllMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3990128682):
            var tmp = new UpdatesGetState
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(630429265):
            var tmp = new UpdatesGetDifference
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(829675392):
            var tmp = new UpdatesGetChannelDifference
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1926525996):
            var tmp = new PhotosUpdateProfilePhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2314407785):
            var tmp = new PhotosUploadProfilePhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2278522671):
            var tmp = new PhotosDeletePhotos
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2446144168):
            var tmp = new PhotosGetUserPhotos
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3003426337):
            var tmp = new UploadSaveFilePart
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2975505148):
            var tmp = new UploadGetFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3732629309):
            var tmp = new UploadSaveBigFilePart
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(619086221):
            var tmp = new UploadGetWebFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(536919235):
            var tmp = new UploadGetCdnFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2603046056):
            var tmp = new UploadReuploadCdnFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1302676017):
            var tmp = new UploadGetCdnFileHashes
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3338819889):
            var tmp = new UploadGetFileHashes
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3304659051):
            var tmp = new HelpGetConfig
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(531836966):
            var tmp = new HelpGetNearestDc
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1378703997):
            var tmp = new HelpGetAppUpdate
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1295590211):
            var tmp = new HelpGetInviteText
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2631862477):
            var tmp = new HelpGetSupport
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2417028975):
            var tmp = new HelpGetAppChangelog
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3961704397):
            var tmp = new HelpSetBotUpdatesStatus
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1375900482):
            var tmp = new HelpGetCdnConfig
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1036054804):
            var tmp = new HelpGetRecentMeUrls
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(749019089):
            var tmp = new HelpGetTermsOfServiceUpdate
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4000511898):
            var tmp = new HelpAcceptTermsOfService
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1072547679):
            var tmp = new HelpGetDeepLinkInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2559656208):
            var tmp = new HelpGetAppConfig
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1862465352):
            var tmp = new HelpSaveAppLog
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3328290056):
            var tmp = new HelpGetPassportConfig
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3546343212):
            var tmp = new HelpGetSupportName
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(950046000):
            var tmp = new HelpGetUserInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1723407216):
            var tmp = new HelpEditUserInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3231151137):
            var tmp = new HelpGetPromoData
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(505748629):
            var tmp = new HelpHidePromoData
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2012912112):
            var tmp = new HelpDismissSuggestion
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1935116200):
            var tmp = new HelpGetCountriesList
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3423619383):
            var tmp = new ChannelsReadHistory
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2227305806):
            var tmp = new ChannelsDeleteMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3507345179):
            var tmp = new ChannelsDeleteUserHistory
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4261967888):
            var tmp = new ChannelsReportSpam
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2911672867):
            var tmp = new ChannelsGetMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(306054633):
            var tmp = new ChannelsGetParticipants
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1416484774):
            var tmp = new ChannelsGetParticipant
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2817964976):
            var tmp = new ChannelsGetChannels
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2268504208):
            var tmp = new ChannelsGetFullChannel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1029681423):
            var tmp = new ChannelsCreateChannel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3543959810):
            var tmp = new ChannelsEditAdmin
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1450044624):
            var tmp = new ChannelsEditTitle
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4046346185):
            var tmp = new ChannelsEditPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(283557164):
            var tmp = new ChannelsCheckUsername
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(890549214):
            var tmp = new ChannelsUpdateUsername
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(615851205):
            var tmp = new ChannelsJoinChannel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4164332181):
            var tmp = new ChannelsLeaveChannel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(429865580):
            var tmp = new ChannelsInviteToChannel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3222347747):
            var tmp = new ChannelsDeleteChannel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3862932971):
            var tmp = new ChannelsExportMessageLink
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(527021574):
            var tmp = new ChannelsToggleSignatures
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4172297903):
            var tmp = new ChannelsGetAdminedPublicChannels
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1920559378):
            var tmp = new ChannelsEditBanned
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(870184064):
            var tmp = new ChannelsGetAdminLog
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3935085817):
            var tmp = new ChannelsSetStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3937786936):
            var tmp = new ChannelsReadMessageContents
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2939592002):
            var tmp = new ChannelsDeleteHistory
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3938171212):
            var tmp = new ChannelsTogglePreHistoryHidden
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2202135744):
            var tmp = new ChannelsGetLeftChannels
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4124758904):
            var tmp = new ChannelsGetGroupsForDiscussion
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1079520178):
            var tmp = new ChannelsSetDiscussionGroup
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2402864415):
            var tmp = new ChannelsEditCreator
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1491484525):
            var tmp = new ChannelsEditLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3990134512):
            var tmp = new ChannelsToggleSlowMode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(300429806):
            var tmp = new ChannelsGetInactiveChannels
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2854709741):
            var tmp = new BotsSendCustomRequest
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3860938573):
            var tmp = new BotsAnswerWebhookJSONQuery
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2153596662):
            var tmp = new BotsSetBotCommands
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2582681413):
            var tmp = new PaymentsGetPaymentForm
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2693966208):
            var tmp = new PaymentsGetPaymentReceipt
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1997180532):
            var tmp = new PaymentsValidateRequestedInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(730364339):
            var tmp = new PaymentsSendPaymentForm
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(578650699):
            var tmp = new PaymentsGetSavedInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3627905217):
            var tmp = new PaymentsClearSavedInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(779736953):
            var tmp = new PaymentsGetBankCardData
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4043532160):
            var tmp = new StickersCreateStickerSet
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4151709521):
            var tmp = new StickersRemoveStickerFromSet
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4290172106):
            var tmp = new StickersChangeStickerPosition
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2253651646):
            var tmp = new StickersAddStickerToSet
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2587250224):
            var tmp = new StickersSetStickerSetThumb
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1430593449):
            var tmp = new PhoneGetCallConfig
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1124046573):
            var tmp = new PhoneRequestCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1003664544):
            var tmp = new PhoneAcceptCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(788404002):
            var tmp = new PhoneConfirmCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(399855457):
            var tmp = new PhoneReceivedCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2999697856):
            var tmp = new PhoneDiscardCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1508562471):
            var tmp = new PhoneSetCallRating
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(662363518):
            var tmp = new PhoneSaveCallDebug
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4286223235):
            var tmp = new PhoneSendSignalingData
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3827890690):
            var tmp = new PhoneCreateGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1604095586):
            var tmp = new PhoneJoinGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1342404601):
            var tmp = new PhoneLeaveGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1662282468):
            var tmp = new PhoneEditGroupCallMember
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2067345760):
            var tmp = new PhoneInviteToGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2054648117):
            var tmp = new PhoneDiscardGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1958458429):
            var tmp = new PhoneToggleGroupCallSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3351970160):
            var tmp = new PhoneGetGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3388068485):
            var tmp = new PhoneGetGroupParticipants
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3075111914):
            var tmp = new PhoneCheckGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4075959050):
            var tmp = new LangpackGetLangPack
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4025104387):
            var tmp = new LangpackGetStrings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3449309861):
            var tmp = new LangpackGetDifference
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1120311183):
            var tmp = new LangpackGetLanguages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1784243458):
            var tmp = new LangpackGetLanguage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1749536939):
            var tmp = new FoldersEditPeerFolders
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(472471681):
            var tmp = new FoldersDeleteFolder
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2873246746):
            var tmp = new StatsGetBroadcastStats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1646092192):
            var tmp = new StatsLoadAsyncGraph
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3705636359):
            var tmp = new StatsGetMegagroupStats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1445996571):
            var tmp = new StatsGetMessagePublicForwards
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3068175349):
            var tmp = new StatsGetMessageStats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2134579434):
            var tmp = new InputPeerEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2107670217):
            var tmp = new InputPeerSelf
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(396093539):
            var tmp = new InputPeerChat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2072935910):
            var tmp = new InputPeerUser
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(548253432):
            var tmp = new InputPeerChannel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(398123750):
            var tmp = new InputPeerUserFromMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2627073979):
            var tmp = new InputPeerChannelFromMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3112732367):
            var tmp = new InputUserEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4156666175):
            var tmp = new InputUserSelf
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3626575894):
            var tmp = new InputUser
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(756118935):
            var tmp = new InputUserFromMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4086478836):
            var tmp = new InputPhoneContact
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4113560191):
            var tmp = new InputFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4199484341):
            var tmp = new InputFileBig
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2523198847):
            var tmp = new InputMediaEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(505969924):
            var tmp = new InputMediaUploadedPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3015312949):
            var tmp = new InputMediaPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4190388548):
            var tmp = new InputMediaGeoPoint
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4171988475):
            var tmp = new InputMediaContact
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1530447553):
            var tmp = new InputMediaUploadedDocument
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(598418386):
            var tmp = new InputMediaDocument
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3242007569):
            var tmp = new InputMediaVenue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3854302746):
            var tmp = new InputMediaPhotoExternal
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4216511641):
            var tmp = new InputMediaDocumentExternal
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3544138739):
            var tmp = new InputMediaGame
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4108359363):
            var tmp = new InputMediaInvoice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2535434307):
            var tmp = new InputMediaGeoLive
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4182662928):
            var tmp = new InputMediaPoll
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3866083195):
            var tmp = new InputMediaDice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(480546647):
            var tmp = new InputChatPhotoEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3326243406):
            var tmp = new InputChatUploadedPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2303962423):
            var tmp = new InputChatPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3837862870):
            var tmp = new InputGeoPointEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1210199983):
            var tmp = new InputGeoPoint
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(483901197):
            var tmp = new InputPhotoEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1001634122):
            var tmp = new InputPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3755650017):
            var tmp = new InputFileLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4112735573):
            var tmp = new InputEncryptedFileLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3134223748):
            var tmp = new InputDocumentFileLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3418877480):
            var tmp = new InputSecureFileLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(700340377):
            var tmp = new InputTakeoutFileLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1075322878):
            var tmp = new InputPhotoFileLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3627312883):
            var tmp = new InputPhotoLegacyFileLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(668375447):
            var tmp = new InputPeerPhotoFileLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3685658256):
            var tmp = new InputStickerSetThumb
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2645671021):
            var tmp = new PeerUser
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3134252475):
            var tmp = new PeerChat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3185435954):
            var tmp = new PeerChannel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2861972229):
            var tmp = new StorageFileUnknown
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1086091090):
            var tmp = new StorageFilePartial
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2130578944):
            var tmp = new StorageFileJpeg
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3403786975):
            var tmp = new StorageFileGif
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2767600640):
            var tmp = new StorageFilePng
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2921222285):
            var tmp = new StorageFilePdf
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1384777335):
            var tmp = new StorageFileMp3
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1258941372):
            var tmp = new StorageFileMov
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3016663268):
            var tmp = new StorageFileMp4
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(276907596):
            var tmp = new StorageFileWebp
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(537022650):
            var tmp = new UserEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2474924225):
            var tmp = new User
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1326562017):
            var tmp = new UserProfilePhotoEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1775479590):
            var tmp = new UserProfilePhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2634351760):
            var tmp = new UserStatusEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3988339017):
            var tmp = new UserStatusOnline
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2356166400):
            var tmp = new UserStatusOffline
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3798942449):
            var tmp = new UserStatusRecently
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2079367104):
            var tmp = new UserStatusLastWeek
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2011940674):
            var tmp = new UserStatusLastMonth
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2611140608):
            var tmp = new ChatEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1004149726):
            var tmp = new Chat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1932049840):
            var tmp = new ChatForbidden
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3541734942):
            var tmp = new Channel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(681420594):
            var tmp = new ChannelForbidden
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(461151667):
            var tmp = new ChatFull
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4013583053):
            var tmp = new ChannelFull
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3369552190):
            var tmp = new ChatParticipant
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3658699658):
            var tmp = new ChatParticipantCreator
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3805733942):
            var tmp = new ChatParticipantAdmin
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4237298731):
            var tmp = new ChatParticipantsForbidden
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1061556205):
            var tmp = new ChatParticipants
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(935395612):
            var tmp = new ChatPhotoEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3523977020):
            var tmp = new ChatPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2212879956):
            var tmp = new MessageEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1487813065):
            var tmp = new Message
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(678405636):
            var tmp = new MessageService
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1038967584):
            var tmp = new MessageMediaEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1766936791):
            var tmp = new MessageMediaPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1457575028):
            var tmp = new MessageMediaGeo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3421653312):
            var tmp = new MessageMediaContact
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2676290718):
            var tmp = new MessageMediaUnsupported
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2628808919):
            var tmp = new MessageMediaDocument
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2737690112):
            var tmp = new MessageMediaWebPage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(784356159):
            var tmp = new MessageMediaVenue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4256272392):
            var tmp = new MessageMediaGame
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2220168007):
            var tmp = new MessageMediaInvoice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3108030054):
            var tmp = new MessageMediaGeoLive
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1272375192):
            var tmp = new MessageMediaPoll
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1065280907):
            var tmp = new MessageMediaDice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3064919984):
            var tmp = new MessageActionEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2791541658):
            var tmp = new MessageActionChatCreate
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3047280218):
            var tmp = new MessageActionChatEditTitle
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2144015272):
            var tmp = new MessageActionChatEditPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2514746351):
            var tmp = new MessageActionChatDeletePhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1217033015):
            var tmp = new MessageActionChatAddUser
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2997787404):
            var tmp = new MessageActionChatDeleteUser
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4171036136):
            var tmp = new MessageActionChatJoinedByLink
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2513611922):
            var tmp = new MessageActionChannelCreate
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1371385889):
            var tmp = new MessageActionChatMigrateTo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2958420718):
            var tmp = new MessageActionChannelMigrateFrom
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2495428845):
            var tmp = new MessageActionPinMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2679813636):
            var tmp = new MessageActionHistoryClear
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2460428406):
            var tmp = new MessageActionGameScore
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2402399015):
            var tmp = new MessageActionPaymentSentMe
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1080663248):
            var tmp = new MessageActionPaymentSent
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2162236031):
            var tmp = new MessageActionPhoneCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1200788123):
            var tmp = new MessageActionScreenshotTaken
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4209418070):
            var tmp = new MessageActionCustomAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2884218878):
            var tmp = new MessageActionBotAllowed
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(455635795):
            var tmp = new MessageActionSecureValuesSentMe
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3646710100):
            var tmp = new MessageActionSecureValuesSent
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4092747638):
            var tmp = new MessageActionContactSignUp
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2564871831):
            var tmp = new MessageActionGeoProximityReached
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2047704898):
            var tmp = new MessageActionGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1991897370):
            var tmp = new MessageActionInviteToGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(739712882):
            var tmp = new Dialog
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1908216652):
            var tmp = new DialogFolder
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(590459437):
            var tmp = new PhotoEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4212750949):
            var tmp = new Photo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3783140288):
            var tmp = new PhotoSizeEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2009052699):
            var tmp = new PhotoSize
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3920049402):
            var tmp = new PhotoCachedSize
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3769678894):
            var tmp = new PhotoStrippedSize
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1520986705):
            var tmp = new PhotoSizeProgressive
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3626061121):
            var tmp = new PhotoPathSize
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(286776671):
            var tmp = new GeoPointEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2997024355):
            var tmp = new GeoPoint
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1577067778):
            var tmp = new AuthSentCode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3439659286):
            var tmp = new AuthAuthorization
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1148485274):
            var tmp = new AuthAuthorizationSignUpRequired
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3751189549):
            var tmp = new AuthExportedAuthorization
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3099351820):
            var tmp = new InputNotifyPeer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(423314455):
            var tmp = new InputNotifyUsers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1251338318):
            var tmp = new InputNotifyChats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2983951486):
            var tmp = new InputNotifyBroadcasts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2621249934):
            var tmp = new InputPeerNotifySettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2941295904):
            var tmp = new PeerNotifySettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1933519201):
            var tmp = new PeerSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2755118061):
            var tmp = new WallPaper
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2331249445):
            var tmp = new WallPaperNoFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1490799288):
            var tmp = new InputReportReasonSpam
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(505595789):
            var tmp = new InputReportReasonViolence
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(777640226):
            var tmp = new InputReportReasonPornography
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2918469347):
            var tmp = new InputReportReasonChildAbuse
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3782503690):
            var tmp = new InputReportReasonOther
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2609510714):
            var tmp = new InputReportReasonCopyright
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3688169197):
            var tmp = new InputReportReasonGeoIrrelevant
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3992026130):
            var tmp = new UserFull
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4178692500):
            var tmp = new Contact
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3489825848):
            var tmp = new ImportedContact
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3546811489):
            var tmp = new ContactStatus
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3075189202):
            var tmp = new ContactsContactsNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3941105218):
            var tmp = new ContactsContacts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2010127419):
            var tmp = new ContactsImportedContacts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2917226768):
            var tmp = new ContactsBlocked
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3781575060):
            var tmp = new ContactsBlockedSlice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(364538944):
            var tmp = new MessagesDialogs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1910543603):
            var tmp = new MessagesDialogsSlice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4041467286):
            var tmp = new MessagesDialogsNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2356252295):
            var tmp = new MessagesMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(978610270):
            var tmp = new MessagesMessagesSlice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1682413576):
            var tmp = new MessagesChannelMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1951620897):
            var tmp = new MessagesMessagesNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1694474197):
            var tmp = new MessagesChats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2631405892):
            var tmp = new MessagesChatsSlice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3856126364):
            var tmp = new MessagesChatFull
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3025955281):
            var tmp = new MessagesAffectedHistory
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1474492012):
            var tmp = new InputMessagesFilterEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2517214492):
            var tmp = new InputMessagesFilterPhotos
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2680163941):
            var tmp = new InputMessagesFilterVideo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1458172132):
            var tmp = new InputMessagesFilterPhotoVideo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2665345416):
            var tmp = new InputMessagesFilterDocument
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2129714567):
            var tmp = new InputMessagesFilterUrl
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4291323271):
            var tmp = new InputMessagesFilterGif
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1358283666):
            var tmp = new InputMessagesFilterVoice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(928101534):
            var tmp = new InputMessagesFilterMusic
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(975236280):
            var tmp = new InputMessagesFilterChatPhotos
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2160695144):
            var tmp = new InputMessagesFilterPhoneCalls
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2054952868):
            var tmp = new InputMessagesFilterRoundVoice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3041516115):
            var tmp = new InputMessagesFilterRoundVideo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3254314650):
            var tmp = new InputMessagesFilterMyMentions
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3875695885):
            var tmp = new InputMessagesFilterGeo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3764575107):
            var tmp = new InputMessagesFilterContacts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(464520273):
            var tmp = new InputMessagesFilterPinned
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(522914557):
            var tmp = new UpdateNewMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1318109142):
            var tmp = new UpdateMessageID
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2718806245):
            var tmp = new UpdateDeleteMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1548249383):
            var tmp = new UpdateUserTyping
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2590370335):
            var tmp = new UpdateChatUserTyping
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2002852224):
            var tmp = new UpdateChatParticipants
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(469489699):
            var tmp = new UpdateUserStatus
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2805148531):
            var tmp = new UpdateUserName
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2503031564):
            var tmp = new UpdateUserPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(314359194):
            var tmp = new UpdateNewEncryptedMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(386986326):
            var tmp = new UpdateEncryptedChatTyping
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3030575245):
            var tmp = new UpdateEncryption
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(956179895):
            var tmp = new UpdateEncryptedMessagesRead
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3930787420):
            var tmp = new UpdateChatParticipantAdd
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1851755554):
            var tmp = new UpdateChatParticipantDelete
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2388564083):
            var tmp = new UpdateDcOptions
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3200411887):
            var tmp = new UpdateNotifySettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3957614617):
            var tmp = new UpdateServiceNotification
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3996854058):
            var tmp = new UpdatePrivacy
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(314130811):
            var tmp = new UpdateUserPhone
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2627162079):
            var tmp = new UpdateReadHistoryInbox
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(791617983):
            var tmp = new UpdateReadHistoryOutbox
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2139689491):
            var tmp = new UpdateWebPage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1757493555):
            var tmp = new UpdateReadMessagesContents
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3942934523):
            var tmp = new UpdateChannelTooLong
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3067369046):
            var tmp = new UpdateChannel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1656358105):
            var tmp = new UpdateNewChannelMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(856380452):
            var tmp = new UpdateReadChannelInbox
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3279233481):
            var tmp = new UpdateDeleteChannelMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2560699211):
            var tmp = new UpdateChannelMessageViews
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3062896985):
            var tmp = new UpdateChatParticipantAdmin
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1753886890):
            var tmp = new UpdateNewStickerSet
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3140296720):
            var tmp = new UpdateStickerSetsOrder
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1135492588):
            var tmp = new UpdateStickerSets
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2473931806):
            var tmp = new UpdateSavedGifs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1059076315):
            var tmp = new UpdateBotInlineQuery
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3834615360):
            var tmp = new UpdateBotInlineSend
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(457133559):
            var tmp = new UpdateEditChannelMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3879028705):
            var tmp = new UpdateBotCallbackQuery
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3825430691):
            var tmp = new UpdateEditMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4191320666):
            var tmp = new UpdateInlineBotCallbackQuery
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(634833351):
            var tmp = new UpdateReadChannelOutbox
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3995842921):
            var tmp = new UpdateDraftMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1461528386):
            var tmp = new UpdateReadFeaturedStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2588027936):
            var tmp = new UpdateRecentStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2720652550):
            var tmp = new UpdateConfig
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(861169551):
            var tmp = new UpdatePtsChanged
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1081547008):
            var tmp = new UpdateChannelWebPage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1852826908):
            var tmp = new UpdateDialogPinned
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4195302562):
            var tmp = new UpdatePinnedDialogs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2199371971):
            var tmp = new UpdateBotWebhookJSON
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2610053286):
            var tmp = new UpdateBotWebhookJSONQuery
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3771582784):
            var tmp = new UpdateBotShippingQuery
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1563376297):
            var tmp = new UpdateBotPrecheckoutQuery
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2869914398):
            var tmp = new UpdatePhoneCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1180041828):
            var tmp = new UpdateLangPackTooLong
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1442983757):
            var tmp = new UpdateLangPack
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3843135853):
            var tmp = new UpdateFavedStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2307472197):
            var tmp = new UpdateChannelReadMessagesContents
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1887741886):
            var tmp = new UpdateContactsReset
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1893427255):
            var tmp = new UpdateChannelAvailableMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3781450179):
            var tmp = new UpdateDialogUnreadMark
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2896258427):
            var tmp = new UpdateMessagePoll
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1421875280):
            var tmp = new UpdateChatDefaultBannedRights
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(422972864):
            var tmp = new UpdateFolderPeers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1786671974):
            var tmp = new UpdatePeerSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3031420848):
            var tmp = new UpdatePeerLocated
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(967122427):
            var tmp = new UpdateNewScheduledMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2424728814):
            var tmp = new UpdateDeleteScheduledMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2182544291):
            var tmp = new UpdateTheme
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2267003193):
            var tmp = new UpdateGeoLiveViewed
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1448076945):
            var tmp = new UpdateLoginToken
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1123585836):
            var tmp = new UpdateMessagePollVote
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(654302845):
            var tmp = new UpdateDialogFilter
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2782339333):
            var tmp = new UpdateDialogFilterOrder
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(889491791):
            var tmp = new UpdateDialogFilters
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(643940105):
            var tmp = new UpdatePhoneCallSignalingData
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1708307556):
            var tmp = new UpdateChannelParticipant
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1854571743):
            var tmp = new UpdateChannelMessageForwards
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(482860628):
            var tmp = new UpdateReadChannelDiscussionInbox
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1178116716):
            var tmp = new UpdateReadChannelDiscussionOutbox
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(610945826):
            var tmp = new UpdatePeerBlocked
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4280991391):
            var tmp = new UpdateChannelUserTyping
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3984976565):
            var tmp = new UpdatePinnedMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2240317323):
            var tmp = new UpdatePinnedChannelMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4075543374):
            var tmp = new UpdateGroupCallParticipants
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1462009966):
            var tmp = new UpdateGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2775329342):
            var tmp = new UpdatesState
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1567990072):
            var tmp = new UpdatesDifferenceEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4103905280):
            var tmp = new UpdatesDifference
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2835028353):
            var tmp = new UpdatesDifferenceSlice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1258196845):
            var tmp = new UpdatesDifferenceTooLong
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3809980286):
            var tmp = new UpdatesTooLong
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(580309704):
            var tmp = new UpdateShortMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1076714939):
            var tmp = new UpdateShortChatMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2027216577):
            var tmp = new UpdateShort
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1918567619):
            var tmp = new UpdatesCombined
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1957577280):
            var tmp = new Updates
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(301019932):
            var tmp = new UpdateShortSentMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2378853029):
            var tmp = new PhotosPhotos
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(352657236):
            var tmp = new PhotosPhotosSlice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(539045032):
            var tmp = new PhotosPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2527169872):
            var tmp = new UploadFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4052539972):
            var tmp = new UploadFileCdnRedirect
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(414687501):
            var tmp = new DcOption
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(856375399):
            var tmp = new Config
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2384074613):
            var tmp = new NearestDc
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(497489295):
            var tmp = new HelpAppUpdate
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3294258486):
            var tmp = new HelpNoAppUpdate
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(415997816):
            var tmp = new HelpInviteText
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2877210784):
            var tmp = new EncryptedChatEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1006044124):
            var tmp = new EncryptedChatWaiting
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1651608194):
            var tmp = new EncryptedChatRequested
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4199992886):
            var tmp = new EncryptedChat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(332848423):
            var tmp = new EncryptedChatDiscarded
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4047615457):
            var tmp = new InputEncryptedChat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3256830334):
            var tmp = new EncryptedFileEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1248893260):
            var tmp = new EncryptedFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(406307684):
            var tmp = new InputEncryptedFileEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1690108678):
            var tmp = new InputEncryptedFileUploaded
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1511503333):
            var tmp = new InputEncryptedFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(767652808):
            var tmp = new InputEncryptedFileBigUploaded
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3977822488):
            var tmp = new EncryptedMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(594758406):
            var tmp = new EncryptedMessageService
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3236054581):
            var tmp = new MessagesDhConfigNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(740433629):
            var tmp = new MessagesDhConfig
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1443858741):
            var tmp = new MessagesSentEncryptedMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2492727090):
            var tmp = new MessagesSentEncryptedFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1928391342):
            var tmp = new InputDocumentEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(448771445):
            var tmp = new InputDocument
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(922273905):
            var tmp = new DocumentEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(512177195):
            var tmp = new Document
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(398898678):
            var tmp = new HelpSupport
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2681474008):
            var tmp = new NotifyPeer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3033021260):
            var tmp = new NotifyUsers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3221737155):
            var tmp = new NotifyChats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3591563503):
            var tmp = new NotifyBroadcasts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(381645902):
            var tmp = new SendMessageTypingAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4250847477):
            var tmp = new SendMessageCancelAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2710034031):
            var tmp = new SendMessageRecordVideoAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3916839660):
            var tmp = new SendMessageUploadVideoAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3576656887):
            var tmp = new SendMessageRecordAudioAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4082227115):
            var tmp = new SendMessageUploadAudioAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3520285222):
            var tmp = new SendMessageUploadPhotoAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2852968932):
            var tmp = new SendMessageUploadDocumentAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(393186209):
            var tmp = new SendMessageGeoLocationAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1653390447):
            var tmp = new SendMessageChooseContactAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3714748232):
            var tmp = new SendMessageGamePlayAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2297593788):
            var tmp = new SendMessageRecordRoundAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(608050278):
            var tmp = new SendMessageUploadRoundAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3643548293):
            var tmp = new SpeakingInGroupCallAction
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3004386717):
            var tmp = new ContactsFound
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1335282456):
            var tmp = new InputPrivacyKeyStatusTimestamp
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3187344422):
            var tmp = new InputPrivacyKeyChatInvite
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4206550111):
            var tmp = new InputPrivacyKeyPhoneCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3684593874):
            var tmp = new InputPrivacyKeyPhoneP2P
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2765966344):
            var tmp = new InputPrivacyKeyForwards
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1461304012):
            var tmp = new InputPrivacyKeyProfilePhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(892186528):
            var tmp = new InputPrivacyKeyPhoneNumber
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3508640733):
            var tmp = new InputPrivacyKeyAddedByPhone
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3157175088):
            var tmp = new PrivacyKeyStatusTimestamp
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1343122938):
            var tmp = new PrivacyKeyChatInvite
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1030105979):
            var tmp = new PrivacyKeyPhoneCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(961092808):
            var tmp = new PrivacyKeyPhoneP2P
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1777096355):
            var tmp = new PrivacyKeyForwards
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2517966829):
            var tmp = new PrivacyKeyProfilePhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3516589165):
            var tmp = new PrivacyKeyPhoneNumber
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1124062251):
            var tmp = new PrivacyKeyAddedByPhone
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3500017584):
            var tmp = new InputPrivacyValueAllowContacts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(407582158):
            var tmp = new InputPrivacyValueAllowAll
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(320652927):
            var tmp = new InputPrivacyValueAllowUsers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3125936240):
            var tmp = new InputPrivacyValueDisallowContacts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3597362889):
            var tmp = new InputPrivacyValueDisallowAll
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2417034343):
            var tmp = new InputPrivacyValueDisallowUsers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1283572154):
            var tmp = new InputPrivacyValueAllowChatParticipants
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3626197935):
            var tmp = new InputPrivacyValueDisallowChatParticipants
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4294843308):
            var tmp = new PrivacyValueAllowContacts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1698855810):
            var tmp = new PrivacyValueAllowAll
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1297858060):
            var tmp = new PrivacyValueAllowUsers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4169726490):
            var tmp = new PrivacyValueDisallowContacts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2339628899):
            var tmp = new PrivacyValueDisallowAll
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3354696560):
            var tmp = new PrivacyValueDisallowUsers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(415136107):
            var tmp = new PrivacyValueAllowChatParticipants
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2897086096):
            var tmp = new PrivacyValueDisallowChatParticipants
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1352683077):
            var tmp = new AccountPrivacyRules
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3100684255):
            var tmp = new AccountDaysTTL
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1815593308):
            var tmp = new DocumentAttributeImageSize
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(297109817):
            var tmp = new DocumentAttributeAnimated
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1662637586):
            var tmp = new DocumentAttributeSticker
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4009938528):
            var tmp = new DocumentAttributeVideo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2555574726):
            var tmp = new DocumentAttributeAudio
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(358154344):
            var tmp = new DocumentAttributeFilename
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2550256375):
            var tmp = new DocumentAttributeHasStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4050950690):
            var tmp = new MessagesStickersNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3831077821):
            var tmp = new MessagesStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(313694676):
            var tmp = new StickerPack
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3898999491):
            var tmp = new MessagesAllStickersNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3992797279):
            var tmp = new MessagesAllStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2228326789):
            var tmp = new MessagesAffectedMessages
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3943987176):
            var tmp = new WebPageEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3313949212):
            var tmp = new WebPagePending
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3902555570):
            var tmp = new WebPage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1930545681):
            var tmp = new WebPageNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2902578717):
            var tmp = new Authorization
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(307276766):
            var tmp = new AccountAuthorizations
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2904965624):
            var tmp = new AccountPassword
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2589733861):
            var tmp = new AccountPasswordSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3258394569):
            var tmp = new AccountPasswordInputSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(326715557):
            var tmp = new AuthPasswordRecovery
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2743383929):
            var tmp = new ReceivedNotifyMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1776236393):
            var tmp = new ChatInviteEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4230874556):
            var tmp = new ChatInviteExported
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1516793212):
            var tmp = new ChatInviteAlready
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3754096014):
            var tmp = new ChatInvite
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1634294960):
            var tmp = new ChatInvitePeek
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4290128789):
            var tmp = new InputStickerSetEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2649203305):
            var tmp = new InputStickerSetID
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2250033312):
            var tmp = new InputStickerSetShortName
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(678444160):
            var tmp = new InputStickerSetAnimatedEmoji
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3867103758):
            var tmp = new InputStickerSetDice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4004802343):
            var tmp = new StickerSet
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3054118054):
            var tmp = new MessagesStickerSet
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3262826695):
            var tmp = new BotCommand
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2565348666):
            var tmp = new BotInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2734311552):
            var tmp = new KeyboardButton
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(629866245):
            var tmp = new KeyboardButtonUrl
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(901503851):
            var tmp = new KeyboardButtonCallback
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2976541737):
            var tmp = new KeyboardButtonRequestPhone
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4235815743):
            var tmp = new KeyboardButtonRequestGeoLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1451914368):
            var tmp = new KeyboardButtonSwitchInline
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1358175439):
            var tmp = new KeyboardButtonGame
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2950250427):
            var tmp = new KeyboardButtonBuy
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(280464681):
            var tmp = new KeyboardButtonUrlAuth
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3492708308):
            var tmp = new InputKeyboardButtonUrlAuth
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3150401885):
            var tmp = new KeyboardButtonRequestPoll
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2002815875):
            var tmp = new KeyboardButtonRow
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2688441221):
            var tmp = new ReplyKeyboardHide
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4094724768):
            var tmp = new ReplyKeyboardForceReply
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(889353612):
            var tmp = new ReplyKeyboardMarkup
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1218642516):
            var tmp = new ReplyInlineMarkup
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3146955413):
            var tmp = new MessageEntityUnknown
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4194588573):
            var tmp = new MessageEntityMention
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1868782349):
            var tmp = new MessageEntityHashtag
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1827637959):
            var tmp = new MessageEntityBotCommand
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1859134776):
            var tmp = new MessageEntityUrl
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1692693954):
            var tmp = new MessageEntityEmail
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3177253833):
            var tmp = new MessageEntityBold
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2188348256):
            var tmp = new MessageEntityItalic
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(681706865):
            var tmp = new MessageEntityCode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1938967520):
            var tmp = new MessageEntityPre
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1990644519):
            var tmp = new MessageEntityTextUrl
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(892193368):
            var tmp = new MessageEntityMentionName
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(546203849):
            var tmp = new InputMessageEntityMentionName
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2607407947):
            var tmp = new MessageEntityPhone
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1280209983):
            var tmp = new MessageEntityCashtag
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2622389899):
            var tmp = new MessageEntityUnderline
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3204879316):
            var tmp = new MessageEntityStrike
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(551509248):
            var tmp = new MessageEntityBlockquote
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1981704948):
            var tmp = new MessageEntityBankCard
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4002160262):
            var tmp = new InputChannelEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2951442734):
            var tmp = new InputChannel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(707290417):
            var tmp = new InputChannelFromMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2131196633):
            var tmp = new ContactsResolvedPeer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2922390832):
            var tmp = new MessageRange
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1041346555):
            var tmp = new UpdatesChannelDifferenceEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2763835134):
            var tmp = new UpdatesChannelDifferenceTooLong
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(543450958):
            var tmp = new UpdatesChannelDifference
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2496933607):
            var tmp = new ChannelMessagesFilterEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3447183703):
            var tmp = new ChannelMessagesFilter
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(367766557):
            var tmp = new ChannelParticipant
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2737347181):
            var tmp = new ChannelParticipantSelf
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1149094475):
            var tmp = new ChannelParticipantCreator
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3435051951):
            var tmp = new ChannelParticipantAdmin
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(470789295):
            var tmp = new ChannelParticipantBanned
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3284564331):
            var tmp = new ChannelParticipantLeft
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3728686201):
            var tmp = new ChannelParticipantsRecent
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3026225513):
            var tmp = new ChannelParticipantsAdmins
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2746567045):
            var tmp = new ChannelParticipantsKicked
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2966521435):
            var tmp = new ChannelParticipantsBots
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(338142689):
            var tmp = new ChannelParticipantsBanned
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1701495984):
            var tmp = new ChannelParticipantsSearch
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3144345741):
            var tmp = new ChannelParticipantsContacts
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3763035371):
            var tmp = new ChannelParticipantsMentions
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4117684904):
            var tmp = new ChannelsChannelParticipants
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4028055529):
            var tmp = new ChannelsChannelParticipantsNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3503927651):
            var tmp = new ChannelsChannelParticipant
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2013922064):
            var tmp = new HelpTermsOfService
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3892468898):
            var tmp = new MessagesSavedGifsNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(772213157):
            var tmp = new MessagesSavedGifs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(864077702):
            var tmp = new InputBotInlineMessageMediaAuto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1036876423):
            var tmp = new InputBotInlineMessageText
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2526190213):
            var tmp = new InputBotInlineMessageMediaGeo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1098628881):
            var tmp = new InputBotInlineMessageMediaVenue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2800599037):
            var tmp = new InputBotInlineMessageMediaContact
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1262639204):
            var tmp = new InputBotInlineMessageGame
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2294256409):
            var tmp = new InputBotInlineResult
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2832753831):
            var tmp = new InputBotInlineResultPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4294507972):
            var tmp = new InputBotInlineResultDocument
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1336154098):
            var tmp = new InputBotInlineResultGame
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1984755728):
            var tmp = new BotInlineMessageMediaAuto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2357159394):
            var tmp = new BotInlineMessageText
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1367633872):
            var tmp = new BotInlineMessageMediaGeo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2324063644):
            var tmp = new BotInlineMessageMediaVenue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(416402882):
            var tmp = new BotInlineMessageMediaContact
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(295067450):
            var tmp = new BotInlineResult
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(400266251):
            var tmp = new BotInlineMediaResult
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2491197512):
            var tmp = new MessagesBotResults
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1571494644):
            var tmp = new ExportedMessageLink
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1601666510):
            var tmp = new MessageFwdHeader
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1923290508):
            var tmp = new AuthCodeTypeSms
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1948046307):
            var tmp = new AuthCodeTypeCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(577556219):
            var tmp = new AuthCodeTypeFlashCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1035688326):
            var tmp = new AuthSentCodeTypeApp
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3221273506):
            var tmp = new AuthSentCodeTypeSms
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1398007207):
            var tmp = new AuthSentCodeTypeCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2869151449):
            var tmp = new AuthSentCodeTypeFlashCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(911761060):
            var tmp = new MessagesBotCallbackAnswer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(649453030):
            var tmp = new MessagesMessageEditData
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2299280777):
            var tmp = new InputBotInlineMessageID
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1008755359):
            var tmp = new InlineBotSwitchPM
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(863093588):
            var tmp = new MessagesPeerDialogs
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3989684315):
            var tmp = new TopPeer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2875595611):
            var tmp = new TopPeerCategoryBotsPM
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(344356834):
            var tmp = new TopPeerCategoryBotsInline
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1669037776):
            var tmp = new TopPeerCategoryCorrespondents
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3172442442):
            var tmp = new TopPeerCategoryGroups
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(371037736):
            var tmp = new TopPeerCategoryChannels
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(511092620):
            var tmp = new TopPeerCategoryPhoneCalls
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2822794409):
            var tmp = new TopPeerCategoryForwardUsers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4226728176):
            var tmp = new TopPeerCategoryForwardChats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4219683473):
            var tmp = new TopPeerCategoryPeers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3727060725):
            var tmp = new ContactsTopPeersNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1891070632):
            var tmp = new ContactsTopPeers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3039597469):
            var tmp = new ContactsTopPeersDisabled
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(453805082):
            var tmp = new DraftMessageEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4253970719):
            var tmp = new DraftMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3336309862):
            var tmp = new MessagesFeaturedStickersNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3064709953):
            var tmp = new MessagesFeaturedStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2977925376):
            var tmp = new MessagesRecentStickersNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(586395571):
            var tmp = new MessagesRecentStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1338747336):
            var tmp = new MessagesArchivedStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(946083368):
            var tmp = new MessagesStickerSetInstallResultSuccess
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(904138920):
            var tmp = new MessagesStickerSetInstallResultArchive
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1678812626):
            var tmp = new StickerSetCovered
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(872932635):
            var tmp = new StickerSetMultiCovered
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2933316530):
            var tmp = new MaskCoords
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1251549527):
            var tmp = new InputStickeredMediaPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1133012400):
            var tmp = new InputStickeredMediaDocument
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3187238203):
            var tmp = new Game
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(851699568):
            var tmp = new InputGameID
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3274827786):
            var tmp = new InputGameShortName
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1493171408):
            var tmp = new HighScore
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2587622809):
            var tmp = new MessagesHighScores
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3695018575):
            var tmp = new TextEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1950782688):
            var tmp = new TextPlain
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1730456516):
            var tmp = new TextBold
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3641877916):
            var tmp = new TextItalic
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3240501956):
            var tmp = new TextUnderline
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2616769429):
            var tmp = new TextStrike
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1816074681):
            var tmp = new TextFixed
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1009288385):
            var tmp = new TextUrl
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3730443734):
            var tmp = new TextEmail
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2120376535):
            var tmp = new TextConcat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3983181060):
            var tmp = new TextSubscript
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3355139585):
            var tmp = new TextSuperscript
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(884498960):
            var tmp = new TextMarked
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(483104362):
            var tmp = new TextPhone
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2177692912):
            var tmp = new TextImage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(894777186):
            var tmp = new TextAnchor
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(324435594):
            var tmp = new PageBlockUnsupported
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1890305021):
            var tmp = new PageBlockTitle
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2415565343):
            var tmp = new PageBlockSubtitle
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3132089824):
            var tmp = new PageBlockAuthorDate
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3218105580):
            var tmp = new PageBlockHeader
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4046173921):
            var tmp = new PageBlockSubheader
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1182402406):
            var tmp = new PageBlockParagraph
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3228621118):
            var tmp = new PageBlockPreformatted
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1216809369):
            var tmp = new PageBlockFooter
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3676352904):
            var tmp = new PageBlockDivider
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3456972720):
            var tmp = new PageBlockAnchor
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3840442385):
            var tmp = new PageBlockList
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(641563686):
            var tmp = new PageBlockBlockquote
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1329878739):
            var tmp = new PageBlockPullquote
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(391759200):
            var tmp = new PageBlockPhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2089805750):
            var tmp = new PageBlockVideo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(972174080):
            var tmp = new PageBlockCover
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2826014149):
            var tmp = new PageBlockEmbed
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4065961995):
            var tmp = new PageBlockEmbedPost
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1705048653):
            var tmp = new PageBlockCollage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(838424832):
            var tmp = new PageBlockSlideshow
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4011282869):
            var tmp = new PageBlockChannel
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2151899626):
            var tmp = new PageBlockAudio
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(504660880):
            var tmp = new PageBlockKicker
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3209554562):
            var tmp = new PageBlockTable
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2592793057):
            var tmp = new PageBlockOrderedList
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1987480557):
            var tmp = new PageBlockDetails
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(370236054):
            var tmp = new PageBlockRelatedArticles
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2756656886):
            var tmp = new PageBlockMap
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2246320897):
            var tmp = new PhoneCallDiscardReasonMissed
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3767910816):
            var tmp = new PhoneCallDiscardReasonDisconnect
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1471006352):
            var tmp = new PhoneCallDiscardReasonHangup
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4210550985):
            var tmp = new PhoneCallDiscardReasonBusy
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2104790276):
            var tmp = new DataJSON
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3408489464):
            var tmp = new LabeledPrice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3272254296):
            var tmp = new Invoice
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3926049406):
            var tmp = new PaymentCharge
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(512535275):
            var tmp = new PostAddress
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2426158996):
            var tmp = new PaymentRequestedInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3452074527):
            var tmp = new PaymentSavedCredentialsCard
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(475467473):
            var tmp = new WebDocument
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4190682310):
            var tmp = new WebDocumentNoProxy
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2616017741):
            var tmp = new InputWebDocument
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3258570374):
            var tmp = new InputWebFileLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2669814217):
            var tmp = new InputWebFileGeoPointLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(568808380):
            var tmp = new UploadWebFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1062645411):
            var tmp = new PaymentsPaymentForm
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3510966403):
            var tmp = new PaymentsValidatedRequestedInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1314881805):
            var tmp = new PaymentsPaymentResult
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3628142905):
            var tmp = new PaymentsPaymentVerificationNeeded
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1342771681):
            var tmp = new PaymentsPaymentReceipt
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4220511292):
            var tmp = new PaymentsSavedInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3238965967):
            var tmp = new InputPaymentCredentialsSaved
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(873977640):
            var tmp = new InputPaymentCredentials
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2853976560):
            var tmp = new InputPaymentCredentialsApplePay
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3389379854):
            var tmp = new InputPaymentCredentialsAndroidPay
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3680828724):
            var tmp = new AccountTmpPassword
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3055631583):
            var tmp = new ShippingOption
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4288717974):
            var tmp = new InputStickerSetItem
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(506920429):
            var tmp = new InputPhoneCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1399245077):
            var tmp = new PhoneCallEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(462375633):
            var tmp = new PhoneCallWaiting
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2280307539):
            var tmp = new PhoneCallRequested
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2575058250):
            var tmp = new PhoneCallAccepted
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2269294207):
            var tmp = new PhoneCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1355435489):
            var tmp = new PhoneCallDiscarded
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2639009728):
            var tmp = new PhoneConnection
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1667228533):
            var tmp = new PhoneConnectionWebrtc
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4236742600):
            var tmp = new PhoneCallProtocol
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3968000320):
            var tmp = new PhonePhoneCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4004045934):
            var tmp = new UploadCdnFileReuploadNeeded
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2845821519):
            var tmp = new UploadCdnFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3380800186):
            var tmp = new CdnPublicKey
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1462101002):
            var tmp = new CdnConfig
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3402727926):
            var tmp = new LangPackString
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1816636575):
            var tmp = new LangPackStringPluralized
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(695856818):
            var tmp = new LangPackStringDeleted
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4085629430):
            var tmp = new LangPackDifference
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4006239459):
            var tmp = new LangPackLanguage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3873421349):
            var tmp = new ChannelAdminLogEventActionChangeTitle
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1427671598):
            var tmp = new ChannelAdminLogEventActionChangeAbout
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1783299128):
            var tmp = new ChannelAdminLogEventActionChangeUsername
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1129042607):
            var tmp = new ChannelAdminLogEventActionChangePhoto
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(460916654):
            var tmp = new ChannelAdminLogEventActionToggleInvites
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(648939889):
            var tmp = new ChannelAdminLogEventActionToggleSignatures
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3924306968):
            var tmp = new ChannelAdminLogEventActionUpdatePinned
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1889215493):
            var tmp = new ChannelAdminLogEventActionEditMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1121994683):
            var tmp = new ChannelAdminLogEventActionDeleteMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(405815507):
            var tmp = new ChannelAdminLogEventActionParticipantJoin
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4170676210):
            var tmp = new ChannelAdminLogEventActionParticipantLeave
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3810276568):
            var tmp = new ChannelAdminLogEventActionParticipantInvite
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3872931198):
            var tmp = new ChannelAdminLogEventActionParticipantToggleBan
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3580323600):
            var tmp = new ChannelAdminLogEventActionParticipantToggleAdmin
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2982398631):
            var tmp = new ChannelAdminLogEventActionChangeStickerSet
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1599903217):
            var tmp = new ChannelAdminLogEventActionTogglePreHistoryHidden
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(771095562):
            var tmp = new ChannelAdminLogEventActionDefaultBannedRights
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2399639107):
            var tmp = new ChannelAdminLogEventActionStopPoll
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2725218331):
            var tmp = new ChannelAdminLogEventActionChangeLinkedChat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3870780128):
            var tmp = new ChannelAdminLogEventActionChangeLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1401984889):
            var tmp = new ChannelAdminLogEventActionToggleSlowMode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(589338437):
            var tmp = new ChannelAdminLogEventActionStartGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3684667712):
            var tmp = new ChannelAdminLogEventActionDiscardGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4179895506):
            var tmp = new ChannelAdminLogEventActionParticipantMute
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3863226816):
            var tmp = new ChannelAdminLogEventActionParticipantUnmute
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1456906823):
            var tmp = new ChannelAdminLogEventActionToggleGroupCallSetting
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(995769920):
            var tmp = new ChannelAdminLogEvent
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3985307469):
            var tmp = new ChannelsAdminLogResults
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3926948580):
            var tmp = new ChannelAdminLogEventsFilter
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1558266229):
            var tmp = new PopularContact
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2660214483):
            var tmp = new MessagesFavedStickersNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4085198614):
            var tmp = new MessagesFavedStickers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1189204285):
            var tmp = new RecentMeUrlUnknown
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2377921334):
            var tmp = new RecentMeUrlUser
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2686132985):
            var tmp = new RecentMeUrlChat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3947431965):
            var tmp = new RecentMeUrlChatInvite
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3154794460):
            var tmp = new RecentMeUrlStickerSet
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3761311088):
            var tmp = new HelpRecentMeUrls
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(482797855):
            var tmp = new InputSingleMedia
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3402187762):
            var tmp = new WebAuthorization
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3981887996):
            var tmp = new AccountWebAuthorizations
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2792792866):
            var tmp = new InputMessageID
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3134751637):
            var tmp = new InputMessageReplyTo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2257003832):
            var tmp = new InputMessagePinned
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2902071934):
            var tmp = new InputMessageCallbackQuery
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4239064759):
            var tmp = new InputDialogPeer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1684014375):
            var tmp = new InputDialogPeerFolder
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3849174789):
            var tmp = new DialogPeer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1363483106):
            var tmp = new DialogPeerFolder
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3578488272):
            var tmp = new MessagesFoundStickerSetsNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1359533640):
            var tmp = new MessagesFoundStickerSets
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1648543603):
            var tmp = new FileHash
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1968737087):
            var tmp = new InputClientProxy
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3811614591):
            var tmp = new HelpTermsOfServiceUpdateEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(686618977):
            var tmp = new HelpTermsOfServiceUpdate
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(859091184):
            var tmp = new InputSecureFileUploaded
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1399317950):
            var tmp = new InputSecureFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1679398724):
            var tmp = new SecureFileEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3760683618):
            var tmp = new SecureFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2330640067):
            var tmp = new SecureData
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2103482845):
            var tmp = new SecurePlainPhone
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(569137759):
            var tmp = new SecurePlainEmail
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2636808675):
            var tmp = new SecureValueTypePersonalDetails
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1034709504):
            var tmp = new SecureValueTypePassport
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1849842752):
            var tmp = new SecureValueTypeDriverLicense
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2698015819):
            var tmp = new SecureValueTypeIdentityCard
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2577698595):
            var tmp = new SecureValueTypeInternalPassport
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3420659238):
            var tmp = new SecureValueTypeAddress
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4231435598):
            var tmp = new SecureValueTypeUtilityBill
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2299755533):
            var tmp = new SecureValueTypeBankStatement
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2340959368):
            var tmp = new SecureValueTypeRentalAgreement
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2581823594):
            var tmp = new SecureValueTypePassportRegistration
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3926060083):
            var tmp = new SecureValueTypeTemporaryRegistration
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3005262555):
            var tmp = new SecureValueTypePhone
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2386339822):
            var tmp = new SecureValueTypeEmail
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(411017418):
            var tmp = new SecureValue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3676426407):
            var tmp = new InputSecureValue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3978218928):
            var tmp = new SecureValueHash
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3903065049):
            var tmp = new SecureValueErrorData
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3191732736):
            var tmp = new SecureValueErrorFrontSide
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2257201829):
            var tmp = new SecureValueErrorReverseSide
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3845639894):
            var tmp = new SecureValueErrorSelfie
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2054162547):
            var tmp = new SecureValueErrorFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1717706985):
            var tmp = new SecureValueErrorFiles
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2258466191):
            var tmp = new SecureValueError
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2702460784):
            var tmp = new SecureValueErrorTranslationFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(878931416):
            var tmp = new SecureValueErrorTranslationFiles
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(871426631):
            var tmp = new SecureCredentialsEncrypted
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2905480408):
            var tmp = new AccountAuthorizationForm
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2166326607):
            var tmp = new AccountSentEmailCode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1722786150):
            var tmp = new HelpDeepLinkInfoEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1783556146):
            var tmp = new HelpDeepLinkInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(289586518):
            var tmp = new SavedPhoneContact
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1304052993):
            var tmp = new AccountTakeout
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3562713238):
            var tmp = new PasswordKdfAlgoUnknown
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(982592842):
            var tmp = new PasswordKdfAlgoSHA256SHA256PBKDF2HMACSHA512iter100000SHA256ModPow
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1250244352):
            var tmp = new SecurePasswordKdfAlgoUnknown
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3153255840):
            var tmp = new SecurePasswordKdfAlgoPBKDF2HMACSHA512iter100000
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2252807570):
            var tmp = new SecurePasswordKdfAlgoSHA512
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(354925740):
            var tmp = new SecureSecretSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2558588504):
            var tmp = new InputCheckPasswordEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3531600002):
            var tmp = new InputCheckPasswordSRP
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2191366618):
            var tmp = new SecureRequiredType
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(658996032):
            var tmp = new SecureRequiredTypeOneOf
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3216634967):
            var tmp = new HelpPassportConfigNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2694370991):
            var tmp = new HelpPassportConfig
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(488313413):
            var tmp = new InputAppEvent
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3235781593):
            var tmp = new JsonObjectValue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1064139624):
            var tmp = new JsonNull
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3342098026):
            var tmp = new JsonBool
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(736157604):
            var tmp = new JsonNumber
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3072226938):
            var tmp = new JsonString
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4148447075):
            var tmp = new JsonArray
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2579616925):
            var tmp = new JsonObject
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(878078826):
            var tmp = new PageTableCell
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3770729957):
            var tmp = new PageTableRow
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1869903447):
            var tmp = new PageCaption
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3106911949):
            var tmp = new PageListItemText
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(635466748):
            var tmp = new PageListItemBlocks
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1577484359):
            var tmp = new PageListOrderedItemText
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2564655414):
            var tmp = new PageListOrderedItemBlocks
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3012615176):
            var tmp = new PageRelatedArticle
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2556788493):
            var tmp = new Page
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2349199817):
            var tmp = new HelpSupportName
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4088278765):
            var tmp = new HelpUserInfoEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(515077504):
            var tmp = new HelpUserInfo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1823064809):
            var tmp = new PollAnswer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2262925665):
            var tmp = new Poll
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(997055186):
            var tmp = new PollAnswerVoters
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3135029667):
            var tmp = new PollResults
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4030849616):
            var tmp = new ChatOnlines
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1202287072):
            var tmp = new StatsURL
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1605510357):
            var tmp = new ChatAdminRights
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2668758040):
            var tmp = new ChatBannedRights
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3861952889):
            var tmp = new InputWallPaper
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1913199744):
            var tmp = new InputWallPaperSlug
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2217196460):
            var tmp = new InputWallPaperNoFile
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(471437699):
            var tmp = new AccountWallPapersNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1881892265):
            var tmp = new AccountWallPapers
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3737042563):
            var tmp = new CodeSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1351012224):
            var tmp = new WallPaperSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3762434803):
            var tmp = new AutoDownloadSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1674235686):
            var tmp = new AccountAutoDownloadSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3585325561):
            var tmp = new EmojiKeyword
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(594408994):
            var tmp = new EmojiKeywordDeleted
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1556570557):
            var tmp = new EmojiKeywordsDifference
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2775937949):
            var tmp = new EmojiURL
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3019592545):
            var tmp = new EmojiLanguage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3162490573):
            var tmp = new FileLocationToBeDeprecated
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4283715173):
            var tmp = new Folder
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4224893590):
            var tmp = new InputFolderPeer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3921323624):
            var tmp = new FolderPeer
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3896830975):
            var tmp = new MessagesSearchCounter
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2463316494):
            var tmp = new UrlAuthResultRequest
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2408320590):
            var tmp = new UrlAuthResultAccepted
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2849430303):
            var tmp = new UrlAuthResultDefault
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3216354699):
            var tmp = new ChannelLocationEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(547062491):
            var tmp = new ChannelLocation
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3393592157):
            var tmp = new PeerLocated
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4176226379):
            var tmp = new PeerSelfLocated
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3497176244):
            var tmp = new RestrictionReason
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1012306921):
            var tmp = new InputTheme
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4119399921):
            var tmp = new InputThemeSlug
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(686887232):
            var tmp = new Theme
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4095653410):
            var tmp = new AccountThemesNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2137482273):
            var tmp = new AccountThemes
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1654593920):
            var tmp = new AuthLoginToken
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1760137568):
            var tmp = new AuthLoginTokenMigrateTo
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(957176926):
            var tmp = new AuthLoginTokenSuccess
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1474462241):
            var tmp = new AccountContentSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2837970629):
            var tmp = new MessagesInactiveChats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3282117730):
            var tmp = new BaseThemeClassic
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4225242760):
            var tmp = new BaseThemeDay
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3081969320):
            var tmp = new BaseThemeNight
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1834973166):
            var tmp = new BaseThemeTinted
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1527845466):
            var tmp = new BaseThemeArctic
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3176168657):
            var tmp = new InputThemeSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2618595402):
            var tmp = new ThemeSettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1421174295):
            var tmp = new WebPageAttributeTheme
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2727236953):
            var tmp = new MessageUserVote
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(909603888):
            var tmp = new MessageUserVoteInputOption
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3908963808):
            var tmp = new MessageUserVoteMultiple
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2185192592):
            var tmp = new MessagesVotesList
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4117234314):
            var tmp = new BankCardOpenUrl
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1042605427):
            var tmp = new PaymentsBankCardData
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1949890536):
            var tmp = new DialogFilter
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2004110666):
            var tmp = new DialogFilterSuggested
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3057118639):
            var tmp = new StatsDateRangeDays
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3410210014):
            var tmp = new StatsAbsValueAndPrev
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3419287520):
            var tmp = new StatsPercentValue
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1244130093):
            var tmp = new StatsGraphAsync
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3202127906):
            var tmp = new StatsGraphError
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2393138358):
            var tmp = new StatsGraph
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2907687357):
            var tmp = new MessageInteractionCounters
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3187114900):
            var tmp = new StatsBroadcastStats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2566302837):
            var tmp = new HelpPromoDataEmpty
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2352576831):
            var tmp = new HelpPromoData
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3895575894):
            var tmp = new VideoSize
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(418631927):
            var tmp = new StatsGroupTopPoster
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1611985938):
            var tmp = new StatsGroupTopAdmin
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(831924812):
            var tmp = new StatsGroupTopInviter
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4018141462):
            var tmp = new StatsMegagroupStats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3198350372):
            var tmp = new GlobalPrivacySettings
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1107543535):
            var tmp = new HelpCountryCode
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3280440867):
            var tmp = new HelpCountry
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2479628082):
            var tmp = new HelpCountriesListNotModified
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2278585758):
            var tmp = new HelpCountriesList
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1163625789):
            var tmp = new MessageViews
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3066361155):
            var tmp = new MessagesMessageViews
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(4124938141):
            var tmp = new MessagesDiscussionMessage
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2799007587):
            var tmp = new MessageReplyHeader
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1093204652):
            var tmp = new MessageReplies
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3908927508):
            var tmp = new PeerBlocked
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2308567701):
            var tmp = new StatsMessageStats
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2004925620):
            var tmp = new GroupCallDiscarded
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1435512961):
            var tmp = new GroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3635053583):
            var tmp = new InputGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1454409673):
            var tmp = new GroupCallParticipant
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1722485756):
            var tmp = new PhoneGroupCall
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2633939245):
            var tmp = new PhoneGroupParticipants
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(813821341):
            var tmp = new InlineQueryPeerTypeSameBotPM
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(2201751468):
            var tmp = new InlineQueryPeerTypePM
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(3613836554):
            var tmp = new InlineQueryPeerTypeChat
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1589952067):
            var tmp = new InlineQueryPeerTypeMegagroup
            tmp.TLDecode(bytes)
            self = tmp
            return
        of uint32(1664413338):
            var tmp = new InlineQueryPeerTypeBroadcast
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
            raise newException(Exception, &"Key {id} was not found")