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

## Module implementing a raw MTProto session

import network/transports
import std/[asyncdispatch, options, times, math, sysrand, tables, logging, strformat]
import pkg/tltypes, pkg/tltypes/[decode, encode], types
import crypto/proto, network/generator
import ../utils/[exceptions, event_addons, message_id]
import pkg/nimcrypto/[sha, sha2]

const 
    START_TIMEOUT = 1
    WAIT_TIMEOUT = 15
    SLEEP_THRESHOLD = 10
    MAX_RETRIES = 5
    ACKS_THRESHOLD = 8
    PING_INTERVAL = 5
    NUM_FUTURE_SALTS = 64
    COMPRESSION_THESHOLD = when defined(nocompression): 0 else: 512


type
    Request = ref object
        body: TL
        event: AsyncEvent

    MTProtoSession* = ref object
        connectionInfo: ConnectionInfo
        connection: MTProtoNetwork
        connected: AsyncEventSet     
        requests: Table[int64, Request]

        isCdn: bool
        isMedia: bool
        isTestMode: bool
        dcID: int

        networkTask: Future[void]

        pendingAcks: seq[uint64]
        storedMessageids: seq[int64]

        # encryption things
        seqNo: int
        messageID: MessageID
        salts: seq[Salt]
        authKey: seq[uint8]
        sessionID: seq[uint8]
        authKeyID: seq[uint8]

proc logPrefix(self: MTProtoSession): string = 
    let media = if self.isMedia: "_MEDIA" else: ""
    let test = if self.isTestMode: "_TESTMODE" else: ""
    let cdn = if self.isCdn: "_CDN" else: ""

    return &"[SESSION DC{self.dcID}{media}{test}{cdn}]"


proc processBadNotification(self: MTProtoSession, badNotification: BadMsgNotificationI) =
    
    if badNotification of Bad_server_salt:
        discard
        # TODO: Fix salt

    elif badNotification of Bad_msg_notification:        
        let code = badNotification.Bad_msg_notification.error_code
        case code:
        of 32:
            self.seqNo += 64
        of 33:
            self.seqNo -= 32
        else:
            debug(&"{self.logPrefix} Got unknown bad_msg_notification code {code}")
            discard

proc processMessage*(self: MTProtoSession, data: TLStream) {.async.} =
    let data = decryptMessage(data, self.authKey, self.authKeyID, self.sessionID)
    
    let messages = if data.body of MessageContainer: data.body.MessageContainer.messages else: @[data]
    # TODO: security check
    
    for message in messages:
        if message.seqNo == 0:
            self.messageID.updateTime(int64(message.msgID) div (2 ^ 32))

        if message.seqNo mod 2 != 0:
            if message.msgID in self.pendingAcks:
                continue
            else:
                self.pendingAcks.add(message.msgID)
        
        var messageID = 0'u64
        var body = message.body

        debug(&"{self.logPrefix} Received message with type ", message.body.nameByConstructorID())

        case message.body.nameByConstructorID():
        of "Msg_detailed_info":
            self.pendingAcks.add(message.body.Msg_detailed_info.answer_msg_id)
            continue
        of "Msg_new_detailed_info":
            self.pendingAcks.add(message.body.Msg_new_detailed_info.answer_msg_id)
            continue
        
        of "Ping":
            discard
            # TODO: Reply with Pong
        of "Pong":
            messageID = message.body.Pong.msg_id
            
        
        of "Bad_msg_notification":
            self.processBadNotification(message.body.BadMsgNotificationI)
            messageID = message.body.Bad_msg_notification.bad_msg_id
        of "Bad_server_salt":
            self.processBadNotification(message.body.BadMsgNotificationI)
            messageID = message.body.Bad_server_salt.bad_msg_id

        of "Future_salts":
            messageID = message.body.Future_salts.req_msg_id

        of "Rpc_result":
            messageID = message.body.Rpc_result.req_msg_id
            body = message.body.Rpc_result.result
        else: 
            debug(&"{self.logPrefix} Got unhandled type: ", message.body.nameByConstructorID())
       
        if body of GZipContent:
            body = body.GZipContent.value

        if cast[int64](messageID) in self.requests:
            debug(&"{self.logPrefix} Got result for message &{messageID}")
            self.requests[cast[int64](messageID)].body = body
            self.requests[cast[int64](messageID)].event.trigger()
        
        if self.pendingAcks.len >= ACKS_THRESHOLD:
            # TODO: send MsgsAck
            discard

