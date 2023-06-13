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

import pkg/tltypes/[decode, encode], pkg/tltypes, ige
import pkg/nimcrypto/[sha, sha2]

import std/sysrand

import ../../utils/[content_related, exceptions]

const 
    COMPRESSION_THRESHOLD = when defined(nocompression): 0 else: 512

proc decryptMessage*(stream: TLStream, authKey: seq[uint8], authKeyID: seq[uint8], sessionID: seq[uint8]): CoreMessage =
    securityCheck stream.readBytes(8) == authKeyID, "Response authkey id is different from saved one"

    var plaintextStream: TLStream
   
    block:
        let responseMsgKey = stream.readBytes(16)
        let a = sha256.digest(responseMsgKey & authKey[8..43]).data
        let b = sha256.digest(authKey[48..83] & responseMsgKey).data
        let aesKey = a[0..7] & b[8..23] & a[24..31]
        let aesIv = b[0..7] & a[8..23] & b[24..31]
        let plaintext = aesIGE(aesKey, aesIv, stream, false)
        securityCheck plaintext.len mod 4 == 0, "length of plaintext is not divisible by 4"

        let msgKey = sha256.digest(authKey[96..127] & plaintext).data[8..23]
        securityCheck msgKey == responseMsgKey, "Computed MsgKey is different from response"
        plaintextStream = newTLStream(plaintext)

    securityCheck plaintextStream.readBytes(16)[8..15] == sessionID, "Local session id is different from response"
    
    result = plaintextStream.TLDecodeCoreMessage()

    let padding = plaintextStream.readAll()
    securityCheck len(padding) >= 12 and len(padding) <= 1024, "Got an invalid padding"



proc encryptMessage*(body: TL, authKey: seq[uint8], authKeyID: seq[uint8], seqNon: var int, salt: seq[uint8], sessionID: seq[uint8], messageID: uint64): (seq[uint8], int64, int) =
    seqNon = int(seqNo(if body.nameByConstructorID() in NOT_RELATED_TYPES: false else: true, seqNon))
    var encoded = body.TLEncode()

    if COMPRESSION_THRESHOLD != 0 and len(encoded) > COMPRESSION_THRESHOLD:
        let compressed = GZipContent(value: body).setConstructorID().TLEncode()
        
        if compressed.len() < encoded.len():
            encoded = compressed
    
    var 
        payloadStream: TLStream
        messageKey: seq[uint8]

    block:
        var payload = salt & sessionID & messageID.TLEncode() & uint32(
                seqNon).TLEncode() & uint32(len(encoded)).TLEncode() & encoded
        payload.add(urandom((len(payload) + 12) mod 16 + 12))
        while true:
            if len(payload) mod 16 == 0 and len(payload) mod 4 == 0:
                break
            payload.add(1)
        messageKey = sha256.digest(authKey[88..119] & payload).data[8..23]
        payloadStream = newTLStream(payload)

    let a = sha256.digest(messageKey & authKey[0..35]).data
    let b = sha256.digest(authKey[40..75] & messageKey).data

    let aesKey = a[0..7] & b[8..23] & a[24..31]
    let aesIV = b[0..7] & a[8..23] & b[24..31]

    return ((authKeyID & messageKey & aesIGE(aesKey,
            aesIV, payloadStream, true)), cast[int64](messageID), seqNon)