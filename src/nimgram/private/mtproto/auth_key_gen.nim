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

## Module implementing generation of an auth key

import std/[sysrand, asyncdispatch, tables, logging], network/[transports,
        dummy], crypto/[pow, ige]
import pkg/[tltypes, stint, tommath, nimcrypto/sha2, nimcrypto/sha],
        pkg/tltypes/[encode, decode], ../utils/exceptions
import std/times, std/algorithm, std/options

import std/json

proc send(self: MTProtoNetwork, data: TLFunction): Future[TL] {.async.} =
    ## Encode a function and send it in "plain text mode"

    let bytes = data.TLEncode()
    await self.write(@[0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128] &
            TLEncode(int32(len(bytes))) & bytes)

    let data = await self.receive()

    if data.len == 4:
        raise newException(SecurityError, "Unexpected result: " & $abs(TLDecode[
                int32](newTLStream(data))))
    result = tl.TLDecode(newTLStream(data[20..(data.len-1)]))


# TODO: Load RSA Keys from ASN string
#[
const KEYCHAIN = {847625836280919973'i64: Key(n: "aeec36c8ffc109cb099624685b97815415657bd76d8c9c3e398103d7ad16c9bba6f525ed0412d7ae2c2de2b44e77d72cbf4b7438709a4e646a05c43427c7f184debf72947519680e651500890c6832796dd11f772c25ff8f576755afe055b0a3752c696eb7d8da0d8be1faf38c9bdd97ce0a77d3916230c4032167100edd0f9e7a3a9b602d04367b689536af0d64b613ccba7962939d3b57682beb6dae5b608130b2e52aca78ba023cf6ce806b1dc49c72cf928a7199d22e3d7ac84e47bc9427d0236945d10dbd15177bab413fbf0edfda09f014c7a7da088dde9759702ca760af2b8e4e97cc055c617bd74c3d97008635b98dc4d621b4891da9fb0473047927", e: "65537"),
    1562291298945373506'i64: Key(
        n: "bdf2c77d81f6afd47bd30f29ac76e55adfe70e487e5e48297e5a9055c9c07d2b93b4ed3994d3eca5098bf18d978d54f8b7c713eb10247607e69af9ef44f38e28f8b439f257a11572945cc0406fe3f37bb92b79112db69eedf2dc71584a661638ea5becb9e23585074b80d57d9f5710dd30d2da940e0ada2f1b878397dc1a72b5ce2531b6f7dd158e09c828d03450ca0ff8a174deacebcaa22dde84ef66ad370f259d18af806638012da0ca4a70baa83d9c158f3552bc9158e69bf332a45809e1c36905a5caa12348dd57941a482131be7b2355a5f4635374f3bd3ddf5ff925bf4809ee27c1e67d9120c5fe08a9de458b1b4a3c5d0a428437f2beca81f4e2d5ff",
        e: "65537"),
    -5859577972006586033'i64: Key(
        n: "b3f762b739be98f343eb1921cf0148cfa27ff7af02b6471213fed9daa0098976e667750324f1abcea4c31e43b7d11f1579133f2b3d9fe27474e462058884e5e1b123be9cbbc6a443b2925c08520e7325e6f1a6d50e117eb61ea49d2534c8bb4d2ae4153fabe832b9edf4c5755fdd8b19940b81d1d96cf433d19e6a22968a85dc80f0312f596bd2530c1cfb28b5fe019ac9bc25cd9c2a5d8a0f3a1c0c79bcca524d315b5e21b5c26b46babe3d75d06d1cd33329ec782a0f22891ed1db42a1d6c0dea431428bc4d7aabdcf3e0eb6fda4e23eb7733e7727e9a1915580796c55188d2596d2665ad1182ba7abf15aaa5a8b779ea996317a20ae044b820bff35b6e8a1",
        e: "65537"),
    6491968696586960280'i64: Key(
        n: "be6a71558ee577ff03023cfa17aab4e6c86383cff8a7ad38edb9fafe6f323f2d5106cbc8cafb83b869cffd1ccf121cd743d509e589e68765c96601e813dc5b9dfc4be415c7a6526132d0035ca33d6d6075d4f535122a1cdfe017041f1088d1419f65c8e5490ee613e16dbf662698c0f54870f0475fa893fc41eb55b08ff1ac211bc045ded31be27d12c96d8d3cfc6a7ae8aa50bf2ee0f30ed507cc2581e3dec56de94f5dc0a7abee0be990b893f2887bd2c6310a1e0a9e3e38bd34fded2541508dc102a9c9b4c95effd9dd2dfe96c29be647d6c69d66ca500843cfaed6e440196f1dbe0e2e22163c61ca48c79116fa77216726749a976a1c4b0944b5121e8c01",
        e: "65537"),
    -4344800451088585951'i64: Key(n: "c150023e2f70db7985ded064759cfecf0af328e69a41daf4d6f01b538135a6f91f8f8b2a0ec9ba9720ce352efcf6c5680ffc424bd634864902de0b4bd6d49f4e580230e3ae97d95c8b19442b3c0a10d8f5633fecedd6926a7f6dab0ddb7d457f9ea81b8465fcd6fffeed114011df91c059caedaf97625f6c96ecc74725556934ef781d866b34f011fce4d835a090196e9a5f0e4449af7eb697ddb9076494ca5f81104a305b6dd27665722c46b60e5df680fb16b210607ef217652e60236c255f6a28315f4083a96791d7214bf64c1df4fd0db1944fb26a2a57031b32eee64ad15a8ba68885cde74a5bfc920f6abf59ba5c75506373e7130f9042da922179251f",
        e: "65537"),
    -7306692244673891685'i64: Key(n: "c6aeda78b02a251db4b6441031f467fa871faed32526c436524b1fb3b5dca28efb8c089dd1b46d92c895993d87108254951c5f001a0f055f3063dcd14d431a300eb9e29517e359a1c9537e5e87ab1b116faecf5d17546ebc21db234d9d336a693efcb2b6fbcca1e7d1a0be414dca408a11609b9c4269a920b09fed1f9a1597be02761430f09e4bc48fcafbe289054c99dba51b6b5eb7d9c3a2ab4e490545b4676bd620e93804bcac93bf94f73f92c729ca899477ff17625ef14a934d51dc11d5f8650a3364586b3a52fcff2fedec8a8406cac4e751705a472e55707e3c8cd5594342b119c6c3293532d85dbe9271ed54a2fd18b4dc79c04a30951107d5639397",
        e: "65537"),
    -5738946642031285640'i64: Key(n: "b1066749655935f0a5936f517034c943bea7f3365a8931ae52c8bcb14856f004b83d26cf2839be0f22607470d67481771c1ce5ec31de16b20bbaa4ecd2f7d2ecf6b6356f27501c226984263edc046b89fb6d3981546b01d7bd34fedcfcc1058e2d494bda732ff813e50e1c6ae249890b225f82b22b1e55fcb063dc3c0e18e91c28d0c4aa627dec8353eee6038a95a4fd1ca984eb09f94aeb7a2220635a8ceb450ea7e61d915cdb4eecedaa083aa3801daf071855ec1fb38516cb6c2996d2d60c0ecbcfa57e4cf1fb0ed39b2f37e94ab4202ecf595e167b3ca62669a6da520859fb6d6c6203dfdfc79c75ec3ee97da8774b2da903e3435f2cd294670a75a526c1",
        e: "65537"),
    8205599988028290019'i64: Key(n: "c2a8c55b4a62e2b78a19b91cf692bcdc4ba7c23fe4d06f194e2a0c30f6d9996f7d1a2bcc89bc1ac4333d44359a6c433252d1a8402d9970378b5912b75bc8cc3fa76710a025bcb9032df0b87d7607cc53b928712a174ea2a80a8176623588119d42ffce40205c6d72160860d8d80b22a8b8651907cf388effbef29cd7cf2b4eb8a872052da1351cfe7fec214ce48304ea472bd66329d60115b3420d08f6894b0410b6ab9450249967617670c932f7cbdb5d6fbcce1e492c595f483109999b2661fcdeec31b196429b7834c7211a93c6789d9ee601c18c39e521fda9d7264e61e518add6f0712d2d5228204b851e13c4f322e5c5431c3b7f31089668486aadc59f", e: "65537")
}.toTable
]#

