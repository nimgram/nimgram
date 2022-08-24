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
import std/[asyncdispatch, times, math, sysrand, tables, logging, strformat]
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
    SALT_USE_DELAY = 60
    STORED_MSG_IDS_MAX_SIZE = 1000 * 2

type
    Request = ref object
        body: TL
        event: AsyncEvent

    MTProtoSession* = ref object
        connectionInfo: ConnectionInfo
        connection: MTProtoNetwork
        connected: AsyncEventSet 
        pingStopEvent: AsyncEventSet   
        requests: Table[int64, Request]

        isCdn: bool
        isMedia: bool
        isTestMode: bool
        dcID: int
        requestedSalts: bool
        networkTask: Future[void]
        pingTask: Future[void]
        pendingAcks: seq[uint64]
        storedMessageIds: seq[int64]

        # encryption things
        seqNo: int
        messageID: MessageID
        salts: seq[FutureSalt]
        authKey: seq[uint8]
        sessionID: seq[uint8]
        authKeyID: seq[uint8]

proc logPrefix(self: MTProtoSession): string = 
    let media = if self.isMedia: "_MEDIA" else: ""
    let test = if self.isTestMode: "_TESTMODE" else: ""
    let cdn = if self.isCdn: "_CDN" else: ""

    return &"[SESSION DC{self.dcID}{media}{test}{cdn}]"

proc getSalt*(self: MTProtoSession): Future[seq[uint8]] {.async.} 

proc send*(self: MTProtoSession, body: TL, waitResponse = true, timeout = WAIT_TIMEOUT): Future[TL] {.async.} =
    
    debug(&"{self.logPrefix} Sending {body.nameByConstructorID}...")

    let encrypted = encryptMessage(body, self.authKey, self.authKeyID, self.seqNo, await self.getSalt(), self.sessionID, uint64(self.messageID.get()))

    if waitResponse:
        self.requests[encrypted[1]] = Request(event: newAsyncEvent())

    try:
        await self.connection.write(encrypted[0])
    except:
        self.requests.del(encrypted[1])
        raise
    debug(&"{self.logPrefix} Sent {body.nameByConstructorID}")

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
            return await self.send(body, waitResponse, timeout)


