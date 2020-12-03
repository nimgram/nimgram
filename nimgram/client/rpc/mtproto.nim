import stint
import tables
import bitops
import strutils
import stew/endians2
import options
import api
import decoding
import zippy

import encoding
#Do not regenerate this file using the TL Parser, it is meant to be static
type
#    TL* = ref object of RootObj

#    TLObject* = ref object of TL

    ResPQI* = ref object of TLObject

    P_Q_inner_dataI* = ref object of TLObject

    Server_DH_ParamsI* = ref object of TLObject

    Server_DH_inner_dataI* = ref object of TLObject

    Client_DH_Inner_DataI* = ref object of TLObject

    Set_client_DH_params_answerI* = ref object of TLObject

    RpcResultI* = ref object of TLObject

    RpcErrorI* = ref object of TLObject

    RpcDropAnswerI* = ref object of TLObject

    PongI* = ref object of TLObject

    DestroySessionResI* = ref object of TLObject

    NewSessionI* = ref object of TLObject

    MsgsAckI* = ref object of TLObject

    BadMsgNotificationI* = ref object of TLObject

    MsgResendReqI* = ref object of TLObject

    MsgsStateReqI* = ref object of TLObject

    MsgsStateInfoI* = ref object of TLObject

    MsgsAllInfoI* = ref object of TLObject

    MsgDetailedInfoI* = ref object of TLObject

    resPQ* = ref object of ResPQI
        nonce*: Int128
        server_nonce*: Int128
        pq*: seq[uint8]
        server_public_key_fingerprints*: seq[int64]

    p_q_inner_data* = ref object of P_Q_inner_dataI
        pq*: seq[uint8]
        p*: seq[uint8]
        q*: seq[uint8]
        nonce*: Int128
        server_nonce*: Int128
        new_nonce*: Int256

    server_DH_params_fail* = ref object of Server_DH_ParamsI
        nonce*: Int128
        server_nonce*: Int128
        new_nonce_hash*: Int128

    server_DH_params_ok* = ref object of Server_DH_ParamsI
        nonce*: Int128
        server_nonce*: Int128
        encrypted_answer*: seq[uint8]

    server_DH_inner_data* = ref object of Server_DH_inner_dataI
        nonce*: Int128
        server_nonce*: Int128
        g*: int32
        dh_prime*: seq[uint8]
        g_a*: seq[uint8]
        server_time*: int32

    client_DH_inner_data* = ref object of Client_DH_Inner_DataI
        nonce*: Int128
        server_nonce*: Int128
        retry_id*: int64
        g_b*: seq[uint8]

    dh_gen_ok* = ref object of Set_client_DH_params_answerI
        nonce*: Int128
        server_nonce*: Int128
        new_nonce_hash1*: Int128

    dh_gen_retry* = ref object of Set_client_DH_params_answerI
        nonce*: Int128
        server_nonce*: Int128
        new_nonce_hash2*: Int128

    dh_gen_fail* = ref object of Set_client_DH_params_answerI
        nonce*: Int128
        server_nonce*: Int128
        new_nonce_hash3*: Int128

    rpc_result* = ref object of RpcResultI
        req_msg_id*: int64
        result*: TLObject

    rpc_error* = ref object of RpcErrorI
        error_code*: int32
        error_message*: string

    rpc_answer_unknown* = ref object of RpcDropAnswerI

    rpc_answer_dropped_running* = ref object of RpcDropAnswerI

    rpc_answer_dropped* = ref object of RpcDropAnswerI
        msg_id*: int64
        seq_no*: int32
        bytes*: int32

    pong* = ref object of PongI
        msg_id*: int64
        ping_id*: int64

    destroy_session_ok* = ref object of DestroySessionResI
        session_id*: int64

    destroy_session_none* = ref object of DestroySessionResI
        session_id*: int64

    new_session_created* = ref object of NewSessionI
        first_msg_id*: int64
        unique_id*: int64
        server_salt*: int64

    msgs_ack* = ref object of MsgsAckI
        msg_ids*: seq[int64]

    bad_msg_notification* = ref object of BadMsgNotificationI
        bad_msg_id*: int64
        bad_msg_seqno*: int32
        error_code*: int32

    bad_server_salt* = ref object of BadMsgNotificationI
        bad_msg_id*: int64
        bad_msg_seqno*: int32
        error_code*: int32
        new_server_salt*: int64

    msg_resend_req* = ref object of MsgResendReqI
        msg_ids*: seq[int64]

    msgs_state_req* = ref object of MsgsStateReqI
        msg_ids*: seq[int64]

    msgs_state_info* = ref object of MsgsStateInfoI
        req_msg_id*: int64
        info*: seq[uint8]

    msgs_all_info* = ref object of MsgsAllInfoI
        msg_ids*: seq[int64]
        info*: seq[uint8]

    msg_detailed_info* = ref object of MsgDetailedInfoI
        msg_id*: int64
        answer_msg_id*: int64
        bytes*: int32
        status*: int32

    msg_new_detailed_info* = ref object of MsgDetailedInfoI
        answer_msg_id*: int64
        bytes*: int32
        status*: int32

    GZipPacked* = ref object of TLObject
        data*: seq[uint8]


proc TLDecode*(self: var        ScalingSeq[uint8], obj: dh_gen_ok)

proc TLEncodeType*(obj: dh_gen_ok): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: dh_gen_retry)

proc TLEncodeType*(obj: dh_gen_retry): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: dh_gen_fail)

proc TLEncodeType*(obj: dh_gen_fail): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: destroy_session_ok)

proc TLEncodeType*(obj: destroy_session_ok): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: destroy_session_none)

proc TLEncodeType*(obj: destroy_session_none): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: msgs_state_req)

proc TLEncodeType*(obj: msgs_state_req): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: pong)

proc TLEncodeType*(obj: pong): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: server_DH_params_fail)

proc TLEncodeType*(obj: server_DH_params_fail): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: server_DH_params_ok)

proc TLEncodeType*(obj: server_DH_params_ok): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: msgs_state_info)

proc TLEncodeType*(obj: msgs_state_info): seq[uint8]

proc TLEncodeType*(unpackedData: GZipPacked): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: msg_detailed_info)

proc TLEncodeType*(obj: msg_detailed_info): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: msg_new_detailed_info)

proc TLEncodeType*(obj: msg_new_detailed_info): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: msgs_ack)

proc TLEncodeType*(obj: msgs_ack): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: client_DH_inner_data)

proc TLEncodeType*(obj: client_DH_inner_data): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: p_q_inner_data)

proc TLEncodeType*(obj: p_q_inner_data): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: rpc_answer_unknown)

proc TLEncodeType*(obj: rpc_answer_unknown): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: rpc_answer_dropped_running)

proc TLEncodeType*(obj: rpc_answer_dropped_running): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: rpc_answer_dropped)

proc TLEncodeType*(obj: rpc_answer_dropped): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: msg_resend_req)

proc TLEncodeType*(obj: msg_resend_req): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: rpc_result)

proc TLEncodeType*(obj: rpc_result): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: server_DH_inner_data)

proc TLEncodeType*(obj: server_DH_inner_data): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: rpc_error)

proc TLEncodeType*(obj: rpc_error): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: resPQ)

proc TLEncodeType*(obj: resPQ): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: new_session_created)

proc TLEncodeType*(obj: new_session_created): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: bad_msg_notification)

proc TLEncodeType*(obj: bad_msg_notification): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: bad_server_salt)

proc TLEncodeType*(obj: bad_server_salt): seq[uint8]

proc TLDecode*(self: var ScalingSeq[uint8], obj: msgs_all_info)

proc TLDecode*(self: var ScalingSeq[uint8], unpackedData: GZipPacked) 

proc TLEncodeType*(obj: msgs_all_info): seq[uint8]



proc TLEncode*(obj: Set_client_DH_params_answerI): seq[uint8] = 
    if obj of dh_gen_ok:
        return cast[dh_gen_ok](obj).TLEncodeType()
    if obj of dh_gen_retry:
        return cast[dh_gen_retry](obj).TLEncodeType()
    if obj of dh_gen_fail:
        return cast[dh_gen_fail](obj).TLEncodeType()

