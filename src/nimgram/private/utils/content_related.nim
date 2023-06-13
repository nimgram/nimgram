# Nimgram
# Copyright (C) 2020-2023 Daniele Cortesi <https://github.com/dadadani>
# This file is part of Nimgram, under the MIT License
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

const NOT_RELATED_TYPES* = [
        "Rpc_drop_answer",
        "Rpc_answer_unknown",
        "Rpc_answer_dropped_running",
        "Rpc_answer_dropped",
        "Get_future_salts",
        "FutureSalt",
        "FutureSalts",
        "Ping",
        "Pong",
        "Ping_delay_disconnect",
        "Destroy_session",
        "Destroy_session_ok",
        "Destroy_session_none",
        "MessageContainer",
        "GZipContent",
        "Http_wait",
        "Msgs_ack",
        "Bad_msg_notification",
        "Bad_server_salt",
        "Msgs_state_req",
        "Msgs_state_info",
        "Msgs_all_info",
        "Msg_detailed_info",
        "Msg_new_detailed_info",
        "Msg_resend_req"
]