const KEYCHAIN = {0xd09d1d85de64fd85'u64: (
        "E8BB3305C0B52C6CF2AFDF7637313489E63E05268E5BADB601AF417786472E5F93B85438968E20E6729A301C0AFC121BF7151F834436F7FDA680847A66BF64ACCEC78EE21C0B316F0EDAFE2F41908DA7BD1F4A5107638EEB67040ACE472A14F90D9F7C2B7DEF99688BA3073ADB5750BB02964902A359FE745D8170E36876D4FD8A5D41B2A76CBFF9A13267EB9580B2D06D10357448D20D9DA2191CB5D8C93982961CDFDEDA629E37F1FB09A0722027696032FE61ED663DB7A37F6F263D370F69DB53A0DC0A1748BDAAFF6209D5645485E6E001D1953255757E4B8E42813347B11DA6AB500FD0ACE7E6DFA3736199CCAF9397ED0745A427DCFA6CD67BCB1ACFF3", "010001"), 0xb25898df208d2603'u64: (
       "C8C11D635691FAC091DD9489AEDCED2932AA8A0BCEFEF05FA800892D9B52ED03200865C9E97211CB2EE6C7AE96D3FB0E15AEFFD66019B44A08A240CFDD2868A85E1F54D6FA5DEAA041F6941DDF302690D61DC476385C2FA655142353CB4E4B59F6E5B6584DB76FE8B1370263246C010C93D011014113EBDF987D093F9D37C2BE48352D69A1683F8F6E6C2167983C761E3AB169FDE5DAAA12123FA1BEAB621E4DA5935E9C198F82F35EAE583A99386D8110EA6BD1ABB0F568759F62694419EA5F69847C43462ABEF858B4CB5EDC84E7B9226CD7BD7E183AA974A712C079DDE85B9DC063B8A5C08E8F859C0EE5DCD824C7807F20153361A7F63CFD2A433A1BE7F5", "010001")}.toTable