proc TLEncode*(obj: DestroySessionResI): seq[uint8] = 
    if obj of destroy_session_ok:
        return cast[destroy_session_ok](obj).TLEncodeType()
    if obj of destroy_session_none:
        return cast[destroy_session_none](obj).TLEncodeType()

proc TLEncode*(obj: MsgsStateReqI): seq[uint8] = 
    if obj of msgs_state_req:
        return cast[msgs_state_req](obj).TLEncodeType()

proc TLEncode*(obj: PongI): seq[uint8] = 
    if obj of pong:
        return cast[pong](obj).TLEncodeType()

proc TLEncode*(obj: Server_DH_ParamsI): seq[uint8] = 
    if obj of server_DH_params_fail:
        return cast[server_DH_params_fail](obj).TLEncodeType()
    if obj of server_DH_params_ok:
        return cast[server_DH_params_ok](obj).TLEncodeType()

proc TLEncode*(obj: MsgsStateInfoI): seq[uint8] = 
    if obj of msgs_state_info:
        return cast[msgs_state_info](obj).TLEncodeType()

proc TLEncode*(obj: MsgDetailedInfoI): seq[uint8] = 
    if obj of msg_detailed_info:
        return cast[msg_detailed_info](obj).TLEncodeType()
    if obj of msg_new_detailed_info:
        return cast[msg_new_detailed_info](obj).TLEncodeType()

proc TLEncode*(obj: MsgsAckI): seq[uint8] = 
    if obj of msgs_ack:
        return cast[msgs_ack](obj).TLEncodeType()

proc TLEncode*(obj: Client_DH_Inner_DataI): seq[uint8] = 
    if obj of client_DH_inner_data:
        return cast[client_DH_inner_data](obj).TLEncodeType()

proc TLEncode*(obj: P_Q_inner_dataI): seq[uint8] = 
    if obj of p_q_inner_data:
        return cast[p_q_inner_data](obj).TLEncodeType()

proc TLEncode*(obj: RpcDropAnswerI): seq[uint8] = 
    if obj of rpc_answer_unknown:
        return cast[rpc_answer_unknown](obj).TLEncodeType()
    if obj of rpc_answer_dropped_running:
        return cast[rpc_answer_dropped_running](obj).TLEncodeType()
    if obj of rpc_answer_dropped:
        return cast[rpc_answer_dropped](obj).TLEncodeType()

proc TLEncode*(obj: MsgResendReqI): seq[uint8] = 
    if obj of msg_resend_req:
        return cast[msg_resend_req](obj).TLEncodeType()

proc TLEncode*(obj: RpcResultI): seq[uint8] = 
    if obj of rpc_result:
        return cast[rpc_result](obj).TLEncodeType()

proc TLEncode*(obj: Server_DH_inner_dataI): seq[uint8] = 
    if obj of server_DH_inner_data:
        return cast[server_DH_inner_data](obj).TLEncodeType()

proc TLEncode*(obj: RpcErrorI): seq[uint8] = 
    if obj of rpc_error:
        return cast[rpc_error](obj).TLEncodeType()

proc TLEncode*(obj: ResPQI): seq[uint8] = 
    if obj of resPQ:
        return cast[resPQ](obj).TLEncodeType()

proc TLEncode*(obj: NewSessionI): seq[uint8] = 
    if obj of new_session_created:
        return cast[new_session_created](obj).TLEncodeType()

proc TLEncode*(obj: BadMsgNotificationI): seq[uint8] = 
    if obj of bad_msg_notification:
        return cast[bad_msg_notification](obj).TLEncodeType()
    if obj of bad_server_salt:
        return cast[bad_server_salt](obj).TLEncodeType()

proc TLEncode*(obj: MsgsAllInfoI): seq[uint8] = 
    if obj of msgs_all_info:
        return cast[msgs_all_info](obj).TLEncodeType()


proc TLEncode*(obj: seq[Set_client_DH_params_answerI]): seq[uint8] =
    result = TLEncode(int32(481674261))
    result = result & TLEncode(int32(len(obj)))
    for objs in obj:
        if objs of dh_gen_ok:
            result = result & cast[dh_gen_ok](objs).TLEncode()
        if objs of dh_gen_retry:
            result = result & cast[dh_gen_retry](objs).TLEncode()
        if objs of dh_gen_fail:
            result = result & cast[dh_gen_fail](objs).TLEncode()

proc TLEncode*(obj: seq[DestroySessionResI]): seq[uint8] =
    result = TLEncode(int32(481674261))
    result = result & TLEncode(int32(len(obj)))
    for objs in obj:
        if objs of destroy_session_ok:
            result = result & cast[destroy_session_ok](objs).TLEncode()
        if objs of destroy_session_none:
            result = result & cast[destroy_session_none](objs).TLEncode()

proc TLEncode*(obj: seq[MsgsStateReqI]): seq[uint8] =
    result = TLEncode(int32(481674261))
    result = result & TLEncode(int32(len(obj)))
    for objs in obj:
        if objs of msgs_state_req:
            result = result & cast[msgs_state_req](objs).TLEncode()

proc TLEncode*(obj: seq[PongI]): seq[uint8] =
    result = TLEncode(int32(481674261))
    result = result & TLEncode(int32(len(obj)))
    for objs in obj:
        if objs of pong:
            result = result & cast[pong](objs).TLEncode()

proc TLEncode*(obj: seq[Server_DH_ParamsI]): seq[uint8] =
    result = TLEncode(int32(481674261))
    result = result & TLEncode(int32(len(obj)))
    for objs in obj:
        if objs of server_DH_params_fail:
            result = result & cast[server_DH_params_fail](objs).TLEncode()
        if objs of server_DH_params_ok:
            result = result & cast[server_DH_params_ok](objs).TLEncode()

proc TLEncode*(obj: seq[MsgsStateInfoI]): seq[uint8] =
    result = TLEncode(int32(481674261))
    result = result & TLEncode(int32(len(obj)))
    for objs in obj:
        if objs of msgs_state_info:
            result = result & cast[msgs_state_info](objs).TLEncode()

proc TLEncode*(obj: seq[MsgDetailedInfoI]): seq[uint8] =
    result = TLEncode(int32(481674261))
    result = result & TLEncode(int32(len(obj)))
    for objs in obj:
        if objs of msg_detailed_info:
            result = result & cast[msg_detailed_info](objs).TLEncode()
        if objs of msg_new_detailed_info:
            result = result & cast[msg_new_detailed_info](objs).TLEncode()

proc TLEncode*(obj: seq[MsgsAckI]): seq[uint8] =
    result = TLEncode(int32(481674261))
    result = result & TLEncode(int32(len(obj)))
    for objs in obj:
        if objs of msgs_ack:
            result = result & cast[msgs_ack](objs).TLEncode()

proc TLEncode*(obj: seq[Client_DH_Inner_DataI]): seq[uint8] =
    result = TLEncode(int32(481674261))
    result = result & TLEncode(int32(len(obj)))
    for objs in obj:
        if objs of client_DH_inner_data:
            result = result & cast[client_DH_inner_data](objs).TLEncode()

proc TLEncode*(obj: seq[P_Q_inner_dataI]): seq[uint8] =
    result = TLEncode(int32(481674261))
    result = result & TLEncode(int32(len(obj)))
    for objs in obj:
        if objs of p_q_inner_data:
            result = result & cast[p_q_inner_data](objs).TLEncode()

proc TLEncode*(obj: seq[RpcDropAnswerI]): seq[uint8] =
    result = TLEncode(int32(481674261))
    result = result & TLEncode(int32(len(obj)))
    for objs in obj:
        if objs of rpc_answer_unknown:
            result = result & cast[rpc_answer_unknown](objs).TLEncode()
        if objs of rpc_answer_dropped_running:
            result = result & cast[rpc_answer_dropped_running](objs).TLEncode()
        if objs of rpc_answer_dropped:
            result = result & cast[rpc_answer_dropped](objs).TLEncode()

proc TLEncode*(obj: seq[MsgResendReqI]): seq[uint8] =
    result = TLEncode(int32(481674261))
    result = result & TLEncode(int32(len(obj)))
    for objs in obj:
        if objs of msg_resend_req:
            result = result & cast[msg_resend_req](objs).TLEncode()

