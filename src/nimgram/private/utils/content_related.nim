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
        "RpcDropAnswer",
        "RpcAnswerUnknown",
        "RpcAnswerDroppedRunning",
        "RpcAnswerDropped",
        "GetFutureSalts",
        "FutureSalt",
        "FutureSalts",
        "Ping",
        "Pong",
        "PingDelayDisconnect",
        "DestroySession",
        "DestroySessionOk",
        "DestroySessionNone",
        "MessageContainer",
        "GZipContent",
        "HttpWait",
        "MsgsAck",
        "BadMsgNotification",
        "BadServerSalt",
        "MsgsStateReq",
        "MsgsStateInfo",
        "MsgsAllInfo",
        "MsgDetailedInfo",
        "MsgNewDetailedInfo",
        "MsgResendReq"
]