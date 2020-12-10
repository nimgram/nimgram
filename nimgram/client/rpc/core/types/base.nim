
type
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


type
    ResPQ* = ref object of ResPQI
        nonce*: Int128
        server_nonce*: Int128
        pq*: seq[uint8]
        server_public_key_fingerprints*: seq[int64]
    P_q_inner_data* = ref object of P_Q_inner_dataI
        pq*: seq[uint8]
        p*: seq[uint8]
        q*: seq[uint8]
        nonce*: Int128
        server_nonce*: Int128
        new_nonce*: Int256
    Server_DH_params_fail* = ref object of Server_DH_ParamsI
        nonce*: Int128
        server_nonce*: Int128
        new_nonce_hash*: Int128
    Server_DH_params_ok* = ref object of Server_DH_ParamsI
        nonce*: Int128
        server_nonce*: Int128
        encrypted_answer*: seq[uint8]
    Server_DH_inner_data* = ref object of Server_DH_inner_dataI
        nonce*: Int128
        server_nonce*: Int128
        g*: int32
        dh_prime*: seq[uint8]
        g_a*: seq[uint8]
        server_time*: int32
    Client_DH_inner_data* = ref object of Client_DH_Inner_DataI
        nonce*: Int128
        server_nonce*: Int128
        retry_id*: int64
        g_b*: seq[uint8]
    Dh_gen_ok* = ref object of Set_client_DH_params_answerI
        nonce*: Int128
        server_nonce*: Int128
        new_nonce_hash1*: Int128
    Dh_gen_retry* = ref object of Set_client_DH_params_answerI
        nonce*: Int128
        server_nonce*: Int128
        new_nonce_hash2*: Int128
    Dh_gen_fail* = ref object of Set_client_DH_params_answerI
        nonce*: Int128
        server_nonce*: Int128
        new_nonce_hash3*: Int128
    Rpc_result* = ref object of RpcResultI
        req_msg_id*: int64
        result*: TL
    Rpc_error* = ref object of RpcErrorI
        error_code*: int32
        error_message*: string
    Rpc_answer_unknown* = ref object of RpcDropAnswerI
    Rpc_answer_dropped_running* = ref object of RpcDropAnswerI
    Rpc_answer_dropped* = ref object of RpcDropAnswerI
        msg_id*: int64
        seq_no*: int32
        bytes*: int32
    Pong* = ref object of PongI
        msg_id*: int64
        ping_id*: int64
    Destroy_session_ok* = ref object of DestroySessionResI
        session_id*: int64
    Destroy_session_none* = ref object of DestroySessionResI
        session_id*: int64
    New_session_created* = ref object of NewSessionI
        first_msg_id*: int64
        unique_id*: int64
        server_salt*: int64
    Msgs_ack* = ref object of MsgsAckI
        msg_ids*: seq[int64]
    Bad_msg_notification* = ref object of BadMsgNotificationI
        bad_msg_id*: int64
        bad_msg_seqno*: int32
        error_code*: int32
    Bad_server_salt* = ref object of BadMsgNotificationI
        bad_msg_id*: int64
        bad_msg_seqno*: int32
        error_code*: int32
        new_server_salt*: int64
    Msg_resend_req* = ref object of MsgResendReqI
        msg_ids*: seq[int64]
    Msgs_state_req* = ref object of MsgsStateReqI
        msg_ids*: seq[int64]
    Msgs_state_info* = ref object of MsgsStateInfoI
        req_msg_id*: int64
        info*: seq[uint8]
    Msgs_all_info* = ref object of MsgsAllInfoI
        msg_ids*: seq[int64]
        info*: seq[uint8]
    Msg_detailed_info* = ref object of MsgDetailedInfoI
        msg_id*: int64
        answer_msg_id*: int64
        bytes*: int32
        status*: int32
    Msg_new_detailed_info* = ref object of MsgDetailedInfoI
        answer_msg_id*: int64
        bytes*: int32
        status*: int32