proc TLEncode*(obj: seq[RpcResultI]): seq[uint8] =
    result = TLEncode(int32(481674261))
    result = result & TLEncode(int32(len(obj)))
    for objs in obj:
        if objs of rpc_result:
            result = result & cast[rpc_result](objs).TLEncode()

proc TLEncode*(obj: seq[Server_DH_inner_dataI]): seq[uint8] =
    result = TLEncode(int32(481674261))
    result = result & TLEncode(int32(len(obj)))
    for objs in obj:
        if objs of server_DH_inner_data:
            result = result & cast[server_DH_inner_data](objs).TLEncode()

proc TLEncode*(obj: seq[RpcErrorI]): seq[uint8] =
    result = TLEncode(int32(481674261))
    result = result & TLEncode(int32(len(obj)))
    for objs in obj:
        if objs of rpc_error:
            result = result & cast[rpc_error](objs).TLEncode()

proc TLEncode*(obj: seq[ResPQI]): seq[uint8] =
    result = TLEncode(int32(481674261))
    result = result & TLEncode(int32(len(obj)))
    for objs in obj:
        if objs of resPQ:
            result = result & cast[resPQ](objs).TLEncode()

proc TLEncode*(obj: seq[NewSessionI]): seq[uint8] =
    result = TLEncode(int32(481674261))
    result = result & TLEncode(int32(len(obj)))
    for objs in obj:
        if objs of new_session_created:
            result = result & cast[new_session_created](objs).TLEncode()

proc TLEncode*(obj: seq[BadMsgNotificationI]): seq[uint8] =
    result = TLEncode(int32(481674261))
    result = result & TLEncode(int32(len(obj)))
    for objs in obj:
        if objs of bad_msg_notification:
            result = result & cast[bad_msg_notification](objs).TLEncode()
        if objs of bad_server_salt:
            result = result & cast[bad_server_salt](objs).TLEncode()

proc TLEncode*(obj: seq[MsgsAllInfoI]): seq[uint8] =
    result = TLEncode(int32(481674261))
    result = result & TLEncode(int32(len(obj)))
    for objs in obj:
        if objs of msgs_all_info:
            result = result & cast[msgs_all_info](objs).TLEncode()

proc TLEncode*(obj: TLObject): seq[uint8] = 
    if obj of Set_client_DH_params_answerI:
        return cast[Set_client_DH_params_answerI](obj).TLEncode()
    if obj of DestroySessionResI:
        return cast[DestroySessionResI](obj).TLEncode()
    if obj of MsgsStateReqI:
        return cast[MsgsStateReqI](obj).TLEncode()
    if obj of PongI:
        return cast[PongI](obj).TLEncode()
    if obj of Server_DH_ParamsI:
        return cast[Server_DH_ParamsI](obj).TLEncode()
    if obj of MsgsStateInfoI:
        return cast[MsgsStateInfoI](obj).TLEncode()
    if obj of MsgDetailedInfoI:
        return cast[MsgDetailedInfoI](obj).TLEncode()
    if obj of MsgsAckI:
        return cast[MsgsAckI](obj).TLEncode()
    if obj of Client_DH_Inner_DataI:
        return cast[Client_DH_Inner_DataI](obj).TLEncode()
    if obj of P_Q_inner_dataI:
        return cast[P_Q_inner_dataI](obj).TLEncode()
    if obj of RpcDropAnswerI:
        return cast[RpcDropAnswerI](obj).TLEncode()
    if obj of MsgResendReqI:
        return cast[MsgResendReqI](obj).TLEncode()
    if obj of RpcResultI:
        return cast[RpcResultI](obj).TLEncode()  
    if obj of Server_DH_inner_dataI:
        return cast[Server_DH_inner_dataI](obj).TLEncode()
    if obj of RpcErrorI:
        return cast[RpcErrorI](obj).TLEncode()
    if obj of ResPQI:
        return cast[ResPQI](obj).TLEncode()
    if obj of NewSessionI:
        return cast[NewSessionI](obj).TLEncode()
    if obj of BadMsgNotificationI:
        return cast[BadMsgNotificationI](obj).TLEncode()
    if obj of MsgsAllInfoI:
        return cast[MsgsAllInfoI](obj).TLEncode()
    if obj of GZipPacked:
        return cast[GZipPacked](obj).TLEncodeType()
    return TLEncodeApi(obj)


proc TLEncode*(obj: seq[TLObject]): seq[uint8] =
    result = TLEncode(int32(481674261))
    result = result & TLEncode(int32(len(obj)))
    for objs in obj:
        if objs of Set_client_DH_params_answerI:
            result = result & cast[Set_client_DH_params_answerI](objs).TLEncode()
        if objs of DestroySessionResI:
            result = result & cast[DestroySessionResI](objs).TLEncode()
        if objs of MsgsStateReqI:
            result = result & cast[MsgsStateReqI](objs).TLEncode()
        if objs of PongI:
            result = result & cast[PongI](objs).TLEncode()
        if objs of Server_DH_ParamsI:
            result = result & cast[Server_DH_ParamsI](objs).TLEncode()
        if objs of MsgsStateInfoI:
            result = result & cast[MsgsStateInfoI](objs).TLEncode()
        if objs of MsgDetailedInfoI:
            result = result & cast[MsgDetailedInfoI](objs).TLEncode()
        if objs of MsgsAckI:
            result = result & cast[MsgsAckI](objs).TLEncode()
        if objs of Client_DH_Inner_DataI:
            result = result & cast[Client_DH_Inner_DataI](objs).TLEncode()
        if objs of P_Q_inner_dataI:
            result = result & cast[P_Q_inner_dataI](objs).TLEncode()
        if objs of RpcDropAnswerI:
            result = result & cast[RpcDropAnswerI](objs).TLEncode()
        if objs of MsgResendReqI:
            result = result & cast[MsgResendReqI](objs).TLEncode()
        if objs of RpcResultI:
            result = result & cast[RpcResultI](objs).TLEncode()        
        if objs of Server_DH_inner_dataI:
            result = result & cast[Server_DH_inner_dataI](objs).TLEncode()
        if objs of RpcErrorI:
            result = result & cast[RpcErrorI](objs).TLEncode()
        if objs of ResPQI:
            result = result & cast[ResPQI](objs).TLEncode()
        if objs of NewSessionI:
            result = result & cast[NewSessionI](objs).TLEncode()
        if objs of BadMsgNotificationI:
            result = result & cast[BadMsgNotificationI](objs).TLEncode()
        if objs of MsgsAllInfoI:
            result = result & cast[MsgsAllInfoI](objs).TLEncode()
        result = result & TLEncode(objs)



proc TLEncodeType*(obj: resPQ): seq[uint8] = 
    result = result & TLEncode(int32(85337187))
    result = result & TLEncode(obj.nonce)

    result = result & TLEncode(obj.server_nonce)

    result = result & TLEncode(obj.pq)

    result = result & TLEncode(obj.server_public_key_fingerprints)


proc TLEncodeType*(obj: p_q_inner_data): seq[uint8] = 
    result = result & TLEncode(int32(-2083955988))
    result = result & TLEncode(obj.pq)

    result = result & TLEncode(obj.p)

    result = result & TLEncode(obj.q)

    result = result & TLEncode(obj.nonce)

    result = result & TLEncode(obj.server_nonce)

    result = result & TLEncode(obj.new_nonce)


proc TLEncodeType*(obj: server_DH_params_fail): seq[uint8] = 
    result = result & TLEncode(int32(2043348061))
    result = result & TLEncode(obj.nonce)

    result = result & TLEncode(obj.server_nonce)

    result = result & TLEncode(obj.new_nonce_hash)


proc TLEncodeType*(obj: server_DH_params_ok): seq[uint8] = 
    result = result & TLEncode(int32(-790100132))
    result = result & TLEncode(obj.nonce)

    result = result & TLEncode(obj.server_nonce)

    result = result & TLEncode(obj.encrypted_answer)


