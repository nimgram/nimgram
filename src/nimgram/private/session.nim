# Nimgram
# Copyright (C) 2020-2021 Daniele Cortesi <https://github.com/dadadani>
# This file is part of Nimgram, under the MIT License
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY
# OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import random/urandom
import rpc/decoding
import rpc/encoding
import crypto/aes
import stew/endians2
import nimcrypto
import math
import times

proc messageID(self: Session): uint64 =
    result = uint64(now().toTime().toUnix()*2 ^ 32)
    doAssert result mod 4 == 0, "message id is not divisible by 4, consider syncing your time."

    if result <= self.maxMessageID:
        result = self.maxMessageID + 4
    self.maxMessageID = result

proc initSession*(connection: MTProtoNetwork, logger: Logger, dcID: int,
        authKey: seq[uint8], serverSalt: seq[uint8],
        storageManager: NimgramStorage, config: NimgramConfig): Session =
    result = new Session
    result.acks = newSeq[int64](0)
    result.connection = connection
    result.resumeConnectionWait = newAsyncEvent()
    result.dcID = dcID
    result.authKey = authKey
    result.authKeyID = sha1.digest(authKey).data[12..19]
    result.storageManager = storageManager
    result.initDone = false
    result.alreadyCalledDisconnected = false
    result.serverSalt = serverSalt
    result.logger = logger
    result.seqNo = 11
    result.sessionID = urandom(8)
    result.clientConfig = config


type EncryptedResult = object
    encryptedData: seq[uint8]
    messageID: uint64

proc encrypt*(self: Session, obj: seq[uint8], typeof: TL): EncryptedResult =

    var data = obj
    var seqNumber = seqNo(typeof, self.seqNo)
    self.seqNo = seqNumber
    var mesageeID = self.messageID()
    result.messageID = mesageeID
    var payload = self.serverSalt & self.sessionID & mesageeID.TLEncode() &
            uint32(seqNumber).TLEncode() & uint32(len(data)).TLEncode() & data
    payload.add(urandom((len(payload) + 12) mod 16 + 12))
    while true:
        if len(payload) mod 16 == 0 and len(payload) mod 4 == 0:
            break
        payload.add(1)
    var messageKey = sha256.digest(self.authKey[88..119] & payload).data[8..23]
    var a = sha256.digest(messageKey & self.authKey[0..35]).data
    var b = sha256.digest(self.authKey[40..75] & messageKey).data

    var aesKey = a[0..7] & b[8..23] & a[24..31]
    var aesIV = b[0..7] & a[8..23] & b[24..31]
    result.encryptedData = self.authKeyID & messageKey & aesIGE(aesKey, aesIV,
            payload, true)


proc decrypt(self: Session, data: seq[uint8]): CoreMessage =
    var sdata = newScalingSeq(data)
    var authKeyId = sdata.readN(8)
    doAssert authKeyId == self.authKeyID, &"Response Auth Key Id {authKeyId} is different from saved one {self.authKeyID}"
    var responseMsgKey = sdata.readN(16)
    var a = sha256.digest(responseMsgKey & self.authKey[8..43]).data
    var b = sha256.digest(self.authKey[48..83] & responseMsgKey).data
    var aesKey = a[0..7] & b[8..23] & a[24..31]
    var aesIv = b[0..7] & a[8..23] & b[24..31]
    var encryptredata = sdata.readAll()
    var plaintext = aesIGE(aesKey, aesIv, encryptredata, false)
    var msgKey = sha256.digest(self.authKey[96..127] & plaintext).data[8..23]
    doAssert msgKey == responseMsgKey, "Computed Msg Key is different from response"
    var splaintext = newScalingSeq(plaintext)
    discard splaintext.readN(8)
    var responseSessionID = splaintext.readN(8)
    doAssert responseSessionID == self.sessionID, "Local session id is different from response"
    result = new CoreMessage
    result.TLDecode(splaintext)

proc mtprotoInit(self: Session, client: NimgramClient): Future[void] {.async.}