proc computeRSA(data: sink seq[uint8], n: BigInt, e: BigInt): seq[uint8] =
    return toBytes(powmod(fromBytes(move(data)), e, n))

proc rsaPad(data: var seq[uint8], m: BigInt, e: BigInt): seq[uint8] =
    doAssert data.len <= 144

    while result.len < 1:
        let tempKey = urandom(32)

        block:
            if data.len != 192:
                data.add(newSeq[uint8]((192 - len(data))))
            let digest = sha256.digest(tempKey & data).data[0..<32]
            data.reverse()
            
            data.add(digest)
        doAssert data.len == 224, "invalid data_with_hash length"
        
        block:
            let ciphertext = aesIGE(tempKey, newSeq[uint8](32), newTLStream(data), true)
            var tempKeyXor: array[32, uint8]

            let ciphertextDigest = sha256.digest(ciphertext).data
            for i in 0..<32:
                tempKeyXor[i] = tempKey[i] xor ciphertextDigest[i]
            
            let keyWithCiphertext = tempKeyXor[0..<32] & ciphertext

            doAssert keyWithCiphertext.len == 256


            if fromBytes(keyWithCiphertext) < m:
                result = computeRSA(keyWithCiphertext, m, e)
                result = newSeq[uint8](256-result.len) & result
                
                doAssert result.len == 256
    


proc stage1(self: MTProtoNetwork, nonce: UInt128): Future[ResPQ] {.async.} =
    ## Execute the first stage of the authkey generation

    let rsp = await self.send(setConstructorID(Req_pq_multi(nonce: nonce)))
    securityCheck rsp of ResPQ, "Expecting ResPQ as response to Req_pq_multi, got a different type"

    result = rsp.ResPQ

    securityCheck result.nonce == nonce, "Generated nonce does not correspond to the one in the response"