proc getSalt*(self: MTProtoSession): Future[seq[uint8]] {.async.} = 
    result = @[0'u8,0,0,0,0,0,0,0]
    if self.salts.len > 0:
        return TLEncode(self.salts[self.salts.high].salt)
            # TODO: Find a proper implementation, i can't get this to work 


proc processBadNotification(self: MTProtoSession, badNotification: BadMsgNotificationI, msgID: int64) =
    
    if badNotification of Bad_server_salt:
        self.salts.setLen(0)
        self.salts.add(FutureSalt(validUntil: high(uint32), validSince: 0, salt: badNotification.Bad_server_salt.new_server_salt))
        #TODO: Update storage

    elif badNotification of Bad_msg_notification:        
        let code = badNotification.Bad_msg_notification.error_code
        case code:
        of 32: # seqno is too low, increase it
            self.seqNo += 64
        of 33: # seqno is too high, decrease it
            self.seqNo -= 32
        of 16: # message id is too low, update it
            self.messageID.updateTime(msgID div (2 ^ 32), true)
        of 17: # message id is too high, update it
            self.messageID.updateTime(msgID div (2 ^ 32), true)
        else: 
            debug(&"{self.logPrefix} Got unknown bad_msg_notification code {code}")
            discard

proc processFutureSalts(self: MTProtoSession, futureSalts: FutureSalts) =
    self.salts = futureSalts.salts

proc processMessage*(self: MTProtoSession, data: TLStream) {.async.} =
    # Decrypt the message as a CoreMessage
    let data = decryptMessage(data, self.authKey, self.authKeyID, self.sessionID)
    
    # Security checks 

    if len(self.storedMessageIds) > STORED_MSG_IDS_MAX_SIZE:
        self.storedMessageIds = self.storedMessageIds[STORED_MSG_IDS_MAX_SIZE div 2 .. ^1]
    
    if len(self.storedMessageIds) > 0:
        securityCheck cast[int64](data.msgID) > self.storedMessageIds[0], "msgID is lower than all of the stored values"

        securityCheck not(cast[int64](data.msgID) in self.storedMessageIds), "msgID is equal to any of the stored values"
        
        let timeDiff = (cast[int64](data.msgID) - self.messageID.get()) div 2 ^ 32

        securityCheck timeDiff <= 30, "msgID belongs over 30 seconds in the future"

        securityCheck timeDiff > -300, "msgID belongs over 300 seconds in the past"

    # If the message is a MessageContainer, take it, otherwise make a sequence with "data"

    let messages = if data.body of MessageContainer: data.body.MessageContainer.messages else: @[data]
    
    for message in messages:

        # When we first initialize the session, we don't have the time synchronized yet
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
        # We need to ack these messages at some point
        of "Msg_detailed_info":
            self.pendingAcks.add(message.body.Msg_detailed_info.answer_msg_id)
            continue
        of "Msg_new_detailed_info":
            self.pendingAcks.add(message.body.Msg_new_detailed_info.answer_msg_id)
            continue
        
        # Ping may be sent from Telegram, we need to answer with Pong
        of "Ping":
            discard await self.send(Pong(ping_id: message.body.Ping.ping_id, msg_id: message.msgID), false)
        of "Pong":
            messageID = message.body.Pong.msg_id
            
        
        of "Bad_msg_notification":
            self.processBadNotification(message.body.BadMsgNotificationI, int64(message.msgID))
            messageID = message.body.Bad_msg_notification.bad_msg_id
        of "Bad_server_salt":
            self.processBadNotification(message.body.BadMsgNotificationI, int64(message.msgID))
            messageID = message.body.Bad_server_salt.bad_msg_id

        of "FutureSalts":
            messageID = message.body.FutureSalts.req_msg_id
            self.processFutureSalts(message.body.FutureSalts)
        # This is the actual object response of a rpc call
        of "Rpc_result":
            messageID = message.body.Rpc_result.req_msg_id
            body = message.body.Rpc_result.result
        else: 
            debug(&"{self.logPrefix} Got unhandled type: ", message.body.nameByConstructorID())
       
        if body of GZipContent:
            body = body.GZipContent.value

        if cast[int64](messageID) in self.requests:
            debug(&"{self.logPrefix} Got result for message {messageID}")
            self.requests[cast[int64](messageID)].body = body
            self.requests[cast[int64](messageID)].event.trigger()
        
        if self.pendingAcks.len >= ACKS_THRESHOLD:
            discard await self.send(Msgs_ack(msg_ids: self.pendingAcks), false)
            self.pendingAcks.setLen(0)


proc pingWorker(self: MTProtoSession) {.async.} =
    debug(&"{self.logPrefix} Starting pingWorker...")

    while true:
        let close = await withTimeout(waitEvent(self.pingStopEvent), PING_INTERVAL*1000)
        try: self.pingStopEvent.unregister() except: discard
        if close:
            break
        
        debug(&"{self.logPrefix} Sending ping")
        discard await self.send(Ping_delay_disconnect(ping_id: 0, disconnect_delay: WAIT_TIMEOUT + 10).setConstructorID, false)

    debug(&"{self.logPrefix} pingWorker exited from loop")

proc networkWorker(self: MTProtoSession) {.async.} 

proc stop*(self: MTProtoSession) {.async.} =
    ## Stop the session

    debug(&"{self.logPrefix} Stopping session...")

    self.connected.clear()

    await self.connection.close()
    
    self.pingStopEvent.set()
    debug(&"{self.logPrefix} Waiting for pingWorker to exit...")
    await self.pingTask
    self.pingStopEvent.clear()

    debug(&"{self.logPrefix} Waiting for networkWorker to exit...")
    await self.networkTask

    debug(&"{self.logPrefix} Triggering requests...")
    for _, request in self.requests: request.event.trigger()

    debug(&"{self.logPrefix} Session stopped")


proc start*(self: MTProtoSession) {.async.} =
    ## Start the session
    while true:
        var ok = false
        try:
            self.seqNo = 1
            self.sessionID = urandom(8)
            self.connected = newAsyncEventSet()
            self.pingStopEvent = newAsyncEventSet()

            self.connection = createConnection(self.connectionInfo.connectionType, self.dcID, self.connectionInfo.ipv6, self.isTestMode, self.isMedia)
                
            debug(&"{self.logPrefix} Connecting to MTProto...")

            await self.connection.connect()

            self.networkTask = self.networkWorker()
            asyncCheck self.networkTask

            discard await self.send(Ping(ping_id: 0).setConstructorID, timeout=START_TIMEOUT)

            if not self.isCdn:
                discard await self.send(InvokeWithLayer(layer: LAYER_VERSION, query: InitConnection(api_id: self.connectionInfo.apiID, device_model: self.connectionInfo.deviceModel, system_version: self.connectionInfo.systemVersion,
                    app_version: self.connectionInfo.appVersion, system_lang_code: self.connectionInfo.systemLangCode,
                    lang_pack: self.connectionInfo.langPack, lang_code: self.connectionInfo.langCode, 
                    query: HelpGetAppConfig().setConstructorID()).setConstructorID).setConstructorID,
                timeout=START_TIMEOUT)

            self.pingTask = self.pingWorker()
            asyncCheck self.pingTask
            ok = true
        except TimeoutError, exceptions.RPCError:
            await self.stop()
        except Exception:
            await self.stop()
            raise getCurrentException()
        finally:
            if ok: break
        
    debug(&"{self.logPrefix} Connected to MTProto")

    self.connected.set()


proc restart*(self: MTProtoSession) {.async.} = 
    ## Restart the session
    
    await self.stop()
    await self.start()

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
                debug(&"{self.logPrefix} Restarting the session...")
                asyncCheck self.restart()
            break
        
        asyncCheck self.processMessage(newTLStream(data))

    debug(&"{self.logPrefix} networkWorker exited from loop")


proc createSession*(connectionInfo: ConnectionInfo, messageID: MessageID, authKey: seq[uint8], firstSalt: uint64, dcID: int, isTestMode = false, isMedia = false, isCdn = false): Future[MTProtoSession] {.async.} =
    ## Create a new session

    result = MTProtoSession(
        connectionInfo: connectionInfo,
        seqNo: 1,
        salts: newSeq[FutureSalt](),
        authKey: authKey,
        sessionID: urandom(8),
        authKeyID: sha1.digest(authKey).data[12..19],
        storedMessageIds: newSeq[int64](),
        isTestMode: isTestMode,
        isMedia: isMedia,
        isCdn: isCdn,
        dcID: dcID,
        messageID: messageID,
        connected: newAsyncEventSet(),
        pingStopEvent: newAsyncEventSet()
    )
    
    result.salts.add(FutureSalt(validSince: 0, validUntil: high(uint32), salt: firstSalt))
