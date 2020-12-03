import ../network/transports

import ../rpc/api

import ../rpc/encoding
import ../rpc/decoding
import ../rpc/mtproto
import ../crypto/prime
import ../network/transports
import ../crypto/rsa
import ../crypto/aes
import random/urandom
import endians
import times
import asyncdispatch
import tables
import math
import bigints
import stint
import nimcrypto/sha
import strutils

proc generateNonce(): Int128 =
    var noncebytes = urandom(16)
    copyMem(addr result, addr noncebytes[0], 16)
    
proc generateNonce256(): Int256 =
    var noncebytes = urandom(32)
    copyMem(addr result, addr noncebytes[0], 32)


proc messageID(): int64 = int64(pow(float64(now().toTime().toUnix()*2),float64(32)))



proc send(self: TcpNetwork, data: TLFunction): Future[TLObject] {.async.} =
    var bytes = data.TLEncodeGeneric()
    bytes = TLEncode(int64(0)) & TLEncode(messageID())  & TLEncode(int32(len(bytes))) & bytes
    await self.write(bytes)
    var data = await self.receive()
    if data.len == 4:
        raise newException(Exception, "Unexpected result: " & $int32(fromBytes(uint32, data, littleEndian)))
    var sdata = newScalingSeq(data[20..(data.len-1)])
    sdata.TLDecode(result)


proc norm(data: seq[uint32]): seq[uint32] = 
    var i = len(data)
    while i > 0 and data[i-1] == 0:
        dec(i)
    return data[0..(i-1)]

proc encodeToSeqUint(data:  seq[uint8]): seq[uint32] =
    if len(data) mod 4 != 0:
        raise newException(Exception, "needs to be divisible by 4")
    var realLen = len(data) div 4
    var i: int = int(0)
    var m = 0
    while i != realLen:
        var tempInt: uint32
        var toCopy = data[m..(m+3)]
        copyMem(addr tempInt, addr toCopy[0], 4)
        inc(i)
        m += 4
        result.add(tempInt)
    return norm(result)

iterator reverse*[T](a: seq[T]): T {.inline.} =
    var i = len(a) - 1
    while i > -1:
        yield a[i]
        dec(i)



proc generateAuthKey*(connection: TcpNetwork): Future[(seq[uint8], seq[uint8])] {.async.} =

    
    #step 1
    var reqa = req_pq_multi(nonce: generateNonce())
    var response = await connection.send(reqa)

    if response of resPQ:
        var resPQs = cast[resPQ](response)

        var pq = fromBytes(uint64, resPQs.pq, bigEndian)  

        if resPQs.nonce != reqa.nonce:
            raise newException(Exception, "Generated nonce does not correspond to the one in the response")
        
        var rsaKeys = Keychain.toTable
        var keyFingerprint = int64(0)
        for key in resPQs.server_public_key_fingerprints:
            if rsaKeys.contains(key):
                keyFingerprint = key
        
        if keyFingerprint == 0:
            raise newException(Exception, "Cannot find a valid RSA Fingerprint")
        
    
        var factors = factors(pq.stint(128))
        
        #init inner data
        var innerDataObj = new p_q_inner_data
        innerDataObj.pq = resPQs.pq
        innerDataObj.p = factors[0].truncate(uint32).TLEncode(bigEndian)
        innerDataObj.q = factors[1].truncate(uint32).TLEncode(bigEndian)
        innerDataObj.nonce = reqa.nonce
        innerDataObj.server_nonce = resPQs.server_nonce
        innerDataObj.new_nonce = generateNonce256()
        var innerData = innerDataObj.TLEncodeType()

        var innerDataEncrypted = sha1.digest(innerData).data[0..19] & innerData & urandom(255 - 20 - len(innerData))
        var mrsa = initRSA(keyFingerprint)
        var encryptedData = mrsa.encrypt(innerDataEncrypted)
        var reqDHParams = new req_DH_params
        reqDHParams.nonce = reqa.nonce
        reqDHParams.server_nonce = resPQs.server_nonce
        reqDHParams.p = factors[0].truncate(uint32).TLEncode(bigEndian)
        reqDHParams.q = factors[1].truncate(uint32).TLEncode(bigEndian)
        reqDHParams.public_key_fingerprint = keyFingerprint
        reqDHParams.encrypted_data = encryptedData
        response = await connection.send(reqDHParams)

        #step 2
        if not (response of server_DH_params_ok):
            raise newException(Exception, "Wrong response from server")
        var serverDHParmasOk = cast[server_DH_params_ok](response)

        assert serverDHParmasOk.nonce == reqa.nonce 
        assert serverDHParmasOk.server_nonce == resPQs.server_nonce

        var serverNonce = TLEncode(serverDHParmasOk.server_nonce, littleEndian)
        var newNonce = TLEncode(innerDataObj.new_nonce, littleEndian)

        var tempAesKey = sha1.digest(newNonce & serverNonce).data[0..19] & sha1.digest(serverNonce & newNonce).data[0..11]
        var tempAesIV = sha1.digest(serverNonce & newNonce).data[12..19] & sha1.digest(newNonce & newNonce).data[0..19] & newNonce[0..3]
        var aes = initAesIGE(tempAesKey, tempAesIV)
        var decrypted = aes.decrypt(serverDHParmasOk.encrypted_answer)
        var sbytes = newScalingSeq(decrypted[20..(decrypted.len-1)])
        var id: int32
        sbytes.TLDecode(addr id)
        if FromID.toTable[id] != "server_DH_inner_data":
            raise newException(Exception, "Wrong response from decrypted data: " & FromID.toTable[id])
        var serverDHInnerData = new server_DH_inner_data
        sbytes.TLDecode(serverDHInnerData)
        assert serverDHInnerData.nonce == reqa.nonce 
        assert serverDHInnerData.server_nonce == resPQs.server_nonce
        var dhPrime = fromBytes(StUint[2048], serverDHInnerData.dh_prime, bigEndian)
        var gA = fromBytes(StUint[2048], serverDHInnerData.g_a, bigEndian)
        var b = fromBytes(StUint[2048], urandom(256), bigEndian) 

        #TODO: Find an alternative, this is really slow
        var gB = powmod(stuint(serverDHInnerData.g, 2048), b, dhPrime)
        var data = client_DH_inner_data(
            nonce: reqa.nonce,
            server_nonce: resPQs.server_nonce,
            retry_id: 0,
            g_b: gB.toBytes(bigEndian)[0..255]).TLEncodeType()
        data = sha1.digest(data).data[0..19] & data
        while len(data) mod 16 != 0:
            data = data & urandom(1)
        data = aes.encrypt(data)
        response = await connection.send(set_client_DH_params(
            nonce: reqa.nonce,
            server_nonce: resPQs.server_nonce,
            encrypted_data: data
        ))

        #step 3
        if not (response of dh_gen_ok):
            raise newException(Exception, "Wrong response from server")

        #TODO: Find an alternative, this is really slow
        var authKey = powmod(gA, b, dhPrime).toBytes(bigEndian)
        var serverSalt = fromBytes(uint64, newNonce[0..7], bigEndian) xor fromBytes(uint64, server_nonce[0..7], bigEndian)
        return (authKey[0..255], serverSalt.toBytes(bigEndian)[0..7])
    else:
        raise newException(Exception, "Wrong response from server on step1")