proc TLEncodeType*(obj: server_DH_inner_data): seq[uint8] = 
    result = result & TLEncode(int32(-1249309254))
    result = result & TLEncode(obj.nonce)

    result = result & TLEncode(obj.server_nonce)

    result = result & TLEncode(obj.g)

    result = result & TLEncode(obj.dh_prime)

    result = result & TLEncode(obj.g_a)

    result = result & TLEncode(obj.server_time)


proc TLEncodeType*(obj: client_DH_inner_data): seq[uint8] = 
    result = result & TLEncode(int32(1715713620))
    result = result & TLEncode(obj.nonce)

    result = result & TLEncode(obj.server_nonce)

    result = result & TLEncode(obj.retry_id)

    result = result & TLEncode(obj.g_b)


proc TLEncodeType*(obj: dh_gen_ok): seq[uint8] = 
    result = result & TLEncode(int32(1003222836))
    result = result & TLEncode(obj.nonce)

    result = result & TLEncode(obj.server_nonce)

    result = result & TLEncode(obj.new_nonce_hash1)


proc TLEncodeType*(obj: dh_gen_retry): seq[uint8] = 
    result = result & TLEncode(int32(1188831161))
    result = result & TLEncode(obj.nonce)

    result = result & TLEncode(obj.server_nonce)

    result = result & TLEncode(obj.new_nonce_hash2)


proc TLEncodeType*(obj: dh_gen_fail): seq[uint8] = 
    result = result & TLEncode(int32(-1499615742))
    result = result & TLEncode(obj.nonce)

    result = result & TLEncode(obj.server_nonce)

    result = result & TLEncode(obj.new_nonce_hash3)

proc TLEncodeType*(obj: rpc_result): seq[uint8] = 
    result = result & TLEncode(int32(-212046591))
    result = result & TLEncode(obj.req_msg_id)

    result = result & TLEncode(obj.result)

proc TLEncodeType*(obj: rpc_error): seq[uint8] = 
    result = result & TLEncode(int32(558156313))
    result = result & TLEncode(obj.error_code)

    result = result & TLEncode(obj.error_message)


proc TLEncodeType*(obj: rpc_answer_unknown): seq[uint8] = 
    result = result & TLEncode(int32(1579864942))

proc TLEncodeType*(obj: rpc_answer_dropped_running): seq[uint8] = 
    result = result & TLEncode(int32(-847714938))

proc TLEncodeType*(obj: rpc_answer_dropped): seq[uint8] = 
    result = result & TLEncode(int32(-1539647305))
    result = result & TLEncode(obj.msg_id)

    result = result & TLEncode(obj.seq_no)

    result = result & TLEncode(obj.bytes)


proc TLEncodeType*(obj: pong): seq[uint8] = 
    result = result & TLEncode(int32(880243653))
    result = result & TLEncode(obj.msg_id)

    result = result & TLEncode(obj.ping_id)


proc TLEncodeType*(obj: destroy_session_ok): seq[uint8] = 
    result = result & TLEncode(int32(-501201412))
    result = result & TLEncode(obj.session_id)


proc TLEncodeType*(obj: destroy_session_none): seq[uint8] = 
    result = result & TLEncode(int32(1658015945))
    result = result & TLEncode(obj.session_id)


proc TLEncodeType*(obj: new_session_created): seq[uint8] = 
    result = result & TLEncode(int32(-1631450872))
    result = result & TLEncode(obj.first_msg_id)

    result = result & TLEncode(obj.unique_id)

    result = result & TLEncode(obj.server_salt)


proc TLEncodeType*(obj: msgs_ack): seq[uint8] = 
    result = result & TLEncode(int32(1658238041))
    result = result & TLEncode(obj.msg_ids)


proc TLEncodeType*(obj: bad_msg_notification): seq[uint8] = 
    result = result & TLEncode(int32(-1477445615))
    result = result & TLEncode(obj.bad_msg_id)
    result = result & TLEncode(obj.bad_msg_seqno)

    result = result & TLEncode(obj.error_code)


proc TLEncodeType*(obj: bad_server_salt): seq[uint8] = 
    result = result & TLEncode(int32(-307542917))
    result = result & TLEncode(obj.bad_msg_id)

    result = result & TLEncode(obj.bad_msg_seqno)

    result = result & TLEncode(obj.error_code)

    result = result & TLEncode(obj.new_server_salt)


proc TLEncodeType*(obj: msg_resend_req): seq[uint8] = 
    result = result & TLEncode(int32(2105940488))
    result = result & TLEncode(obj.msg_ids)


proc TLEncodeType*(obj: msgs_state_req): seq[uint8] = 
    result = result & TLEncode(int32(-630588590))
    result = result & TLEncode(obj.msg_ids)


proc TLEncodeType*(obj: msgs_state_info): seq[uint8] = 
    result = result & TLEncode(int32(81704317))
    result = result & TLEncode(obj.req_msg_id)

    result = result & TLEncode(obj.info)


proc TLEncodeType*(obj: msgs_all_info): seq[uint8] = 
    result = result & TLEncode(int32(-1933520591))
    result = result & TLEncode(obj.msg_ids)

    result = result & TLEncode(obj.info)


proc TLEncodeType*(obj: msg_detailed_info): seq[uint8] = 
    result = result & TLEncode(int32(661470918))
    result = result & TLEncode(obj.msg_id)

    result = result & TLEncode(obj.answer_msg_id)

    result = result & TLEncode(obj.bytes)

    result = result & TLEncode(obj.status)


proc TLEncodeType*(obj: msg_new_detailed_info): seq[uint8] = 
    result = result & TLEncode(int32(-2137147681))
    result = result & TLEncode(obj.answer_msg_id)

    result = result & TLEncode(obj.bytes)

    result = result & TLEncode(obj.status)

proc TLEncodeGeneric*(obj: TLFunction): seq[uint8]


proc TLEncodeType*(unpackedData: GZipPacked): seq[uint8] =
    result = TLEncode(uint32(0x3072CFA1))
    result = TLEncode(compress(unpackedData.data))


#[const FromID* = {1: "default",
85337187: "resPQ",
-2083955988: "p_q_inner_data",
2043348061: "server_DH_params_fail",
-790100132: "server_DH_params_ok",
-1249309254: "server_DH_inner_data",
1715713620: "client_DH_inner_data",
1003222836: "dh_gen_ok",
1188831161: "dh_gen_retry",
-1499615742: "dh_gen_fail",
-212046591: "rpc_result",
558156313: "rpc_error",
1579864942: "rpc_answer_unknown",
-847714938: "rpc_answer_dropped_running",
-1539647305: "rpc_answer_dropped",
880243653: "pong",
-501201412: "destroy_session_ok",
1658015945: "destroy_session_none",
-1631450872: "new_session_created",
1658238041: "msgs_ack",
-1477445615: "bad_msg_notification",
-307542917: "bad_server_salt",
2105940488: "msg_resend_req",
-630588590: "msgs_state_req",
81704317: "msgs_state_info",
-1933520591: "msgs_all_info",
661470918: "msg_detailed_info",
-2137147681: "msg_new_detailed_info",
812830625: "gzip_packed"}]#


proc TLDecode*(self: var ScalingSeq[uint8], obj: var Set_client_DH_params_answerI) =  
        var id: int32
        self.TLDecode(addr id)
        case FromID.toTable[id]
        of "dh_gen_ok":
            var tempObject = new(dh_gen_ok)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "dh_gen_retry":
            var tempObject = new(dh_gen_retry)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "dh_gen_fail":
            var tempObject = new(dh_gen_fail)
            self.TlDecode(tempObject)
            obj = tempObject
            return
proc TLDecode*(self: var ScalingSeq[uint8], obj: var DestroySessionResI) =  
        var id: int32
        self.TLDecode(addr id)
        case FromID.toTable[id]
        of "destroy_session_ok":
            var tempObject = new(destroy_session_ok)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "destroy_session_none":
            var tempObject = new(destroy_session_none)
            self.TlDecode(tempObject)
            obj = tempObject
            return
proc TLDecode*(self: var ScalingSeq[uint8], obj: var MsgsStateReqI) =  
        var id: int32
        self.TLDecode(addr id)
        case FromID.toTable[id]
        of "msgs_state_req":
            var tempObject = new(msgs_state_req)
            self.TlDecode(tempObject)
            obj = tempObject
            return
