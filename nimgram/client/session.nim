import network/transports
import random/urandom
import rpc/mtproto
import rpc/api
import rpc/decoding
import rpc/encoding
import asyncdispatch
import storage
import crypto/aes
import stew/endians2
import rpc/static
import nimcrypto
import math
import times
import tables
import typetraits
type Response = ref object
    event: AsyncEvent
    body: TLObject

type Session* = ref object 
    authKey: seq[uint8]
    authKeyID: seq[uint8]
    sessionFile: string
    serverSalt: seq[uint8]
    dcID: int
    activeReceiver: bool
    sessionID: seq[uint8] 
    seqNo: int 
    acks: seq[int64]
    responses: Table[int64, Response]
    maxMessageID: uint64
    connection: TcpNetwork

#proc messageID(): uint64 = uint64(now().toTime().toUnixFloat()*2 ^ 32)

proc messageID(self: Session): uint64 =
    result = uint64(now().toTime().toUnix()*2 ^ 32)
    assert result mod 4 == 0, "message id is not divisible by 4, consider syncing your time."

    if result <= self.maxMessageID:
        result = self.maxMessageID + 4
    self.maxMessageID = result

        

proc initSession*(connection: TcpNetwork, dcID: int, authKey: seq[uint8], serverSalt: seq[uint8], sessionFile: string): Session =
    result = new Session
    result.acks = newSeq[int64](0)
    result.connection = connection
    result.dcID = dcID
    result.authKey = authKey
    result.authKeyID = sha1.digest(authKey).data[12..19]
    result.sessionFile = sessionFile
    result.serverSalt = serverSalt
    result.seqNo = 5
    result.sessionID = urandom(4) & uint32(now().toTime().toUnix()).TLEncode()

type EncryptedResult = object
    encryptedData: seq[uint8]
    messageID: uint64

proc encrypt*(self: Session, obj: seq[uint8], typeof: TL): EncryptedResult =

    var data = obj
    var seqNumber = seqNo(typeof, self.seqNo)
    self.seqNo = seqNumber
    var mesageeID = self.messageID()
    result.messageID = mesageeID
    var payload = self.serverSalt &  self.sessionID &  mesageeID.TLEncode() & uint32(seqNumber).TLEncode() & uint32(len(data)).TLEncode() & data
    payload.add(urandom((len(payload) + 12) mod 16 + 12) )
    while true:
        if len(payload) mod 16 ==  0 and len(payload) mod 4 == 0:
            break
        payload.add(1)
    var messageKey = sha256.digest(self.authKey[88..119] & payload).data[8..23]
    var a = sha256.digest(messageKey & self.authKey[0..35]).data
    var b = sha256.digest(self.authKey[40..75] & messageKey).data

    var aesKey = a[0..7] & b[8..23] & a[24..31]
    var aesIV = b[0..7] & a[8..23] & b[24..31]
    var aeslib = initAesIGE(aesKey, aesIV)
    result.encryptedData = self.authKeyID & messageKey & aeslib.encrypt(payload)


proc decrypt(self: Session, data: seq[uint8]): CoreMessage =
    var sdata = newScalingSeq(data)
    var authKeyId = sdata.readN(8)
    if authKeyId != self.authKeyID:
        raise newException(Exception, "Response Auth Key Id is different from saved one")
    var responseMsgKey = sdata.readN(16)
    var a = sha256.digest(responseMsgKey & self.authKey[8..43]).data
    var b = sha256.digest(self.authKey[48..83] & responseMsgKey).data
    var aesKey = a[0..7] & b[8..23] & a[24..31]
    var aesIv = b[0..7] & a[8..23] & b[24..31]
    var maes = initAesIGE(aesKey, aesIv)
    var encryptredata = sdata.readAll()
    var plaintext = maes.decrypt(encryptredata)
    var msgKey = sha256.digest(self.authKey[96..(96+31)] & plaintext).data[8..23]
    if msgKey != responseMsgKey:
        raise newException(Exception, "Computed Msg Key is different from response") 
    var splaintext = newScalingSeq(plaintext)
    discard splaintext.readN(8)
    var responseSessionID = splaintext.readN(8)
    result = new CoreMessage
    splaintext.TLDecode(result)