proc startHandler*(self: Session, client: NimgramClient,
        updateHandler: UpdateHandler) {.async.} =
    self.logger.log(lvlDebug, &"Initalizing handler on DC" & $self.dcID )

    while not self.connection.isClosed():
        var mdata: seq[uint8]
        try:
            var asyncReceive = self.connection.receive()
            var t = await withTimeout(asyncReceive, 11000)
            if not t:
                self.logger.log(lvlDebug, &"Timeout from Telegram on DC" & $self.dcID )

                break
            mdata = asyncReceive.waitFor

        except:
            self.logger.log(lvlDebug, &"Disconnected from Telegram on DC" & $self.dcID )

            break
        if len(mdata) == 0:
            self.logger.log(lvlError, &"Received 0 bytes from socket")

            break
        if len(mdata) == 4:
            self.logger.log(lvlError, &"Error response from Telegram")
            #TODO: How i can handle this?
            raise newException(CatchableError, "invalid response: " & $(cast[
                    int32](fromBytes(uint32, mdata))))
        var coreMessageDecrypted = self.decrypt(mdata)

        var messages: seq[CoreMessage]

        if coreMessageDecrypted.body of MessageContainer:
            messages = coreMessageDecrypted.body.MessageContainer.messages
        else:
            messages = @[coreMessageDecrypted]
        for message in messages:
            var body = message.body
            if not message.seqNo mod 2 == 0:
                if self.acks.contains(message.msgID.int64):
                    continue
                else:
                    self.acks.add(message.msgID.int64)

            var msgID = int64(0)
            self.seqNo = seqNo(body, self.seqNo)
            if message.body of Msg_detailed_info:
                self.acks.add(body.Msg_detailed_info.answer_msg_id)
                continue
            if message.body of Msg_new_detailed_info:
                self.acks.add(body.Msg_new_detailed_info.answer_msg_id)
                continue

            if message.body of New_session_created:
                if not self.initDone:
                    continue
                self.logger.log(lvlDebug, &"Got New_session_created on DC" & $self.dcID & ", Initializing again" )

                await mtprotoInit(self, client)
                continue

            if message.body of Bad_msg_notification:
                var code = body.Bad_msg_notification.error_code
                self.logger.log(lvlWarn,
                        &"Received bad_msg_notification with code {code}")
                msgID = body.Bad_msg_notification.bad_msg_id

            if message.body of Bad_server_salt:
                msgID = body.Bad_server_salt.bad_msg_id

            if message.body of FutureSalts:
                msgID = body.FutureSalts.reqMsgID.int64

            if message.body of Rpc_result:
                msgID = body.Rpc_result.req_msg_id
                body = body.Rpc_result.result

            if body of GZipPacked:
                body = body.GZipPacked.body

            if message.body of Pong:
                msgID = body.Pong.msgID

            if self.responses.contains(msgID):
                self.responses[msgID].body = body
                self.responses[msgID].event.trigger()


            if body of UpdatesTooLong or body of UpdateShortMessage or
                    body of UpdateShortChatMessage or body of UpdateShort or
                    body of UpdatesCombined or body of raw.Updates:
                self.seqNo = seqNo(body, self.seqNo)
                asyncCheck updateHandler.sendUpdate(client, body.UpdatesI)

            if len(self.acks) >= 8:
                discard await self.send(Msgs_ack(msg_ids: self.acks), false)
                self.acks.setLen(0)
    self.logger.log(lvlDebug, &"Handler exited on DC" & $self.dcID )

    #We need to reopen the connection if this session is required
    if self.isRequired:
        self.connection.close()

        self.logger.log(lvlDebug, &"Trying to reconnect...")

        if not self.alreadyCalledDisconnected:
            #self.callbackUpdates.processNetworkDisconnected() #TODO: implement this again 
            self.alreadyCalledDisconnected = true
        while true:
            await sleepAsync(5000)

            try:
                await self.connection.reopen()
            except:
                await sleepAsync(5000)
                continue
            await sleepAsync(1000)
            if not self.connection.isClosed():
                #TODO: Handle session-id regeneration if Telegram forgets the current one
                self.logger.log(lvlDebug, &"Sucessfuly reconnected to DC" & $self.dcID )
                asyncCheck self.startHandler(client, updateHandler)
                self.sessionID = urandom(8)

                await startHandler(client)

                var responsesCopy = self.responses
                for i, _ in responsesCopy:
                    self.responses[i].body = nil
                    self.responses[i].event.trigger()
                self.responses.clear()

                self.initDone = true
                self.resumeConnectionWait.trigger()
                self.alreadyCalledDisconnected = false
                self.isDead = false
                break
    else:
        var responsesCopy = self.responses

        for i, _ in responsesCopy:
            self.responses[i].body = nil
            self.responses[i].event.trigger()
        self.responses.clear()
        #inform this session is "dead"
        self.isDead = true