proc TLDecode*(self: var ScalingSeq[uint8], obj: var PongI) =  
        var id: int32
        self.TLDecode(addr id)
        case FromID.toTable[id]
        of "pong":
            var tempObject = new(pong)
            self.TlDecode(tempObject)
            obj = tempObject
            return
proc TLDecode*(self: var ScalingSeq[uint8], obj: var Server_DH_ParamsI) =  
        var id: int32
        self.TLDecode(addr id)
        case FromID.toTable[id]
        of "server_DH_params_fail":
            var tempObject = new(server_DH_params_fail)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "server_DH_params_ok":
            var tempObject = new(server_DH_params_ok)
            self.TlDecode(tempObject)
            obj = tempObject
            return
proc TLDecode*(self: var ScalingSeq[uint8], obj: var MsgsStateInfoI) =  
        var id: int32
        self.TLDecode(addr id)
        case FromID.toTable[id]
        of "msgs_state_info":
            var tempObject = new(msgs_state_info)
            self.TlDecode(tempObject)
            obj = tempObject
            return
proc TLDecode*(self: var ScalingSeq[uint8], obj: var MsgDetailedInfoI) =  
        var id: int32
        self.TLDecode(addr id)
        case FromID.toTable[id]
        of "msg_detailed_info":
            var tempObject = new(msg_detailed_info)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "msg_new_detailed_info":
            var tempObject = new(msg_new_detailed_info)
            self.TlDecode(tempObject)
            obj = tempObject
            return
proc TLDecode*(self: var ScalingSeq[uint8], obj: var MsgsAckI) =  
        var id: int32
        self.TLDecode(addr id)
        case FromID.toTable[id]
        of "msgs_ack":
            var tempObject = new(msgs_ack)
            self.TlDecode(tempObject)
            obj = tempObject
            return
proc TLDecode*(self: var ScalingSeq[uint8], obj: var Client_DH_Inner_DataI) =  
        var id: int32
        self.TLDecode(addr id)
        case FromID.toTable[id]
        of "client_DH_inner_data":
            var tempObject = new(client_DH_inner_data)
            self.TlDecode(tempObject)
            obj = tempObject
            return
proc TLDecode*(self: var ScalingSeq[uint8], obj: var P_Q_inner_dataI) =  
        var id: int32
        self.TLDecode(addr id)
        case FromID.toTable[id]
        of "p_q_inner_data":
            var tempObject = new(p_q_inner_data)
            self.TlDecode(tempObject)
            obj = tempObject
            return
proc TLDecode*(self: var ScalingSeq[uint8], obj: var RpcDropAnswerI) =  
        var id: int32
        self.TLDecode(addr id)
        case FromID.toTable[id]
        of "rpc_answer_unknown":
            var tempObject = new(rpc_answer_unknown)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "rpc_answer_dropped_running":
            var tempObject = new(rpc_answer_dropped_running)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "rpc_answer_dropped":
            var tempObject = new(rpc_answer_dropped)
            self.TlDecode(tempObject)
            obj = tempObject
            return
proc TLDecode*(self: var ScalingSeq[uint8], obj: var MsgResendReqI) =  
        var id: int32
        self.TLDecode(addr id)
        case FromID.toTable[id]
        of "msg_resend_req":
            var tempObject = new(msg_resend_req)
            self.TlDecode(tempObject)
            obj = tempObject
            return
proc TLDecode*(self: var ScalingSeq[uint8], obj: var RpcResultI) =  
        var id: int32
        self.TLDecode(addr id)
        case FromID.toTable[id]
        of "rpc_result":
            var tempObject = new(rpc_result)
            self.TlDecode(tempObject)
            obj = tempObject
            return
proc TLDecode*(self: var ScalingSeq[uint8], obj: var Server_DH_inner_dataI) =  
        var id: int32
        self.TLDecode(addr id)
        case FromID.toTable[id]
        of "server_DH_inner_data":
            var tempObject = new(server_DH_inner_data)
            self.TlDecode(tempObject)
            obj = tempObject
            return
proc TLDecode*(self: var ScalingSeq[uint8], obj: var RpcErrorI) =  
        var id: int32
        self.TLDecode(addr id)
        case FromID.toTable[id]
        of "rpc_error":
            var tempObject = new(rpc_error)
            self.TlDecode(tempObject)
            obj = tempObject
            return
proc TLDecode*(self: var ScalingSeq[uint8], obj: var ResPQI) =  
        var id: int32
        self.TLDecode(addr id)
        case FromID.toTable[id]
        of "resPQ":
            var tempObject = new(resPQ)
            self.TlDecode(tempObject)
            obj = tempObject
            return
proc TLDecode*(self: var ScalingSeq[uint8], obj: var NewSessionI) =  
        var id: int32
        self.TLDecode(addr id)
        case FromID.toTable[id]
        of "new_session_created":
            var tempObject = new(new_session_created)
            self.TlDecode(tempObject)
            obj = tempObject
            return
proc TLDecode*(self: var ScalingSeq[uint8], obj: var BadMsgNotificationI) =  
        var id: int32
        self.TLDecode(addr id)
        case FromID.toTable[id]
        of "bad_msg_notification":
            var tempObject = new(bad_msg_notification)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "bad_server_salt":
            var tempObject = new(bad_server_salt)
            self.TlDecode(tempObject)
            obj = tempObject
            return
proc TLDecode*(self: var ScalingSeq[uint8], obj: var MsgsAllInfoI) =  
        var id: int32
        self.TLDecode(addr id)
        case FromID.toTable[id]
        of "msgs_all_info":
            var tempObject = new(msgs_all_info)
            self.TlDecode(tempObject)
            obj = tempObject
            return

proc TLDecode*(self: var ScalingSeq[uint8], obj: var seq[Set_client_DH_params_answerI]) =
    var id: int32
    self.TLDecode(addr id)
    if id != 481674261:
        raise newException(Exception, "Type is not Vector")
    var lenght: int32
    self.TLDecode(addr lenght)
    for i in countup(1, lenght):
        var id: int32
        self.TLDecode(addr id)
        if FromID.toTable[id] == "dh_gen_ok":
            var tempObject = new(dh_gen_ok)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "dh_gen_retry":
            var tempObject = new(dh_gen_retry)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "dh_gen_fail":
            var tempObject = new(dh_gen_fail)
            self.TlDecode(tempObject)
            obj.add(tempObject)

proc TLDecode*(self: var ScalingSeq[uint8], obj: var seq[DestroySessionResI]) =
    var id: int32
    self.TLDecode(addr id)
    if id != 481674261:
        raise newException(Exception, "Type is not Vector")
    var lenght: int32
    self.TLDecode(addr lenght)
    for i in countup(1, lenght):
        var id: int32
        self.TLDecode(addr id)
        if FromID.toTable[id] == "destroy_session_ok":
            var tempObject = new(destroy_session_ok)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "destroy_session_none":
            var tempObject = new(destroy_session_none)
            self.TlDecode(tempObject)
            obj.add(tempObject)

proc TLDecode*(self: var ScalingSeq[uint8], obj: var seq[MsgsStateReqI]) =
    var id: int32
    self.TLDecode(addr id)
    if id != 481674261:
        raise newException(Exception, "Type is not Vector")
    var lenght: int32
    self.TLDecode(addr lenght)
    for i in countup(1, lenght):
        var id: int32
        self.TLDecode(addr id)
        if FromID.toTable[id] == "msgs_state_req":
            var tempObject = new(msgs_state_req)
            self.TlDecode(tempObject)
            obj.add(tempObject)

proc TLDecode*(self: var ScalingSeq[uint8], obj: var seq[PongI]) =
    var id: int32
    self.TLDecode(addr id)
    if id != 481674261:
        raise newException(Exception, "Type is not Vector")
    var lenght: int32
    self.TLDecode(addr lenght)
    for i in countup(1, lenght):
        var id: int32
        self.TLDecode(addr id)
        if FromID.toTable[id] == "pong":
            var tempObject = new(pong)
            self.TlDecode(tempObject)
            obj.add(tempObject)

