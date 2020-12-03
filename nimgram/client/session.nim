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



type Session* = ref object 
    authKey: seq[uint8]
    authKeyID: seq[uint8]
    sessionFile: string
    serverSalt: seq[uint8]
    dcID: int
    activeReceiver: bool
    sessionID: seq[uint8] 
    seqNo: int 
    connection: TcpNetwork

proc messageID(): uint64 = uint64(now().toTime().toUnix()*2 ^ 32)


proc initSession*(connection: TcpNetwork, dcID: int, authKey: seq[uint8], serverSalt: seq[uint8], sessionFile: string): Session =
    result = new Session
    result.connection = connection
    result.dcID = dcID
    result.authKey = authKey
    result.authKeyID = sha1.digest(authKey).data[12..19]
    result.sessionFile = sessionFile
    result.serverSalt = serverSalt
    result.seqNo = 5
    result.sessionID = urandom(4) & uint32(now().toTime().toUnix()).TLEncode()



proc encrypt*(self: Session, obj: seq[uint8], typeof: TL): seq[uint8] =

    var data = obj
    #var seqNumber = 0
    var seqNumber = seqNo(typeof, self.seqNo)
    self.seqNo = seqNumber
    var mesageeID = messageID()
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
    return self.authKeyID & messageKey & aeslib.encrypt(payload)


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

proc send*(self: Session, function: TLFunction): Future[CoreMessage] {.async.} =
    var data = self.encrypt(function.TLEncodeGeneric(), function)
    await self.connection.write(data)
    var mdata = await self.connection.receive()
    if len(mdata) == 4:
        raise newException(Exception, "invalid response: " & $(cast[int32](fromBytes(uint32, mdata))) )
    var ok = self.decrypt(mdata)
    if ok.body of bad_server_salt:
        var badServerSalt = cast[bad_server_salt](ok.body)
        self.serverSalt = badServerSalt.new_server_salt.TLEncode()
        await createBin(self.authKey, badServerSalt.new_server_salt.TLEncode(), self.sessionFile)
        return await self.send(function)
    return ok