proc waitEvent(ev: AsyncEvent): Future[void] =
    var fut = newFuture[void]("waitEvent")
    proc cb(fd: AsyncFD): bool = fut.complete(); return true
    addEvent(ev, cb)
    return fut



proc send*(self: Session, tl: TL, waitResponse: bool = true,
        ignoreInitDone: bool = false): Future[TL] {.async.} =

    

    var data = self.encrypt(tl.TLEncode(), tl)

    if self.isDead:
        raise newException(CatchableError, "Connection was lost")
    if self.connection.isClosed(): #or (not self.initDone and not ignoreInitDone):
        self.responses[data.messageID.int64] = Response(event: newAsyncEvent())
        await waitEvent(self.responses[data.messageID.int64].event)
        return await self.send(tl, waitResponse, ignoreInitDone)
    try:
        await self.connection.write(data.encryptedData)
    except Exception:
        if self.connection.isClosed():
            self.responses[data.messageID.int64] = Response(event: newAsyncEvent())
            await waitEvent(self.responses[data.messageID.int64].event)
            return await self.send(tl, waitResponse, ignoreInitDone)
        else:
            raise getCurrentException()

    if waitResponse:
        self.responses[data.messageID.int64] = Response(event: newAsyncEvent())

        #Wait for response of the worker
        await waitEvent(self.responses[data.messageID.int64].event)
        if not self.responses.hasKey(data.messageID.int64):
            if self.isDead:
                raise newException(CatchableError, "Connection was lost while executing request")
            else:
                return await self.send(tl, waitResponse, ignoreInitDone)

        var response = self.responses[data.messageID.int64].body
        if response of Bad_server_salt:
            self.logger.log(lvlDebug, &"Received bad_server_salt, changing salt")

            var badServerSalt = response.Bad_server_salt
            self.serverSalt = badServerSalt.new_server_salt.TLEncode()
            var info = await self.storageManager.getSessionsInfo()
            info[self.dcID].salt = self.serverSalt
            await self.storageManager.writeSessionsInfo(info)
            return await self.send(tl, waitResponse, ignoreInitDone)
        
        self.responses.del(data.messageID.int64)

        if response of Rpc_error:
            var excp = RPCException(errorMessage: response.Rpc_error.error_message,
                    errorCode: response.Rpc_error.error_code)
            excp.msg = response.Rpc_error.error_message
            raise excp

        if response of InvokeWithoutUpdates:
            response = response.InvokeWithoutUpdates.query
        if response of InvokeWithTakeout:
            response = response.InvokeWithTakeout.query
        return response

proc checkConnectionLoop*(self: Session) {.async.} =
    self.logger.log(lvlDebug, &"Starting checkConnectionLoop DC" & $self.dcID )

    while not self.connection.isClosed():
        await sleepAsync(10000)
        randomize()
        let pingID = int64(rand(9999))
        try:
            discard await self.send(Ping(ping_id: pingID), false, true)
        except:
            return
        self.logger.log(lvlDebug, &"Sending ping to Telegram")



proc mtprotoInit(self: Session, client: NimgramClient): Future[void] {.async.} =
    #randomize()
    #let pingID = int64(rand(9999))

    #var ponger = await self.send(Ping(ping_id: pingID), true, true)
    #if not(ponger of Pong):
    #    raise newException(CatchableError, "Ping failed!")
    #doAssert ponger.Pong.ping_id == pingID
    discard await self.send(InvokeWithLayer(layer: LAYER_VERSION,
            query: InitConnection(api_id: self.clientConfig.apiID,
            device_model: self.clientConfig.deviceModel,
            system_version: self.clientConfig.systemVersion,
            app_version: self.clientConfig.appVersion,
            system_lang_code: self.clientConfig.systemLangCode,
            lang_pack: self.clientConfig.langPack,
            lang_code: self.clientConfig.langCode,
            query: HelpGetConfig())), false, true)
    #asyncCheck self.checkConnectionLoop()
    #await startHandler(client)