proc TLDecode*(self: var ScalingSeq[uint8], obj: var seq[Server_DH_ParamsI]) =
    var id: int32
    self.TLDecode(addr id)
    if id != 481674261:
        raise newException(Exception, "Type is not Vector")
    var lenght: int32
    self.TLDecode(addr lenght)
    for i in countup(1, lenght):
        var id: int32
        self.TLDecode(addr id)
        if FromID.toTable[id] == "server_DH_params_fail":
            var tempObject = new(server_DH_params_fail)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "server_DH_params_ok":
            var tempObject = new(server_DH_params_ok)
            self.TlDecode(tempObject)
            obj.add(tempObject)

proc TLDecode*(self: var ScalingSeq[uint8], obj: var seq[MsgsStateInfoI]) =
    var id: int32
    self.TLDecode(addr id)
    if id != 481674261:
        raise newException(Exception, "Type is not Vector")
    var lenght: int32
    self.TLDecode(addr lenght)
    for i in countup(1, lenght):
        var id: int32
        self.TLDecode(addr id)
        if FromID.toTable[id] == "msgs_state_info":
            var tempObject = new(msgs_state_info)
            self.TlDecode(tempObject)
            obj.add(tempObject)

proc TLDecode*(self: var ScalingSeq[uint8], obj: var seq[MsgDetailedInfoI]) =
    var id: int32
    self.TLDecode(addr id)
    if id != 481674261:
        raise newException(Exception, "Type is not Vector")
    var lenght: int32
    self.TLDecode(addr lenght)
    for i in countup(1, lenght):
        var id: int32
        self.TLDecode(addr id)
        if FromID.toTable[id] == "msg_detailed_info":
            var tempObject = new(msg_detailed_info)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "msg_new_detailed_info":
            var tempObject = new(msg_new_detailed_info)
            self.TlDecode(tempObject)
            obj.add(tempObject)

proc TLDecode*(self: var ScalingSeq[uint8], obj: var seq[MsgsAckI]) =
    var id: int32
    self.TLDecode(addr id)
    if id != 481674261:
        raise newException(Exception, "Type is not Vector")
    var lenght: int32
    self.TLDecode(addr lenght)
    for i in countup(1, lenght):
        var id: int32
        self.TLDecode(addr id)
        if FromID.toTable[id] == "msgs_ack":
            var tempObject = new(msgs_ack)
            self.TlDecode(tempObject)
            obj.add(tempObject)

proc TLDecode*(self: var ScalingSeq[uint8], obj: var seq[Client_DH_Inner_DataI]) =
    var id: int32
    self.TLDecode(addr id)
    if id != 481674261:
        raise newException(Exception, "Type is not Vector")
    var lenght: int32
    self.TLDecode(addr lenght)
    for i in countup(1, lenght):
        var id: int32
        self.TLDecode(addr id)
        if FromID.toTable[id] == "client_DH_inner_data":
            var tempObject = new(client_DH_inner_data)
            self.TlDecode(tempObject)
            obj.add(tempObject)

proc TLDecode*(self: var ScalingSeq[uint8], obj: var seq[P_Q_inner_dataI]) =
    var id: int32
    self.TLDecode(addr id)
    if id != 481674261:
        raise newException(Exception, "Type is not Vector")
    var lenght: int32
    self.TLDecode(addr lenght)
    for i in countup(1, lenght):
        var id: int32
        self.TLDecode(addr id)
        if FromID.toTable[id] == "p_q_inner_data":
            var tempObject = new(p_q_inner_data)
            self.TlDecode(tempObject)
            obj.add(tempObject)

proc TLDecode*(self: var ScalingSeq[uint8], obj: var seq[RpcDropAnswerI]) =
    var id: int32
    self.TLDecode(addr id)
    if id != 481674261:
        raise newException(Exception, "Type is not Vector")
    var lenght: int32
    self.TLDecode(addr lenght)
    for i in countup(1, lenght):
        var id: int32
        self.TLDecode(addr id)
        if FromID.toTable[id] == "rpc_answer_unknown":
            var tempObject = new(rpc_answer_unknown)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "rpc_answer_dropped_running":
            var tempObject = new(rpc_answer_dropped_running)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "rpc_answer_dropped":
            var tempObject = new(rpc_answer_dropped)
            self.TlDecode(tempObject)
            obj.add(tempObject)

proc TLDecode*(self: var ScalingSeq[uint8], obj: var seq[MsgResendReqI]) =
    var id: int32
    self.TLDecode(addr id)
    if id != 481674261:
        raise newException(Exception, "Type is not Vector")
    var lenght: int32
    self.TLDecode(addr lenght)
    for i in countup(1, lenght):
        var id: int32
        self.TLDecode(addr id)
        if FromID.toTable[id] == "msg_resend_req":
            var tempObject = new(msg_resend_req)
            self.TlDecode(tempObject)
            obj.add(tempObject)
proc TLDecode*(self: var ScalingSeq[uint8], obj: var seq[RpcResultI]) =
    var id: int32
    self.TLDecode(addr id)
    if id != 481674261:
        raise newException(Exception, "Type is not Vector")
    var lenght: int32
    self.TLDecode(addr lenght)
    for i in countup(1, lenght):
        var id: int32
        self.TLDecode(addr id)
        if FromID.toTable[id] == "rpc_result":
            var tempObject = new(rpc_result)
            self.TlDecode(tempObject)
            obj.add(tempObject)

proc TLDecode*(self: var ScalingSeq[uint8], obj: var seq[Server_DH_inner_dataI]) =
    var id: int32
    self.TLDecode(addr id)
    if id != 481674261:
        raise newException(Exception, "Type is not Vector")
    var lenght: int32
    self.TLDecode(addr lenght)
    for i in countup(1, lenght):
        var id: int32
        self.TLDecode(addr id)
        if FromID.toTable[id] == "server_DH_inner_data":
            var tempObject = new(server_DH_inner_data)
            self.TlDecode(tempObject)
            obj.add(tempObject)

proc TLDecode*(self: var ScalingSeq[uint8], obj: var seq[RpcErrorI]) =
    var id: int32
    self.TLDecode(addr id)
    if id != 481674261:
        raise newException(Exception, "Type is not Vector")
    var lenght: int32
    self.TLDecode(addr lenght)
    for i in countup(1, lenght):
        var id: int32
        self.TLDecode(addr id)
        if FromID.toTable[id] == "rpc_error":
            var tempObject = new(rpc_error)
            self.TlDecode(tempObject)
            obj.add(tempObject)

proc TLDecode*(self: var ScalingSeq[uint8], obj: var seq[ResPQI]) =
    var id: int32
    self.TLDecode(addr id)
    if id != 481674261:
        raise newException(Exception, "Type is not Vector")
    var lenght: int32
    self.TLDecode(addr lenght)
    for i in countup(1, lenght):
        var id: int32
        self.TLDecode(addr id)
        if FromID.toTable[id] == "resPQ":
            var tempObject = new(resPQ)
            self.TlDecode(tempObject)
            obj.add(tempObject)

proc TLDecode*(self: var ScalingSeq[uint8], obj: var seq[NewSessionI]) =
    var id: int32
    self.TLDecode(addr id)
    if id != 481674261:
        raise newException(Exception, "Type is not Vector")
    var lenght: int32
    self.TLDecode(addr lenght)
    for i in countup(1, lenght):
        var id: int32
        self.TLDecode(addr id)
        if FromID.toTable[id] == "new_session_created":
            var tempObject = new(new_session_created)
            self.TlDecode(tempObject)
            obj.add(tempObject)

proc TLDecode*(self: var ScalingSeq[uint8], obj: var seq[BadMsgNotificationI]) =
    var id: int32
    self.TLDecode(addr id)
    if id != 481674261:
        raise newException(Exception, "Type is not Vector")
    var lenght: int32
    self.TLDecode(addr lenght)
    for i in countup(1, lenght):
        var id: int32
        self.TLDecode(addr id)
        if FromID.toTable[id] == "bad_msg_notification":
            var tempObject = new(bad_msg_notification)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "bad_server_salt":
            var tempObject = new(bad_server_salt)
            self.TlDecode(tempObject)
            obj.add(tempObject)

