# Nimgram
# Copyright (C) 2020-2022 Daniele Cortesi <https://github.com/dadadani>
# This file is part of Nimgram, under the MIT License
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import pkg/tltypes/[decode, encode], pkg/tltypes, ige
import pkg/nimcrypto/[sha, sha2]

import std/sysrand

import ../types

proc decryptMessage*(stream: TLStream, authKey: seq[uint8], authKeyID: seq[uint8], sessionID: seq[uint8]): CoreMessage =
    doAssert stream.readBytes(8) == authKeyID, "Response authkey id is different from saved one"
    let responseMsgKey = stream.readBytes(16)
    let a = sha256.digest(responseMsgKey & authKey[8..43]).data
    let b = sha256.digest(authKey[48..83] & responseMsgKey).data
    let aesKey = a[0..7] & b[8..23] & a[24..31]
    let aesIv = b[0..7] & a[8..23] & b[24..31]
    let plaintext = aesIGE(aesKey, aesIv, stream.readAll(), false)
    let msgKey = sha256.digest(authKey[96..127] & plaintext).data[8..23]
    doAssert msgKey == responseMsgKey, "Computed MsgKey is different from response"
    let plaintextStream = newTLStream(plaintext)

    let responseSessionID = plaintextStream.readBytes(16)[8..15]
    doAssert responseSessionID == sessionID, "Local session id is different from response"
    return plaintextStream.TLDecodeCoreMessage()


proc encryptMessage*(body: TL, authKey: seq[uint8], authKeyID: seq[uint8], seqNon: var int, salts: seq[Salt], sessionID: seq[uint8], messageID: uint64): (seq[uint8], int64, int) =
    seqNon = int(seqNo(if body of MessageContainer or body of Ping or
            body of Msgs_ack: false else: true, seqNon))
    let body = body.TLEncode()

    var payload = salts[salts.high].salt & sessionID & messageID.TLEncode() & uint32(
            seqNon).TLEncode() & uint32(len(body)).TLEncode() & body
    payload.add(urandom((len(payload) + 12) mod 16 + 12))
    while true:
        if len(payload) mod 16 == 0 and len(payload) mod 4 == 0:
            break
        payload.add(1)

    let messageKey = sha256.digest(authKey[88..119] & payload).data[8..23]
    let a = sha256.digest(messageKey & authKey[0..35]).data
    let b = sha256.digest(authKey[40..75] & messageKey).data

    let aesKey = a[0..7] & b[8..23] & a[24..31]
    let aesIV = b[0..7] & a[8..23] & b[24..31]

    return ((authKeyID & messageKey & aesIGE(aesKey,
            aesIV, payload, true)), cast[int64](messageID), seqNon)