proc stage2(self: MTProtoNetwork, pq: ResPQ, nonce: Uint128, dcId: int, testMode: bool, media: bool): Future[(Server_DH_params_ok, UInt256)] {.async.} =
    var keyId = 0'u64
    for key in pq.server_public_key_fingerprints:
        if KEYCHAIN.contains(key):
            keyId = key
            break

    doAssert keyId != 0, "Unable to find a valid RSA key"

    let key = initBigInt(KEYCHAIN[keyID][0], 16)
    let keyExp = initBigInt(KEYCHAIN[keyID][1], 16)

    let serverNonce = pq.server_nonce
    doAssert pq.pq.len == 8, "pq length is not 8"
    let pq = fromBytes(uint64, cast[seq[uint8]](pq.pq), bigEndian)

    let (p, q) = factorize(pq)
    let newNonce = cast[UInt256](urandom(32))
    let innerData = P_q_inner_data_dc(pq: cast[string](toBytes(pq, bigEndian)[0..7]), 
        p: cast[string](toBytes(p, bigEndian)[0..<4]), q: cast[string](toBytes(q, bigEndian)[0..<4]),
        nonce: nonce, server_nonce: serverNonce, new_nonce: newNonce, dc: uint32(dcId)).setConstructorID()
    if testMode:
        innerData.dc += 10000
    if media:
        innerData.dc = cast[uint32](-int32(innerData.dc))
    var innerDataBytes = TLEncode(innerData)

    let rsaEncrypted = rsaPad(innerDataBytes, key, keyExp)

    let dhParams = Req_DH_params(nonce: nonce, serverNonce: serverNonce, p: cast[string](toBytes(p, bigEndian)[0..<4]), q: cast[string](toBytes(q, bigEndian)[0..<4]), public_key_fingerprint: keyId, encrypted_data: cast[string](rsaEncrypted)).setConstructorID()
  
    debug("[AUTHKEY] Sending Req_DH_params...")
    let sentDh = await self.send(dhParams)    

    securityCheck not(sentDh of Server_DH_params_fail), "Got Server_DH_params_fail, this is not expected"

    securityCheck sentDh of Server_DH_params_ok, "Got a different response from Server_DH_params_ok"
    return (sentDh.Server_DH_params_ok, newNonce)


template rangeCheck(val: BigInt, min: BigInt, max: BigInt) =
    securityCheck min < val and val < max


proc stage3(self: MTProtoNetwork, dhParams: Server_DH_params_ok,
        newNonce: UInt256, nonce: UInt128, serverNonce: UInt128, b: seq[
                uint8]): Future[(BigInt, BigInt, BigInt, UInt128)] {.async.} =
    ## Execute the third stage of the authkey generation
    
    securityCheck dhParams.nonce == nonce
    securityCheck dhParams.server_nonce == serverNonce

    let serverNonceBytes = TLEncode(serverNonce)
    let newNonceBytes = TLEncode(newNonce)

    let tempAesKey = sha1.digest(newNonceBytes & serverNonceBytes).data[0..19] &
            sha1.digest(serverNonceBytes & newNonceBytes).data[0..11]
    let tempAesIV = sha1.digest(serverNonceBytes & newNonceBytes).data[12..19] &
            sha1.digest(newNonceBytes & newNonceBytes).data[0..19] &
                    newNonceBytes[0..3]
    debug("[AUTHKEY] Decrypting dhParams.encrypted_answer...")
    let encryptedAnswer = newTLStream(cast[seq[uint8]](dhParams.encrypted_answer))
    let decrypted = aesIGE(tempAesKey, tempAesIV, encryptedAnswer, false)
    let decryptedStream = newTLStream(decrypted[20..(decrypted.high)])
    let decryptedTL = tl.TLDecode(decryptedStream)

    securityCheck decryptedTL of Server_DH_inner_data, "Expecting decrypted data to be of type Server_DH_inner_data, got a different type"

    let serverDH = decryptedTL.Server_DH_inner_data
    securityCheck serverDH.nonce == nonce
    securityCheck serverDH.server_nonce == serverNonce
    
    debug("[AUTHKEY] Computing dhPrime, gA, b and gB...")
    let dhPrime = fromBytes(cast[seq[uint8]](serverDH.dh_prime))
    let gA = fromBytes(cast[seq[uint8]](serverDH.g_a))
    let b = fromBytes(b)
    let gB = powmod(initBigInt(serverDH.g), b, dhPrime)
    #let gAb = powmod(gA, b, dhPrime)
    
    let one = initBigInt(1)
    rangeCheck initBigInt(serverDH.g), one, (dhPrime - one)
    rangeCheck gA, one, (dhPrime - one)
    rangeCheck gB, one, (dh_prime - one)

    let safeRange = initBigInt(1 shl (2048 - 64))
    rangeCheck gA, safeRange, (dh_prime - safeRange)
    rangeCheck gB, safeRange, (dh_prime - safeRange)
    
    debug("[AUTHKEY] Preparing Client_DH_inner_data...")
    

    var data = setConstructorID(Client_DH_inner_data(
            nonce: serverDH.nonce,
            server_nonce: serverDH.server_nonce,
            retry_id: 0,
            g_b: cast[string](gB.toBytes())
    )).TLEncode()
    data = sha1.digest(data).data[0..19] & move(data)
    while len(data) mod 16 != 0: data.add(0)
    let innerData = newTLStream(move(data))
    
    
    debug("[AUTHKEY] Sending Set_client_DH_params...")
    let dhGenResponse = await self.send(Set_client_DH_params(
                nonce: serverDH.nonce,
                server_nonce: serverDH.server_nonce,
                encrypted_data: cast[string](aesIGE(tempAesKey, tempAesIV, innerData, true))
    ).setConstructorID())
    securityCheck dhGenResponse of Dh_gen_ok, "Expecting response to be of type Dh_gen_ok, got a different type"
    let dhGenOk = dhGenResponse.Dh_gen_ok

    securityCheck dhGenOk.nonce == nonce
    securityCheck dhGenOk.server_nonce == server_nonce

    return (gA, b, dhPrime, dhGenOk.new_nonce_hash1)