proc TLDecode*(self: var ScalingSeq[uint8], obj: var seq[MsgsAllInfoI]) =
    var id: int32
    self.TLDecode(addr id)
    if id != 481674261:
        raise newException(Exception, "Type is not Vector")
    var lenght: int32
    self.TLDecode(addr lenght)
    for i in countup(1, lenght):
        var id: int32
        self.TLDecode(addr id)
        if FromID.toTable[id] == "msgs_all_info":
            var tempObject = new(msgs_all_info)
            self.TlDecode(tempObject)
            obj.add(tempObject)


proc TLDecode*(self: var ScalingSeq[uint8], obj: var TLObject) =  
        var id: int32
        self.TLDecode(addr id)
        case FromID.toTable[id]
        of "dh_gen_ok":
            var tempObject = new(dh_gen_ok)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "dh_gen_retry":
            var tempObject = new(dh_gen_retry)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "dh_gen_fail":
            var tempObject = new(dh_gen_fail)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "destroy_session_ok":
            var tempObject = new(destroy_session_ok)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "destroy_session_none":
            var tempObject = new(destroy_session_none)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "msgs_state_req":
            var tempObject = new(msgs_state_req)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "pong":
            var tempObject = new(pong)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "server_DH_params_fail":
            var tempObject = new(server_DH_params_fail)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "server_DH_params_ok":
            var tempObject = new(server_DH_params_ok)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "msgs_state_info":
            var tempObject = new(msgs_state_info)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "msg_detailed_info":
            var tempObject = new(msg_detailed_info)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "msg_new_detailed_info":
            var tempObject = new(msg_new_detailed_info)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "msgs_ack":
            var tempObject = new(msgs_ack)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "client_DH_inner_data":
            var tempObject = new(client_DH_inner_data)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "p_q_inner_data":
            var tempObject = new(p_q_inner_data)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "rpc_answer_unknown":
            var tempObject = new(rpc_answer_unknown)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "rpc_answer_dropped_running":
            var tempObject = new(rpc_answer_dropped_running)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "rpc_answer_dropped":
            var tempObject = new(rpc_answer_dropped)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "msg_resend_req":
            var tempObject = new(msg_resend_req)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "rpc_result":
            var tempObject = new(rpc_result)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "server_DH_inner_data":
            var tempObject = new(server_DH_inner_data)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "rpc_error":
            var tempObject = new(rpc_error)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "resPQ":
            var tempObject = new(resPQ)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "new_session_created":
            var tempObject = new(new_session_created)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "bad_msg_notification":
            var tempObject = new(bad_msg_notification)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "bad_server_salt":
            var tempObject = new(bad_server_salt)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "msgs_all_info":
            var tempObject = new(msgs_all_info)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        of "gzip_packed":
            var tempObject = new(GZipPacked)
            self.TlDecode(tempObject)
            obj = tempObject
            return
        else:
            self.goBack(4)
            self.TLDecodeApi(obj)

proc TLDecode*(self: var ScalingSeq[uint8], unpackedData: GZipPacked) =
    unpackedData.data = uncompress(self.TLDecode())

proc TLDecode*(self: var ScalingSeq[uint8], obj: var seq[TLObject]) =
    var id: int32
    self.TLDecode(addr id)
    if id != 481674261:
        raise newException(Exception, "Type is not Vector")
    var lenght: int32
    self.TLDecode(addr lenght)
    for i in countup(1, lenght):
        var id: int32
        self.TLDecode(addr id)
        if FromID.toTable[id] == "dh_gen_ok":
            var tempObject = new(dh_gen_ok)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "dh_gen_retry":
            var tempObject = new(dh_gen_retry)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "dh_gen_fail":
            var tempObject = new(dh_gen_fail)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "destroy_session_ok":
            var tempObject = new(destroy_session_ok)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "destroy_session_none":
            var tempObject = new(destroy_session_none)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "msgs_state_req":
            var tempObject = new(msgs_state_req)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "pong":
            var tempObject = new(pong)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "server_DH_params_fail":
            var tempObject = new(server_DH_params_fail)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "server_DH_params_ok":
            var tempObject = new(server_DH_params_ok)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "msgs_state_info":
            var tempObject = new(msgs_state_info)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "msg_detailed_info":
            var tempObject = new(msg_detailed_info)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "msg_new_detailed_info":
            var tempObject = new(msg_new_detailed_info)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "msgs_ack":
            var tempObject = new(msgs_ack)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "client_DH_inner_data":
            var tempObject = new(client_DH_inner_data)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "p_q_inner_data":
            var tempObject = new(p_q_inner_data)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "rpc_answer_unknown":
            var tempObject = new(rpc_answer_unknown)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "rpc_answer_dropped_running":
            var tempObject = new(rpc_answer_dropped_running)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "rpc_answer_dropped":
            var tempObject = new(rpc_answer_dropped)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "msg_resend_req":
            var tempObject = new(msg_resend_req)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "rpc_result":
            var tempObject = new(rpc_result)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "server_DH_inner_data":
            var tempObject = new(server_DH_inner_data)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "rpc_error":
            var tempObject = new(rpc_error)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "resPQ":
            var tempObject = new(resPQ)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "new_session_created":
            var tempObject = new(new_session_created)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "bad_msg_notification":
            var tempObject = new(bad_msg_notification)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "bad_server_salt":
            var tempObject = new(bad_server_salt)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        if FromID.toTable[id] == "msgs_all_info":
            var tempObject = new(msgs_all_info)
            self.TlDecode(tempObject)
            obj.add(tempObject)
        self.goBack(4)
        var tempObject: TLObject
        self.TLDecodeApi(tempObject)
        obj.add(tempObject)


proc TLDecode*(self: var ScalingSeq[uint8], obj: resPQ) = 
    self.TLDecode(addr obj.nonce)
    self.TLDecode(addr obj.server_nonce)
    obj.pq = self.TLDecode()
    self.TLDecode(obj.server_public_key_fingerprints)

proc TLDecode*(self: var ScalingSeq[uint8], obj: p_q_inner_data) = 
    obj.pq = self.TLDecode()
    obj.p = self.TLDecode()
    obj.q = self.TLDecode()
    self.TLDecode(addr obj.nonce)
    self.TLDecode(addr obj.server_nonce)
    self.TLDecode(addr obj.new_nonce)

proc TLDecode*(self: var ScalingSeq[uint8], obj: server_DH_params_fail) = 
    self.TLDecode(addr obj.nonce)
    self.TLDecode(addr obj.server_nonce)
    self.TLDecode(addr obj.new_nonce_hash)

proc TLDecode*(self: var ScalingSeq[uint8], obj: server_DH_params_ok) = 
    self.TLDecode(addr obj.nonce)
    self.TLDecode(addr obj.server_nonce)
    obj.encrypted_answer = self.TLDecode()

proc TLDecode*(self: var ScalingSeq[uint8], obj: server_DH_inner_data) = 
    self.TLDecode(addr obj.nonce)
    self.TLDecode(addr obj.server_nonce)
    self.TLDecode(addr obj.g)
    obj.dh_prime = self.TLDecode()
    obj.g_a = self.TLDecode()
    self.TLDecode(addr obj.server_time)

proc TLDecode*(self: var ScalingSeq[uint8], obj: client_DH_inner_data) = 
    self.TLDecode(addr obj.nonce)
    self.TLDecode(addr obj.server_nonce)
    self.TLDecode(addr obj.retry_id)
    obj.g_b = self.TLDecode()

proc TLDecode*(self: var ScalingSeq[uint8], obj: dh_gen_ok) = 
    self.TLDecode(addr obj.nonce)
    self.TLDecode(addr obj.server_nonce)
    self.TLDecode(addr obj.new_nonce_hash1)

proc TLDecode*(self: var ScalingSeq[uint8], obj: dh_gen_retry) = 
    self.TLDecode(addr obj.nonce)
    self.TLDecode(addr obj.server_nonce)
    self.TLDecode(addr obj.new_nonce_hash2)