method getTypeName*(self: ResPQ): string = "ResPQ"
method getTypeName*(self: P_q_inner_data): string = "P_q_inner_data"
method getTypeName*(self: Server_DH_params_fail): string = "Server_DH_params_fail"
method getTypeName*(self: Server_DH_params_ok): string = "Server_DH_params_ok"
method getTypeName*(self: Server_DH_inner_data): string = "Server_DH_inner_data"
method getTypeName*(self: Client_DH_inner_data): string = "Client_DH_inner_data"
method getTypeName*(self: Dh_gen_ok): string = "Dh_gen_ok"
method getTypeName*(self: Dh_gen_retry): string = "Dh_gen_retry"
method getTypeName*(self: Dh_gen_fail): string = "Dh_gen_fail"
method getTypeName*(self: Rpc_result): string = "Rpc_result"
method getTypeName*(self: Rpc_error): string = "Rpc_error"
method getTypeName*(self: Rpc_answer_unknown): string = "Rpc_answer_unknown"
method getTypeName*(self: Rpc_answer_dropped_running): string = "Rpc_answer_dropped_running"
method getTypeName*(self: Rpc_answer_dropped): string = "Rpc_answer_dropped"
method getTypeName*(self: Pong): string = "Pong"
method getTypeName*(self: Destroy_session_ok): string = "Destroy_session_ok"
method getTypeName*(self: Destroy_session_none): string = "Destroy_session_none"
method getTypeName*(self: New_session_created): string = "New_session_created"
method getTypeName*(self: Msgs_ack): string = "Msgs_ack"
method getTypeName*(self: Bad_msg_notification): string = "Bad_msg_notification"
method getTypeName*(self: Bad_server_salt): string = "Bad_server_salt"
method getTypeName*(self: Msg_resend_req): string = "Msg_resend_req"
method getTypeName*(self: Msgs_state_req): string = "Msgs_state_req"
method getTypeName*(self: Msgs_state_info): string = "Msgs_state_info"
method getTypeName*(self: Msgs_all_info): string = "Msgs_all_info"
method getTypeName*(self: Msg_detailed_info): string = "Msg_detailed_info"
method getTypeName*(self: Msg_new_detailed_info): string = "Msg_new_detailed_info"

method TLEncode*(self: ResPQ): seq[uint8] =
    result = TLEncode(uint32(0x05162463))
    result = result & TLEncode(self.nonce)
    result = result & TLEncode(self.server_nonce)
    result = result & TLEncode(self.pq)
    result = result & TLEncode(self.server_public_key_fingerprints)
method TLDecode*(self: ResPQ, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.nonce)
    bytes.TLDecode(addr self.server_nonce)
    self.pq = bytes.TLDecode()
    bytes.TLDecode(self.server_public_key_fingerprints)
method TLEncode*(self: P_q_inner_data): seq[uint8] =
    result = TLEncode(uint32(0x83c95aec))
    result = result & TLEncode(self.pq)
    result = result & TLEncode(self.p)
    result = result & TLEncode(self.q)
    result = result & TLEncode(self.nonce)
    result = result & TLEncode(self.server_nonce)
    result = result & TLEncode(self.new_nonce)
method TLDecode*(self: P_q_inner_data, bytes: var ScalingSeq[uint8]) = 
    self.pq = bytes.TLDecode()
    self.p = bytes.TLDecode()
    self.q = bytes.TLDecode()
    bytes.TLDecode(addr self.nonce)
    bytes.TLDecode(addr self.server_nonce)
    bytes.TLDecode(addr self.new_nonce)
method TLEncode*(self: Server_DH_params_fail): seq[uint8] =
    result = TLEncode(uint32(0x79cb045d))
    result = result & TLEncode(self.nonce)
    result = result & TLEncode(self.server_nonce)
    result = result & TLEncode(self.new_nonce_hash)
method TLDecode*(self: Server_DH_params_fail, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.nonce)
    bytes.TLDecode(addr self.server_nonce)
    bytes.TLDecode(addr self.new_nonce_hash)
method TLEncode*(self: Server_DH_params_ok): seq[uint8] =
    result = TLEncode(uint32(0xd0e8075c))
    result = result & TLEncode(self.nonce)
    result = result & TLEncode(self.server_nonce)
    result = result & TLEncode(self.encrypted_answer)
method TLDecode*(self: Server_DH_params_ok, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.nonce)
    bytes.TLDecode(addr self.server_nonce)
    self.encrypted_answer = bytes.TLDecode()
method TLEncode*(self: Server_DH_inner_data): seq[uint8] =
    result = TLEncode(uint32(0xb5890dba))
    result = result & TLEncode(self.nonce)
    result = result & TLEncode(self.server_nonce)
    result = result & TLEncode(self.g)
    result = result & TLEncode(self.dh_prime)
    result = result & TLEncode(self.g_a)
    result = result & TLEncode(self.server_time)