proc networkWorker(self: MTProtoSession) {.async.} =
    debug(&"{self.logPrefix} Starting networkWorker...")
    while true:
        var data: seq[uint8] = @[]
        try:
            data = await self.connection.receive()
        except: discard

        if data.len < 5:
            if data.len == 4:
                let data = decode.TLDecode[int32](newTLStream(data))
                warn(&"{self.logPrefix} Received {data} from Telegram")
     
            if self.connected.isSet():
                debug(&"{self.logPrefix} placeholder: should restart session")
                discard # TODO: RESTART THE SESSION
            break
        
        asyncCheck self.processMessage(newTLStream(data))

    debug(&"{self.logPrefix} networkWorker exited from loop")


proc send*(self: MTProtoSession, body: TL, waitResponse = true, timeout = WAIT_TIMEOUT): Future[TL] {.async.} =
    
    debug(&"{self.logPrefix} Sending {body.nameByConstructorID}...")

    let encrypted = encryptMessage(body, self.authKey, self.authKeyID, self.seqNo, self.salts, self.sessionID, uint64(self.messageID.get()))

    if waitResponse:
        self.requests[encrypted[1]] = Request(event: newAsyncEvent())

    try:
        await self.connection.write(encrypted[0])
    except:
        self.requests.del(encrypted[1])
        raise
    debug(&"{self.logPrefix} Sent {body.nameByConstructorID}, waiting for response...")

    if waitResponse:
        let ok = await withTimeout(waitEvent(self.requests[encrypted[1]].event), timeout * 1000)

        if not ok:
            raise newException(TimeoutError, &"Request timed out after waiting for {timeout} seconds")
        
        if self.requests[encrypted[1]].body == nil:
            self.requests.del(encrypted[1])
            raise newException(TimeoutError, &"The connection was closed without a response")

        
        result = self.requests[encrypted[1]].body
        self.requests.del(encrypted[1])

        if result of tl.Rpc_error:
            let error = tl.Rpc_error(result)
            let excpt = new exceptions.RPCError
            excpt.msg = error.error_message
            excpt.errorCode = error.error_code
            excpt.errorMessage = error.error_message
            raise excpt
        if result of Bad_msg_notification:
            let badMessage = result.Bad_msg_notification
            let excpt = new BadMessageError
            excpt.code = badMessage.error_code
            excpt.msg = &"Bad Message Notification: Error {excpt.code}"
            raise excpt
        if result of Bad_server_salt:
            # TODO: Find a better solution
            self.salts.setLen(0)
            self.salts.add(Salt(validUntil: 0, salt: TLEncode(result.Bad_server_salt.new_server_salt)))
            return await self.send(body, waitResponse, timeout)

proc stop*(self: MTProtoSession) {.async.} =
    debug(&"{self.logPrefix} Stopping session...")

    self.connected.clear()

    await self.connection.close()
    
    debug(&"{self.logPrefix} Waiting for networkWorker to exit...")

    await self.networkTask
    debug(&"{self.logPrefix} Triggering requests...")

    for _, request in self.requests: request.event.trigger()

    debug(&"{self.logPrefix} Session stopped")

proc createSession*(connectionInfo: ConnectionInfo, messageID: MessageID, authKey: seq[uint8], dcID: int, isTestMode = false, isMedia = false, isCdn = false): Future[MTProtoSession] {.async.} =
    
    result = MTProtoSession(
        connectionInfo: connectionInfo,
        seqNo: 1,
        salts: newSeq[Salt](),
        authKey: authKey,
        sessionID: urandom(8),
        authKeyID: sha1.digest(authKey).data[12..19],
        storedMessageids: newSeq[int64](),
        isTestMode: isTestMode,
        isMedia: isMedia,
        isCdn: isCdn,
        dcID: dcID,
        messageID: messageID,
        connected: newAsyncEventSet()
    )
    
    result.connection = createConnection(connectionInfo.connectionType, dcID, connectionInfo.ipv6, isTestMode, isMedia)
    
    # adding a fake salt because it is required, ONLY FOR TESTING
    result.salts.add(Salt(validUntil: uint64(now().toTime().toUnix()), salt: urandom(8)))
     
    debug(&"{result.logPrefix} Connecting to MTProto...")

    await result.connection.connect()

    result.networkTask = result.networkWorker()
    asyncCheck result.networkTask

    discard await result.send(Ping(ping_id: 0).setConstructorID, timeout=START_TIMEOUT)

    if not result.isCdn:
        discard await result.send(InvokeWithLayer(layer: LAYER_VERSION, query: InitConnection(api_id: result.connectionInfo.apiID, device_model: result.connectionInfo.deviceModel, system_version: result.connectionInfo.systemVersion,
            app_version: result.connectionInfo.appVersion, system_lang_code: result.connectionInfo.systemLangCode,
            lang_pack: result.connectionInfo.langPack, lang_code: result.connectionInfo.langCode, 
            query: HelpGetAppConfig().setConstructorID()).setConstructorID).setConstructorID,
        timeout=START_TIMEOUT)


    debug(&"{result.logPrefix} Connected to MTProto")

    result.connected.set()