proc TLDecode*(self: var ScalingSeq[uint8], obj: dh_gen_fail) = 
    self.TLDecode(addr obj.nonce)
    self.TLDecode(addr obj.server_nonce)
    self.TLDecode(addr obj.new_nonce_hash3)

proc TLDecode*(self: var ScalingSeq[uint8], obj: rpc_result) = 
    self.TLDecode(addr obj.req_msg_id)
    self.TLDecode(obj.result)

proc TLDecode*(self: var ScalingSeq[uint8], obj: rpc_error) = 
    self.TLDecode(addr obj.error_code)
    obj.error_message = cast[string](self.TLDecode())

proc TLDecode*(self: var ScalingSeq[uint8], obj: rpc_answer_unknown) = discard

proc TLDecode*(self: var ScalingSeq[uint8], obj: rpc_answer_dropped_running) = discard

proc TLDecode*(self: var ScalingSeq[uint8], obj: rpc_answer_dropped) = 
    self.TLDecode(addr obj.msg_id)
    self.TLDecode(addr obj.seq_no)
    self.TLDecode(addr obj.bytes)

proc TLDecode*(self: var ScalingSeq[uint8], obj: pong) = 
    self.TLDecode(addr obj.msg_id)
    self.TLDecode(addr obj.ping_id)

proc TLDecode*(self: var ScalingSeq[uint8], obj: destroy_session_ok) = 
    self.TLDecode(addr obj.session_id)

proc TLDecode*(self: var ScalingSeq[uint8], obj: destroy_session_none) = 
    self.TLDecode(addr obj.session_id)

proc TLDecode*(self: var ScalingSeq[uint8], obj: new_session_created) = 
    self.TLDecode(addr obj.first_msg_id)
    self.TLDecode(addr obj.unique_id)
    self.TLDecode(addr obj.server_salt)

proc TLDecode*(self: var ScalingSeq[uint8], obj: msgs_ack) = 
    self.TLDecode(obj.msg_ids)

proc TLDecode*(self: var ScalingSeq[uint8], obj: bad_msg_notification) = 

    self.TLDecode(addr obj.bad_msg_id)
    self.TLDecode(addr obj.bad_msg_seqno)
    self.TLDecode(addr obj.error_code)

proc TLDecode*(self: var ScalingSeq[uint8], obj: bad_server_salt) = 
    self.TLDecode(addr obj.bad_msg_id)
    self.TLDecode(addr obj.bad_msg_seqno)
    self.TLDecode(addr obj.error_code)
    self.TLDecode(addr obj.new_server_salt)

proc TLDecode*(self: var ScalingSeq[uint8], obj: msg_resend_req) = 
    self.TLDecode(obj.msg_ids)

proc TLDecode*(self: var ScalingSeq[uint8], obj: msgs_state_req) = 
    self.TLDecode(obj.msg_ids)

proc TLDecode*(self: var ScalingSeq[uint8], obj: msgs_state_info) = 
    self.TLDecode(addr obj.req_msg_id)
    obj.info = self.TLDecode()

proc TLDecode*(self: var ScalingSeq[uint8], obj: msgs_all_info) = 
    self.TLDecode(obj.msg_ids)
    obj.info = self.TLDecode()

proc TLDecode*(self: var ScalingSeq[uint8], obj: msg_detailed_info) = 
    self.TLDecode(addr obj.msg_id)
    self.TLDecode(addr obj.answer_msg_id)
    self.TLDecode(addr obj.bytes)
    self.TLDecode(addr obj.status)

proc TLDecode*(self: var ScalingSeq[uint8], obj: msg_new_detailed_info) = 
    self.TLDecode(addr obj.answer_msg_id)
    self.TLDecode(addr obj.bytes)
    self.TLDecode(addr obj.status)


type
 #   TLFunction* = ref object of TL

    req_pq* = ref object of TLFunction
        nonce*: Int128

    req_pq_multi* = ref object of TLFunction
        nonce*: Int128

    req_DH_params* = ref object of TLFunction
        nonce*: Int128
        server_nonce*: Int128
        p*: seq[uint8]
        q*: seq[uint8]
        public_key_fingerprint*: int64
        encrypted_data*: seq[uint8]

    set_client_DH_params* = ref object of TLFunction
        nonce*: Int128
        server_nonce*: Int128
        encrypted_data*: seq[uint8]

    rpc_drop_answer* = ref object of TLFunction
        req_msg_id*: int64

    get_future_salts* = ref object of TLFunction
        num*: int32

    ping* = ref object of TLFunction
        ping_id*: int64

    ping_delay_disconnect* = ref object of TLFunction
        ping_id*: int64
        disconnect_delay*: int32

    destroy_session* = ref object of TLFunction
        session_id*: int64

    http_wait* = ref object of TLFunction
        max_delay*: int32
        wait_after*: int32
        max_wait*: int32

proc TLEncodeFunction*(obj: req_pq): seq[uint8] = 
    result = result & TLEncode(int32(1615239032))
    result = result & TLEncode(obj.nonce)


proc TLEncodeFunction*(obj: req_pq_multi): seq[uint8] = 
    result = result & TLEncode(int32(-1099002127))
    result = result & TLEncode(obj.nonce)


proc TLEncodeFunction*(obj: req_DH_params): seq[uint8] = 
    result = result & TLEncode(int32(-686627650))
    result = result & TLEncode(obj.nonce)

    result = result & TLEncode(obj.server_nonce)

    result = result & TLEncode(obj.p)

    result = result & TLEncode(obj.q)

    result = result & TLEncode(obj.public_key_fingerprint)

    result = result & TLEncode(obj.encrypted_data)


proc TLEncodeFunction*(obj: set_client_DH_params): seq[uint8] = 
    result = result & TLEncode(int32(-184262881))
    result = result & TLEncode(obj.nonce)

    result = result & TLEncode(obj.server_nonce)

    result = result & TLEncode(obj.encrypted_data)


proc TLEncodeFunction*(obj: rpc_drop_answer): seq[uint8] = 
    result = result & TLEncode(int32(1491380032))
    result = result & TLEncode(obj.req_msg_id)


proc TLEncodeFunction*(obj: get_future_salts): seq[uint8] = 
    result = result & TLEncode(int32(-1188971260))
    result = result & TLEncode(obj.num)


proc TLEncodeFunction*(obj: ping): seq[uint8] = 
    result = result & TLEncode(int32(2059302892))
    result = result & TLEncode(obj.ping_id)


proc TLEncodeFunction*(obj: ping_delay_disconnect): seq[uint8] = 
    result = result & TLEncode(int32(-213746804))
    result = result & TLEncode(obj.ping_id)

    result = result & TLEncode(obj.disconnect_delay)


proc TLEncodeFunction*(obj: destroy_session): seq[uint8] = 
    result = result & TLEncode(int32(-414113498))
    result = result & TLEncode(obj.session_id)


proc TLEncodeFunction*(obj: http_wait): seq[uint8] = 
    result = result & TLEncode(int32(-1835453025))
    result = result & TLEncode(obj.max_delay)

    result = result & TLEncode(obj.wait_after)

    result = result & TLEncode(obj.max_wait)


proc TLEncodeGeneric*(obj: TLFunction): seq[uint8] = 
    if obj of req_pq:
        return cast[req_pq](obj).TLEncodeFunction()
    if obj of req_pq_multi:
        return cast[req_pq_multi](obj).TLEncodeFunction()
    if obj of req_DH_params:
        return cast[req_DH_params](obj).TLEncodeFunction()
    if obj of set_client_DH_params:
        return  cast[set_client_DH_params](obj).TLEncodeFunction()
    if obj of rpc_drop_answer:
        return  cast[rpc_drop_answer](obj).TLEncodeFunction()
    if obj of get_future_salts:
        return  cast[get_future_salts](obj).TLEncodeFunction()
    if obj of ping:
        return cast[ping](obj).TLEncodeFunction()
    if obj of ping_delay_disconnect:
        return cast[ping_delay_disconnect](obj).TLEncodeFunction()
    if obj of destroy_session:
        return cast[destroy_session](obj).TLEncodeFunction()
    if obj of http_wait:
        return cast[http_wait](obj).TLEncodeFunction()
    return TLEncodeApiGeneric(obj)