proc createAuthKeySalt(gA: BigInt, b: BigInt, dhPrime: BigInt, newNonce: seq[
        uint8], serverNonce: seq[uint8]): (BigInt, uint64) =
    ## Compute auth key and the first salt to be used
    
    debug("[AUTHKEY] Computing AuthKey...")
    result[0] = powmod(gA, b, dhPrime)
    debug("[AUTHKEY] Computing first salt...")
    result[1] = fromBytes(uint64, newNonce[0..7], cpuEndian) xor fromBytes(
            uint64, serverNonce[0..7], cpuEndian)


proc executeAuthKeyGeneration*(self: MTProtoNetwork, dcId: int, isTestMode: bool, isMedia: bool): Future[(seq[uint8], int64)] {.async.} =
    ## Execute auth key generation on the specified connection
    
    debug("[AUTHKEY] Generating a new auth key")
    debug("[AUTHKEY] Executing stage1..")
    let nonce = cast[UInt128](urandom(16))
    let pq = await self.stage1(nonce)
   #proc stage2(self: MTProtoNetwork, pq: ResPQ, nonce: Uint128, dcId: int, testMode: bool, media: bool): Future[(Server_DH_params_ok, UInt256)] {.async.} =

    debug("[AUTHKEY] Executing stage2...")
    let (dhParams, newNonce) = await self.stage2(pq, nonce, dcId, isTestMode, isMedia)
    
    debug("[AUTHKEY] Executing stage3...")
    let (gA, b, dhPrime, serverNewNonceHash1) = await self.stage3(dhParams, newNonce, pq.nonce,
            pq.server_nonce, urandom(256))

    debug("[AUTHKEY] Finalizing AuthKey creation...")

    
    let (authKeyBig, saltn) = createAuthKeySalt(gA, b, dhPrime, toBytes(newNonce,
            cpuEndian)[0..<32], toBytes(dhParams.server_nonce, cpuEndian)[0..<16])
    let salt = cast[int64](saltn)
    let authKey = authKeyBig.toBytes()
    
    let newNonceHash1 = sha1.digest(TLEncode(newNonce) & 1'u8 & sha1.digest(authKey).data[0..<8]).data[^16..^1]

    securityCheck newNonceHash1 == TLEncode(serverNewNonceHash1)

    debug("[AUTHKEY] AuthKey generated successfully")
    return (authKey, salt)