method TLDecode*(self: Server_DH_inner_data, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.nonce)
    bytes.TLDecode(addr self.server_nonce)
    bytes.TLDecode(addr self.g)
    self.dh_prime = bytes.TLDecode()
    self.g_a = bytes.TLDecode()
    bytes.TLDecode(addr self.server_time)
method TLEncode*(self: Client_DH_inner_data): seq[uint8] =
    result = TLEncode(uint32(0x6643b654))
    result = result & TLEncode(self.nonce)
    result = result & TLEncode(self.server_nonce)
    result = result & TLEncode(self.retry_id)
    result = result & TLEncode(self.g_b)
method TLDecode*(self: Client_DH_inner_data, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.nonce)
    bytes.TLDecode(addr self.server_nonce)
    bytes.TLDecode(addr self.retry_id)
    self.g_b = bytes.TLDecode()
method TLEncode*(self: Dh_gen_ok): seq[uint8] =
    result = TLEncode(uint32(0x3bcbf734))
    result = result & TLEncode(self.nonce)
    result = result & TLEncode(self.server_nonce)
    result = result & TLEncode(self.new_nonce_hash1)
method TLDecode*(self: Dh_gen_ok, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.nonce)
    bytes.TLDecode(addr self.server_nonce)
    bytes.TLDecode(addr self.new_nonce_hash1)
method TLEncode*(self: Dh_gen_retry): seq[uint8] =
    result = TLEncode(uint32(0x46dc1fb9))
    result = result & TLEncode(self.nonce)
    result = result & TLEncode(self.server_nonce)
    result = result & TLEncode(self.new_nonce_hash2)
method TLDecode*(self: Dh_gen_retry, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.nonce)
    bytes.TLDecode(addr self.server_nonce)
    bytes.TLDecode(addr self.new_nonce_hash2)
method TLEncode*(self: Dh_gen_fail): seq[uint8] =
    result = TLEncode(uint32(0xa69dae02))
    result = result & TLEncode(self.nonce)
    result = result & TLEncode(self.server_nonce)
    result = result & TLEncode(self.new_nonce_hash3)
method TLDecode*(self: Dh_gen_fail, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.nonce)
    bytes.TLDecode(addr self.server_nonce)
    bytes.TLDecode(addr self.new_nonce_hash3)
method TLEncode*(self: Rpc_result): seq[uint8] =
    result = TLEncode(uint32(0xf35c6d01))
    result = result & TLEncode(self.req_msg_id)
    result = result & TLEncode(self.result)
method TLDecode*(self: Rpc_result, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.req_msg_id)
    self.result.TLDecode(bytes)
method TLEncode*(self: Rpc_error): seq[uint8] =
    result = TLEncode(uint32(0x2144ca19))
    result = result & TLEncode(self.error_code)
    result = result & TLEncode(self.error_message)
method TLDecode*(self: Rpc_error, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.error_code)
    self.error_message = cast[string](bytes.TLDecode())
method TLEncode*(self: Rpc_answer_unknown): seq[uint8] =
    result = TLEncode(uint32(0x5e2ad36e))
method TLDecode*(self: Rpc_answer_unknown, bytes: var ScalingSeq[uint8]) = 
    discard
method TLEncode*(self: Rpc_answer_dropped_running): seq[uint8] =
    result = TLEncode(uint32(0xcd78e586))
method TLDecode*(self: Rpc_answer_dropped_running, bytes: var ScalingSeq[uint8]) = 
    discard
method TLEncode*(self: Rpc_answer_dropped): seq[uint8] =
    result = TLEncode(uint32(0xa43ad8b7))
    result = result & TLEncode(self.msg_id)
    result = result & TLEncode(self.seq_no)
    result = result & TLEncode(self.bytes)
method TLDecode*(self: Rpc_answer_dropped, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.msg_id)
    bytes.TLDecode(addr self.seq_no)
    bytes.TLDecode(addr self.bytes)
method TLEncode*(self: Pong): seq[uint8] =
    result = TLEncode(uint32(0x347773c5))
    result = result & TLEncode(self.msg_id)
    result = result & TLEncode(self.ping_id)
method TLDecode*(self: Pong, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.msg_id)
    bytes.TLDecode(addr self.ping_id)
