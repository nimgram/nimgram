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

## This file was generated automatically by the TL Parser (built at 2021-04-14T08:10:40+02:00)

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

method TLEncode*(self: Req_pq): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x60469778))
    result = result & TLEncode(self.nonce)
method TLDecode*(self: Req_pq, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.nonce)
method TLEncode*(self: Req_pq_multi): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xbe7e8ef1))
    result = result & TLEncode(self.nonce)
method TLDecode*(self: Req_pq_multi, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.nonce)
method TLEncode*(self: Req_DH_params): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xd712e4be))
    result = result & TLEncode(self.nonce)
    result = result & TLEncode(self.server_nonce)
    result = result & TLEncode(self.p)
    result = result & TLEncode(self.q)
    result = result & TLEncode(self.public_key_fingerprint)
    result = result & TLEncode(self.encrypted_data)
method TLDecode*(self: Req_DH_params, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.nonce)
    bytes.TLDecode(addr self.server_nonce)
    self.p = bytes.TLDecode()
    self.q = bytes.TLDecode()
    bytes.TLDecode(addr self.public_key_fingerprint)
    self.encrypted_data = bytes.TLDecode()
method TLEncode*(self: Set_client_DH_params): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf5045f1f))
    result = result & TLEncode(self.nonce)
    result = result & TLEncode(self.server_nonce)
    result = result & TLEncode(self.encrypted_data)
method TLDecode*(self: Set_client_DH_params, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.nonce)
    bytes.TLDecode(addr self.server_nonce)
    self.encrypted_data = bytes.TLDecode()
method TLEncode*(self: Rpc_drop_answer): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x58e4a740))
    result = result & TLEncode(self.req_msg_id)
method TLDecode*(self: Rpc_drop_answer, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.req_msg_id)
method TLEncode*(self: Get_future_salts): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb921bd04))
    result = result & TLEncode(self.num)
method TLDecode*(self: Get_future_salts, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.num)
method TLEncode*(self: Ping): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x7abe77ec))
    result = result & TLEncode(self.ping_id)
method TLDecode*(self: Ping, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.ping_id)
method TLEncode*(self: Ping_delay_disconnect): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf3427b8c))
    result = result & TLEncode(self.ping_id)
    result = result & TLEncode(self.disconnect_delay)
method TLDecode*(self: Ping_delay_disconnect, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.ping_id)
    bytes.TLDecode(addr self.disconnect_delay)
method TLEncode*(self: Destroy_session): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xe7512126))
    result = result & TLEncode(self.session_id)
method TLDecode*(self: Destroy_session, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.session_id)
method TLEncode*(self: Http_wait): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x9299359f))
    result = result & TLEncode(self.max_delay)
    result = result & TLEncode(self.wait_after)
    result = result & TLEncode(self.max_wait)
method TLDecode*(self: Http_wait, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.max_delay)
    bytes.TLDecode(addr self.wait_after)
    bytes.TLDecode(addr self.max_wait)
