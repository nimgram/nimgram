
type
    Req_pq* = ref object of TLFunction
        nonce*: Int128
    Req_pq_multi* = ref object of TLFunction
        nonce*: Int128
    Req_DH_params* = ref object of TLFunction
        nonce*: Int128
        server_nonce*: Int128
        p*: seq[uint8]
        q*: seq[uint8]
        public_key_fingerprint*: int64
        encrypted_data*: seq[uint8]
    Set_client_DH_params* = ref object of TLFunction
        nonce*: Int128
        server_nonce*: Int128
        encrypted_data*: seq[uint8]
    Rpc_drop_answer* = ref object of TLFunction
        req_msg_id*: int64
    Get_future_salts* = ref object of TLFunction
        num*: int32
    Ping* = ref object of TLFunction
        ping_id*: int64
    Ping_delay_disconnect* = ref object of TLFunction
        ping_id*: int64
        disconnect_delay*: int32
    Destroy_session* = ref object of TLFunction
        session_id*: int64
    Http_wait* = ref object of TLFunction
        max_delay*: int32
        wait_after*: int32
        max_wait*: int32
method getTypeName*(self: Req_pq): string = "Req_pq"
method getTypeName*(self: Req_pq_multi): string = "Req_pq_multi"
method getTypeName*(self: Req_DH_params): string = "Req_DH_params"
method getTypeName*(self: Set_client_DH_params): string = "Set_client_DH_params"
method getTypeName*(self: Rpc_drop_answer): string = "Rpc_drop_answer"
method getTypeName*(self: Get_future_salts): string = "Get_future_salts"
method getTypeName*(self: Ping): string = "Ping"
method getTypeName*(self: Ping_delay_disconnect): string = "Ping_delay_disconnect"
method getTypeName*(self: Destroy_session): string = "Destroy_session"
method getTypeName*(self: Http_wait): string = "Http_wait"

method TLEncode*(self: Req_pq): seq[uint8] =
    result = TLEncode(uint32(1615239032))
    result = result & TLEncode(self.nonce)
method TLDecode*(self: Req_pq, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.nonce)
method TLEncode*(self: Req_pq_multi): seq[uint8] =
    result = TLEncode(uint32(3195965169))
    result = result & TLEncode(self.nonce)
method TLDecode*(self: Req_pq_multi, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.nonce)
method TLEncode*(self: Req_DH_params): seq[uint8] =
    result = TLEncode(uint32(3608339646))
    result = result & TLEncode(self.nonce)
    result = result & TLEncode(self.server_nonce)
    result = result & TLEncode(self.p)
    result = result & TLEncode(self.q)
    result = result & TLEncode(self.public_key_fingerprint)
    result = result & TLEncode(self.encrypted_data)
method TLDecode*(self: Req_DH_params, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.nonce)
    bytes.TLDecode(addr self.server_nonce)
    self.p = bytes.TLDecode()
    self.q = bytes.TLDecode()
    bytes.TLDecode(addr self.public_key_fingerprint)
    self.encrypted_data = bytes.TLDecode()
method TLEncode*(self: Set_client_DH_params): seq[uint8] =
    result = TLEncode(uint32(4110704415))
    result = result & TLEncode(self.nonce)
    result = result & TLEncode(self.server_nonce)
    result = result & TLEncode(self.encrypted_data)
method TLDecode*(self: Set_client_DH_params, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.nonce)
    bytes.TLDecode(addr self.server_nonce)
    self.encrypted_data = bytes.TLDecode()
method TLEncode*(self: Rpc_drop_answer): seq[uint8] =
    result = TLEncode(uint32(1491380032))
    result = result & TLEncode(self.req_msg_id)
method TLDecode*(self: Rpc_drop_answer, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.req_msg_id)
method TLEncode*(self: Get_future_salts): seq[uint8] =
    result = TLEncode(uint32(3105996036))
    result = result & TLEncode(self.num)
method TLDecode*(self: Get_future_salts, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.num)
method TLEncode*(self: Ping): seq[uint8] =
    result = TLEncode(uint32(2059302892))
    result = result & TLEncode(self.ping_id)
method TLDecode*(self: Ping, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.ping_id)
method TLEncode*(self: Ping_delay_disconnect): seq[uint8] =
    result = TLEncode(uint32(4081220492))
    result = result & TLEncode(self.ping_id)
    result = result & TLEncode(self.disconnect_delay)
method TLDecode*(self: Ping_delay_disconnect, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.ping_id)
    bytes.TLDecode(addr self.disconnect_delay)
method TLEncode*(self: Destroy_session): seq[uint8] =
    result = TLEncode(uint32(3880853798))
    result = result & TLEncode(self.session_id)
method TLDecode*(self: Destroy_session, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.session_id)
method TLEncode*(self: Http_wait): seq[uint8] =
    result = TLEncode(uint32(2459514271))
    result = result & TLEncode(self.max_delay)
    result = result & TLEncode(self.wait_after)
    result = result & TLEncode(self.max_wait)
method TLDecode*(self: Http_wait, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.max_delay)
    bytes.TLDecode(addr self.wait_after)
    bytes.TLDecode(addr self.max_wait)