proc send*(self: Session, tl: TL, waitResponse: bool = true): Future[TLObject] {.async.} 

proc startHandler*(self: Session) {.async.} = 
    while not self.connection.isClosed():
        var mdata = await self.connection.receive()
        if len(mdata) == 4:
            raise newException(Exception, "invalid response: " & $(cast[int32](fromBytes(uint32, mdata))))
        var coreMessageDecrypted = self.decrypt(mdata)

        var messages: seq[CoreMessage]

        if coreMessageDecrypted.body of MessageContainer:
            messages = coreMessageDecrypted.body.MessageContainer.messages
        else:
            messages = @[coreMessageDecrypted]
        for message in messages:
            var body = message.body
            #var objName = type(message.body).name
            if not message.seqNo mod 2 == 0:
                if self.acks.contains(message.msgID.int64):
                    continue
                else:
                    self.acks.add(message.msgID.int64)
            
            var msgID = int64(0)

            if message.body of msg_detailed_info:
                self.acks.add(body.msg_detailed_info.answer_msg_id)
                continue
            if message.body of msg_new_detailed_info:
                self.acks.add(body.msg_new_detailed_info.answer_msg_id)
                continue

            if message.body of new_session_created:
                continue

            if message.body of bad_msg_notification:
                msgID = body.bad_msg_notification.bad_msg_id

            if message.body of bad_server_salt:
                msgID = body.bad_server_salt.bad_msg_id

            if message.body of FutureSalts:
                msgID = body.FutureSalts.reqMsgID.int64
            
            if message.body of rpc_result:
                msgID = body.rpc_result.req_msg_id
                body = body.rpc_result.result
            
            if body of GZipPacked:
                var bodytemp: TLObject
                var sdata = newScalingSeq(body.GZipPacked.data)
                sdata.TLDecode(bodytemp)
                body = bodytemp

            if message.body of pong:
                msgID = body.pong.msgID
            
            if self.responses.contains(msgID):
                self.responses[msgID].body = body.TLObject
                self.responses[msgID].event.trigger()
            
            #TODO: Handle updates

            if len(self.acks) >= 8:
                discard await self.send(msgs_ack(msg_ids: self.acks), false)
                self.acks.setLen(0)

            
            

proc waitEvent(ev: AsyncEvent): Future[void] =
   var fut = newFuture[void]("waitEvent")
   proc cb(fd: AsyncFD): bool = fut.complete(); return true
   addEvent(ev, cb)
   return fut



proc send*(self: Session, tl: TL, waitResponse: bool = true): Future[TLObject] {.async.} =
    var data: EncryptedResult

    if tl of TLFunction:
        data = self.encrypt(tl.TLFunction.TLEncodeGeneric(), tl)
    elif tl of TLObject:
        data = self.encrypt(tl.TLObject.TLEncode(), tl)
    else:
        raise newException(Exception, "Type not supported")
    
    await self.connection.write(data.encryptedData)
    if waitResponse:
        self.responses[data.messageID.int64] = Response(event: newAsyncEvent())

        await waitEvent(self.responses[data.messageID.int64].event)
        var response = self.responses[data.messageID.int64].body
        if response of bad_server_salt:
            var badServerSalt = response.bad_server_salt
            self.serverSalt = badServerSalt.new_server_salt.TLEncode()
            await createBin(self.authKey, badServerSalt.new_server_salt.TLEncode(), self.sessionFile)
            return await self.send(tl)
        if response of rpc_error:
            raise newException(CatchableError, response.rpc_error.error_message, RPCException(errorCode: response.rpc_error.error_code, errorMessage: response.rpc_error.error_message))

        return response