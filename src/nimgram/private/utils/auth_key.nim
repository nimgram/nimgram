import ../network/transports

import ../rpc/encoding
import ../rpc/decoding
import ../rpc/raw
import ../crypto/prime
import ../network/transports
import ../crypto/rsa
import ../crypto/aes
import ../crypto/exp
import random/urandom
import times
import asyncdispatch
import tables
import math
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


proc send(self: MTProtoNetwork, data: TLFunction): Future[TL] {.async.} =
    var bytes = data.TLEncode()
    bytes = TLEncode(int64(0)) & TLEncode(messageID())  & TLEncode(int32(len(bytes))) & bytes
    await self.write(bytes)
    
    var data = await self.receive()

    if data.len == 4:
        #I don't want to handle a separate error, just throw the same type to count as "connection closed"

        #On Nim 1.2 IndexDefect doesn't exists and IndexError is deprecated on 1.4
        when NimMinor <= 2:
            raise newException(IndexError, "Unexpected result: " & $cast[int32](fromBytes(uint32, data, littleEndian)))
        else:
            raise newException(IndexDefect, "Unexpected result: " & $cast[int32](fromBytes(uint32, data, littleEndian)))

    var sdata = newScalingSeq(data[20..(data.len-1)])
    result.TLDecode(sdata)

proc generateAuthKey*(connection: MTProtoNetwork): Future[(seq[uint8], seq[uint8])] {.async.} =

    
    #step 1
    var reqa = Req_pq_multi(nonce: generateNonce())
    var response: TL
    while true:
        when NimMinor <= 2:
            try:
                #Retry until connection is opened
                response = await connection.send(reqa)
                break
            except IndexError:
                await sleepAsync(5000)
                await connection.reopen()
        else:
            try:
                #Retry until connection is opened
                response = await connection.send(reqa)
                break
            except IndexDefect:
                await sleepAsync(5000)
                await connection.reopen()


    if response of ResPQ:
        var resPQs = cast[ResPQ](response)

        var pq = fromBytes(uint64, resPQs.pq, bigEndian)  

        if resPQs.nonce != reqa.nonce:
            raise newException(CatchableError, "Generated nonce does not correspond to the one in the response")
        
        var rsaKeys = Keychain.toTable
        var keyFingerprint = int64(0)
        for key in resPQs.server_public_key_fingerprints:
            if rsaKeys.contains(key):
                keyFingerprint = key
        
        if keyFingerprint == 0:
            raise newException(CatchableError, "Cannot find a valid RSA Fingerprint")
        
        var factors = factors(pq.stint(128))
        #init inner data
        var innerDataObj = new P_q_inner_data
        innerDataObj.pq = resPQs.pq
        innerDataObj.p = factors[0].truncate(uint32).TLEncode(bigEndian)
        innerDataObj.q = factors[1].truncate(uint32).TLEncode(bigEndian)
        innerDataObj.nonce = reqa.nonce
        innerDataObj.server_nonce = resPQs.server_nonce
        innerDataObj.new_nonce = generateNonce256()
        var innerData = innerDataObj.TLEncode()

        var innerDataEncrypted = sha1.digest(innerData).data[0..19] & innerData & urandom(255 - 20 - len(innerData))
        var mrsa = initRSA(keyFingerprint)
        var encryptedData = mrsa.encrypt(innerDataEncrypted)
        var reqDHParams = new Req_DH_params
        reqDHParams.nonce = reqa.nonce
        reqDHParams.server_nonce = resPQs.server_nonce
        reqDHParams.p = factors[0].truncate(uint32).TLEncode(bigEndian)
        reqDHParams.q = factors[1].truncate(uint32).TLEncode(bigEndian)
        reqDHParams.public_key_fingerprint = keyFingerprint
        reqDHParams.encrypted_data = encryptedData
        when NimMinor <= 2:
            try:
                response = await connection.send(reqDHParams)
            except IndexError:
                return await connection.generateAuthKey()
        else:
            try:
                response = await connection.send(reqDHParams)
            except IndexDefect:
                return await connection.generateAuthKey()
        #step 2
        if not (response of Server_DH_params_ok):
            raise newException(CatchableError, "Wrong response from server")
        var serverDHParmasOk = cast[Server_DH_params_ok](response)

        doAssert serverDHParmasOk.nonce == reqa.nonce 
        doAssert serverDHParmasOk.server_nonce == resPQs.server_nonce

        var serverNonce = TLEncode(serverDHParmasOk.server_nonce, littleEndian)
        var newNonce = TLEncode(innerDataObj.new_nonce, littleEndian)

        var tempAesKey = sha1.digest(newNonce & serverNonce).data[0..19] & sha1.digest(serverNonce & newNonce).data[0..11]
        var tempAesIV = sha1.digest(serverNonce & newNonce).data[12..19] & sha1.digest(newNonce & newNonce).data[0..19] & newNonce[0..3]
        var decrypted = aesIGE(tempAesKey, tempAesIV, serverDHParmasOk.encrypted_answer, false)
        var sbytes = newScalingSeq(decrypted[20..(decrypted.len-1)])
        var tmp = new TL
        tmp.TLDecode(sbytes)
        if not(tmp of Server_DH_inner_data):
            raise newException(CatchableError, "Wrong response type: " & tmp.getTypeName())
        var serverDHInnerData = tmp.Server_DH_inner_data
        doAssert serverDHInnerData.nonce == reqa.nonce 
        doAssert serverDHInnerData.server_nonce == resPQs.server_nonce
        var dhPrime = fromBytes(StUint[2048], serverDHInnerData.dh_prime, bigEndian)
        var gA = fromBytes(StUint[2048], serverDHInnerData.g_a, bigEndian)
        var b = fromBytes(StUint[2048], urandom(256), bigEndian) 

        var gB = exp(stuint(serverDHInnerData.g, 2048), b, dhPrime)
        var data = Client_DH_inner_data(
            nonce: reqa.nonce,
            server_nonce: resPQs.server_nonce,
            retry_id: 0,
            g_b: gB.toBytes(bigEndian)[0..255]).TLEncode()
        data = sha1.digest(data).data[0..19] & data
        while len(data) mod 16 != 0:
            data = data & urandom(1)
        data = aesIGE(tempAesKey, tempAesIV, data, true)
        when NimMinor <= 2:
            try:
                response = await connection.send(Set_client_DH_params(
                    nonce: reqa.nonce,
                    server_nonce: resPQs.server_nonce,
                    encrypted_data: data
                ))
            except IndexError:
                return await connection.generateAuthKey()
        else:
            try:
                response = await connection.send(Set_client_DH_params(
                    nonce: reqa.nonce,
                    server_nonce: resPQs.server_nonce,
                    encrypted_data: data
                 ))
            except IndexDefect:
                return await connection.generateAuthKey()

        #step 3
        if not (response of Dh_gen_ok):
            raise newException(CatchableError, "Wrong response from server")

        var authKey = exp(gA, b, dhPrime).toBytes(bigEndian)
        var serverSalt = fromBytes(uint64, newNonce[0..7], bigEndian) xor fromBytes(uint64, server_nonce[0..7], bigEndian)
        return (authKey[0..255], serverSalt.toBytes(bigEndian)[0..7])
    else:
        raise newException(CatchableError, "Wrong response from server on step1")