method TLEncode*(self: Destroy_session_ok): seq[uint8] =
    result = TLEncode(uint32(0xe22045fc))
    result = result & TLEncode(self.session_id)
method TLDecode*(self: Destroy_session_ok, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.session_id)
method TLEncode*(self: Destroy_session_none): seq[uint8] =
    result = TLEncode(uint32(0x62d350c9))
    result = result & TLEncode(self.session_id)
method TLDecode*(self: Destroy_session_none, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.session_id)
method TLEncode*(self: New_session_created): seq[uint8] =
    result = TLEncode(uint32(0x9ec20908))
    result = result & TLEncode(self.first_msg_id)
    result = result & TLEncode(self.unique_id)
    result = result & TLEncode(self.server_salt)
method TLDecode*(self: New_session_created, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.first_msg_id)
    bytes.TLDecode(addr self.unique_id)
    bytes.TLDecode(addr self.server_salt)
method TLEncode*(self: Msgs_ack): seq[uint8] =
    result = TLEncode(uint32(0x62d6b459))
    result = result & TLEncode(self.msg_ids)
method TLDecode*(self: Msgs_ack, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(self.msg_ids)
method TLEncode*(self: Bad_msg_notification): seq[uint8] =
    result = TLEncode(uint32(0xa7eff811))
    result = result & TLEncode(self.bad_msg_id)
    result = result & TLEncode(self.bad_msg_seqno)
    result = result & TLEncode(self.error_code)
method TLDecode*(self: Bad_msg_notification, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.bad_msg_id)
    bytes.TLDecode(addr self.bad_msg_seqno)
    bytes.TLDecode(addr self.error_code)
method TLEncode*(self: Bad_server_salt): seq[uint8] =
    result = TLEncode(uint32(0xedab447b))
    result = result & TLEncode(self.bad_msg_id)
    result = result & TLEncode(self.bad_msg_seqno)
    result = result & TLEncode(self.error_code)
    result = result & TLEncode(self.new_server_salt)
method TLDecode*(self: Bad_server_salt, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.bad_msg_id)
    bytes.TLDecode(addr self.bad_msg_seqno)
    bytes.TLDecode(addr self.error_code)
    bytes.TLDecode(addr self.new_server_salt)
method TLEncode*(self: Msg_resend_req): seq[uint8] =
    result = TLEncode(uint32(0x7d861a08))
    result = result & TLEncode(self.msg_ids)
method TLDecode*(self: Msg_resend_req, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(self.msg_ids)
method TLEncode*(self: Msgs_state_req): seq[uint8] =
    result = TLEncode(uint32(0xda69fb52))
    result = result & TLEncode(self.msg_ids)
method TLDecode*(self: Msgs_state_req, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(self.msg_ids)
method TLEncode*(self: Msgs_state_info): seq[uint8] =
    result = TLEncode(uint32(0x04deb57d))
    result = result & TLEncode(self.req_msg_id)
    result = result & TLEncode(self.info)
method TLDecode*(self: Msgs_state_info, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.req_msg_id)
    self.info = bytes.TLDecode()
method TLEncode*(self: Msgs_all_info): seq[uint8] =
    result = TLEncode(uint32(0x8cc0d131))
    result = result & TLEncode(self.msg_ids)
    result = result & TLEncode(self.info)
method TLDecode*(self: Msgs_all_info, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(self.msg_ids)
    self.info = bytes.TLDecode()
method TLEncode*(self: Msg_detailed_info): seq[uint8] =
    result = TLEncode(uint32(0x276d3ec6))
    result = result & TLEncode(self.msg_id)
    result = result & TLEncode(self.answer_msg_id)
    result = result & TLEncode(self.bytes)
    result = result & TLEncode(self.status)
method TLDecode*(self: Msg_detailed_info, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.msg_id)
    bytes.TLDecode(addr self.answer_msg_id)
    bytes.TLDecode(addr self.bytes)
    bytes.TLDecode(addr self.status)
method TLEncode*(self: Msg_new_detailed_info): seq[uint8] =
    result = TLEncode(uint32(0x809db6df))
    result = result & TLEncode(self.answer_msg_id)
    result = result & TLEncode(self.bytes)
    result = result & TLEncode(self.status)
method TLDecode*(self: Msg_new_detailed_info, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.answer_msg_id)
    bytes.TLDecode(addr self.bytes)
    bytes.TLDecode(addr self.status)
