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

import std/[sysrand, asyncdispatch, tables, logging], network/[transports, dummy], crypto/[pow, ige]
import pkg/[tltypes, stint, bigints, nimcrypto/sha], pkg/tltypes/[encode, decode], ../utils/exceptions
import std/math, std/times

proc send(self: MTProtoNetwork, data: TLFunction): Future[TL] {.async.} =
    ## Encode a function and send it in "plain text mode"

    let bytes = data.TLEncode()
    await self.write(@[0'u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128] & TLEncode(
            int32(len(bytes))) & bytes)

    let data = await self.receive()

    if data.len == 4:
        raise newException(SecurityError, "Unexpected result: " & $TLDecode[
                int32](newTLStream(data)))
    result = tl.TLDecode(newTLStream(data[20..(data.len-1)]))

type Key = object
    e: string
    n: string

# TODO: Load RSA Keys from ASN string

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

proc getRSAKey(id: int64): (BigInt, BigInt) =
    if KEYCHAIN.contains(id):
        return (initBigInt(KEYCHAIN[id].n, 16), initBigInt(KEYCHAIN[id].e, 10))
    else:
        raise newException(CatchableError, "Unable to find a corresponding key")

proc computeRSA(data: seq[uint8], n: BigInt, e: BigInt): seq[uint8] =
    return toBytesBE(powmod(fromBytesBE(data), e, n))


proc stage1(self: MTProtoNetwork, nonce: UInt128): Future[ResPQ] {.async.} =
    ## Execute the first stage of the authkey generation
    
    let rsp = await self.send(setConstructorID(Req_pq_multi(nonce: nonce)))
    securityCheck rsp of ResPQ, "Expecting ResPQ as response to Req_pq_multi, got a different type"

    result = rsp.ResPQ

    securityCheck result.nonce == nonce, "Generated nonce does not correspond to the one in the response"

proc stage2(self: MTProtoNetwork, pq: ResPQ, newNonce: UInt256): Future[
        Server_DH_params_ok] {.async.} =
    ## Execute the second stage of the authkey generation
    
    debug("[AUTHKEY] Checking for key fingerprints...")
    var n, e: BigInt
    var key = uint64(0)
    for keyy in pq.server_public_key_fingerprints:
        try:
            (n, e) = getRSAKey(cast[int64](keyy))
            key = keyy
            break
        except:
            continue
    if key == 0: raise newException(CatchableError, "Unable to find a valid RSA key")
       
    let ipq = fromBytesBE(cast[seq[uint8]](pq.pq))
    debug("[AUTHKEY] Decomposing factors...")
    let (p, q) = factors(ipq)
    let innerData = setConstructorID(P_q_inner_data(p: cast[string](toBytesBE(
            p)), q: cast[string](toBytesBE(q)), nonce: pq.nonce,
                    server_nonce: pq.server_nonce,
            new_nonce: newNonce, pq: pq.pq)).TLEncode()

    let innerDataPadded = sha1.digest(innerData).data[0..19] & innerData &
             newSeq[uint8]((255 - 20 - len(innerData)))
    securityCheck innerDataPadded.len == 255
    let cipherData = computeRSA(innerDataPadded, n, e)
    let dhParams = setConstructorID(Req_DH_params(p: cast[string](toBytesBE(
            p)), q: cast[string](toBytesBE(q)), nonce: pq.nonce,
                    server_nonce: pq.server_nonce, public_key_fingerprint: key,
                            encrypted_data: cast[string](cipherData)))
    debug("[AUTHKEY] Sending Req_DH_params...")
    let sentDh = await self.send(dhParams)

    securityCheck not(sentDh of Server_DH_params_fail), "Got Server_DH_params_fail, this is not expected"

    securityCheck sentDh of Server_DH_params_ok, "Got a different response from Server_DH_params_ok"
    return sentDh.Server_DH_params_ok

template rangeCheck(val: BigInt, min: BigInt, max: BigInt) =
    securityCheck min < val and val < max

proc stage3(self: MTProtoNetwork, dhParams: Server_DH_params_ok,
        newNonce: UInt256, nonce: UInt128, serverNonce: UInt128, b: seq[
                uint8]): Future[(BigInt, BigInt, BigInt)] {.async.} =
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
    var encryptedAnswer = newTLStream(cast[seq[uint8]](dhParams.encrypted_answer))
    let decrypted = aesIGE(tempAesKey, tempAesIV, encryptedAnswer, false)
    let decryptedStream = newTLStream(decrypted[20..(decrypted.high)])
    let decryptedTL = tl.TLDecode(decryptedStream)

    securityCheck decryptedTL of Server_DH_inner_data, "Expecting decrypted data to be of type Server_DH_inner_data, got a different type"

    let serverDH = decryptedTL.Server_DH_inner_data
    securityCheck serverDH.nonce == nonce
    securityCheck serverDH.server_nonce == serverNonce
    
    debug("[AUTHKEY] Computing dhPrime, gA, b and gB...")
    let dhPrime = fromBytesBE(cast[seq[uint8]](serverDH.dh_prime))
    let gA = fromBytesBE(cast[seq[uint8]](serverDH.g_a))
    let b = fromBytesBE(b)
    let gB = powmod(initBigInt(serverDH.g), b, dhPrime)
    #let gAb = powmod(gA, b, dhPrime)
    
    const one = initBigInt(1)
    rangeCheck initBigInt(serverDH.g), one, (dhPrime - one)
    rangeCheck gA, one, (dhPrime - one)
    rangeCheck gB, one, (dh_prime - one)

    const safeRange = initBigInt(1 shl (2048 - 64))
    rangeCheck gA, safeRange, (dh_prime - safeRange)
    rangeCheck gB, safeRange, (dh_prime - safeRange)
    
    debug("[AUTHKEY] Preparing Client_DH_inner_data...")
    
    var innerData: TLStream

    block:
        var data = setConstructorID(Client_DH_inner_data(
                nonce: serverDH.nonce,
                server_nonce: serverDH.server_nonce,
                retry_id: 0,
                g_b: cast[string](gB.toBytesBE())
        )).TLEncode()
        data = sha1.digest(data).data[0..19] & data
        while len(data) mod 16 != 0: data.add(0)
        innerData = newTLStream(data)
    
    
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

    return (gA, b, dhPrime)

proc createAuthKeySalt(gA: BigInt, b: BigInt, dhPrime: BigInt, newNonce: seq[
        uint8], serverNonce: seq[uint8]): (BigInt, uint64) =
    ## Compute auth key and the first salt to be used
    
    debug("[AUTHKEY] Computing AuthKey...")
    result[0] = powmod(gA, b, dhPrime)
    debug("[AUTHKEY] Computing first salt...")
    result[1] = fromBytes(uint64, newNonce[0..7], cpuEndian) xor fromBytes(
            uint64, serverNonce[0..7], cpuEndian)

proc executeAuthKeyGeneration*(self: MTProtoNetwork): Future[(seq[uint8], int64)] {.async.} =
    ## Execute auth key generation on the specified connection
    
    debug("[AUTHKEY] Generating a new auth key")
    debug("[AUTHKEY] Executing stage1..")
    let nonce = cast[UInt128](urandom(16))
    let pq = await self.stage1(nonce)
   
    debug("[AUTHKEY] Executing stage2...")
    let newNonce = cast[UInt256](urandom(32))
    let dhParams = await self.stage2(pq, newNonce)
    
    debug("[AUTHKEY] Executing stage3...")
    let (gA, b, dhPrime) = await self.stage3(dhParams, newNonce, pq.nonce,
            pq.server_nonce, urandom(256))
   
    debug("[AUTHKEY] Finalizing AuthKey creation...")
    let (authKey, salt) = createAuthKeySalt(gA, b, dhPrime, toBytes(newNonce,
            cpuEndian)[0..31], toBytes(dhParams.server_nonce, cpuEndian)[0..15])
    
    debug("[AUTHKEY] AuthKey generated successfully")
    return (authKey.toBytesBE(), cast[int64](salt))


proc testAuthKeyGeneration() {.async, used.} =
    ## Simulate a connection between the client and Telegram to test if the auth key generation is working as expected
    let dummyNet = newDummy()
    const nonce = fromHex(UInt128, "7f1533f5c0400000000000000010")
    const newNonce = fromHex(UInt256, "7f1533f422e800007f1533f4335000007f1533f5d0a00000000000000020")
    dummyNet.writeServerDummy(@[uint8(0), 0, 0, 0, 0, 0, 0, 0, 1, 12, 254, 139,
            136, 63, 58, 98, 80, 0, 0, 0, 99, 36, 22, 5, 16, 0, 0, 0, 0, 0, 0,
            0, 64, 192, 245, 51, 21, 127, 0, 0, 243, 49, 163, 206, 60, 3, 159,
            209, 163, 211, 98, 150, 193, 64, 220, 35, 8, 26, 109, 140, 96, 5,
            95, 118, 135, 0, 0, 0, 21, 196, 181, 28, 3, 0, 0, 0, 2, 159, 75,
            161, 109, 16, 146, 150, 33, 107, 232, 108, 2, 43, 180, 195, 3, 38,
            141, 32, 223, 152, 88, 178])
    echo "Executing stage1"
    let pq = await dummyNet.stage1(nonce)
    
    doAssert dummyNet.receiveServerDummy() == @[uint8(0), 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 128, 20, 0, 0, 0, 241, 142, 126, 190, 16, 0, 0,
                    0, 0, 0, 0, 0, 64, 192,
            245, 51, 21, 127, 0, 0]
    doAssert pq.TLEncode() == @[uint8(99), 36, 22, 5, 16, 0, 0, 0, 0, 0, 0, 0,
            64, 192, 245, 51, 21, 127, 0, 0, 243, 49, 163, 206, 60, 3, 159, 209,
            163, 211, 98, 150, 193, 64, 220, 35, 8, 26, 109, 140, 96, 5, 95,
            118, 135, 0, 0, 0, 21, 196, 181, 28, 3, 0, 0, 0, 2, 159, 75, 161,
            109, 16, 146, 150, 33, 107, 232, 108, 2, 43, 180, 195, 3, 38, 141,
            32, 223, 152, 88, 178]
    dummyNet.writeServerDummy(@[uint8(0), 0, 0, 0, 0, 0, 0, 0, 1, 144, 122, 42,
            137, 63, 58, 98, 120, 2, 0, 0, 92, 7, 232, 208, 16, 0, 0, 0, 0, 0,
            0, 0, 64, 192, 245, 51, 21, 127, 0, 0, 243, 49, 163, 206, 60, 3,
            159, 209, 163, 211, 98, 150, 193, 64, 220, 35, 254, 80, 2, 0, 82, 9,
            143, 55, 89, 149, 79, 209, 233, 39, 121, 193, 169, 22, 81, 20, 30,
            135, 11, 187, 79, 206, 94, 38, 36, 21, 99, 230, 53, 80, 206, 106,
            152, 131, 64, 52, 203, 4, 10, 92, 81, 41, 94, 159, 147, 163, 176,
            184, 228, 123, 251, 206, 149, 240, 216, 248, 172, 110, 90, 213, 36,
            162, 206, 124, 19, 112, 42, 255, 230, 126, 81, 5, 158, 117, 129,
            236, 190, 65, 127, 66, 80, 237, 91, 59, 45, 142, 85, 247, 51, 58,
            145, 33, 184, 223, 235, 61, 194, 97, 214, 227, 184, 92, 204, 15, 3,
            236, 129, 156, 145, 40, 52, 107, 190, 198, 84, 202, 182, 112, 227,
            30, 30, 220, 214, 51, 50, 209, 62, 116, 142, 216, 163, 244, 23, 20,
            198, 8, 195, 234, 9, 202, 83, 63, 79, 252, 56, 7, 3, 115, 10, 189,
            232, 2, 142, 82, 118, 203, 59, 147, 250, 41, 86, 209, 89, 164, 24,
            235, 108, 209, 219, 233, 233, 174, 231, 193, 111, 151, 34, 30, 11,
            210, 28, 238, 54, 41, 146, 200, 169, 247, 50, 123, 165, 207, 166,
            75, 207, 73, 77, 52, 157, 189, 3, 65, 160, 185, 220, 110, 203, 235,
            237, 122, 93, 41, 117, 213, 149, 175, 142, 189, 144, 42, 141, 78,
            207, 184, 223, 151, 88, 33, 102, 215, 126, 18, 17, 95, 46, 219, 65,
            63, 147, 255, 244, 126, 63, 128, 175, 234, 191, 7, 22, 202, 108,
            124, 35, 96, 91, 240, 82, 93, 78, 230, 235, 169, 199, 212, 197, 208,
            195, 241, 75, 230, 242, 158, 240, 191, 107, 56, 184, 110, 127, 240,
            245, 187, 174, 93, 75, 149, 135, 181, 31, 90, 63, 170, 6, 194, 90,
            214, 33, 10, 122, 157, 171, 186, 42, 198, 75, 202, 11, 62, 35, 195,
            170, 135, 148, 18, 150, 114, 139, 194, 82, 226, 186, 39, 6, 198, 25,
            136, 192, 25, 218, 71, 224, 160, 208, 162, 169, 70, 19, 196, 144,
            224, 101, 44, 239, 65, 122, 41, 125, 89, 208, 227, 172, 230, 21, 33,
            188, 213, 181, 81, 188, 33, 79, 216, 26, 213, 223, 134, 128, 123,
            252, 239, 93, 232, 36, 69, 160, 117, 50, 137, 54, 59, 133, 192, 133,
            187, 209, 254, 198, 75, 220, 216, 206, 132, 1, 97, 88, 82, 126, 43,
            177, 199, 110, 80, 173, 224, 203, 167, 195, 105, 123, 75, 211, 171,
            125, 71, 241, 234, 101, 38, 84, 109, 151, 157, 179, 21, 247, 222,
            33, 35, 247, 173, 89, 170, 245, 46, 171, 138, 141, 97, 132, 243,
            233, 40, 55, 183, 4, 0, 229, 48, 215, 189, 183, 107, 101, 228, 175,
            217, 165, 65, 37, 98, 203, 72, 67, 58, 101, 19, 97, 93, 81, 247,
            158, 197, 217, 13, 235, 251, 133, 134, 104, 199, 245, 11, 243, 118,
            160, 153, 200, 18, 181, 118, 11, 163, 202, 197, 155, 175, 96, 207,
            57, 59, 198, 41, 251, 241, 239, 152, 45, 136, 87, 212, 96, 62, 70,
            57, 85, 53, 2, 30, 59, 233, 223, 15, 220, 116, 129, 118, 100, 77,
            153, 186, 38, 29, 171, 124, 220, 223, 32, 131, 214, 25, 26, 78, 106,
            191, 209, 81, 155, 210, 23, 42, 6, 81, 240, 112, 219, 222, 207, 191,
            89, 47, 114, 177, 100, 91, 8, 239, 128, 120, 207, 135, 26, 223, 116,
            91, 0, 172, 125, 239, 47, 55, 166, 81, 80, 143, 224, 194, 62, 16,
            251, 181, 226, 86])
    echo "Executing stage2"

    let dhParams = await dummyNet.stage2(pq, newNonce)

    doAssert dummyNet.receiveServerDummy()  == @[uint8(0), 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 128, 64, 1, 0, 0, 190, 228, 18, 215, 16, 0, 0,
            0, 0, 0, 0, 0, 64, 192, 245, 51, 21, 127, 0, 0, 243, 49, 163, 206,
            60, 3, 159, 209, 163, 211, 98, 150, 193, 64, 220, 35, 4, 61, 143,
            180, 247, 0, 0, 0, 4, 109, 230, 54, 241, 0, 0, 0, 33, 107, 232, 108,
            2, 43, 180, 195, 254, 0, 1, 0, 93, 231, 207, 203, 225, 162, 55, 136,
            242, 142, 71, 236, 60, 141, 20, 93, 161, 251, 184, 57, 26, 165, 179,
            100, 235, 139, 173, 60, 153, 113, 160, 171, 172, 121, 101, 147, 46,
            247, 155, 52, 94, 189, 127, 113, 137, 205, 226, 68, 123, 78, 93,
            238, 84, 203, 125, 57, 241, 15, 118, 191, 98, 97, 108, 73, 106, 10,
            26, 83, 48, 45, 61, 200, 234, 62, 213, 90, 44, 98, 129, 34, 78, 110,
            3, 17, 167, 195, 33, 129, 153, 139, 236, 200, 31, 247, 15, 117, 208,
            81, 236, 206, 226, 138, 137, 32, 215, 58, 31, 59, 42, 252, 152, 180,
            149, 74, 244, 203, 222, 85, 70, 88, 119, 86, 50, 113, 84, 180, 129,
            230, 93, 56, 156, 214, 9, 40, 26, 110, 80, 2, 209, 225, 66, 144, 70,
            131, 12, 74, 118, 182, 49, 183, 81, 83, 217, 119, 237, 93, 236, 113,
            70, 161, 234, 69, 24, 178, 76, 241, 89, 57, 28, 194, 156, 29, 112,
            39, 162, 215, 230, 160, 121, 58, 111, 243, 61, 195, 85, 25, 62, 82,
            61, 37, 110, 163, 243, 138, 148, 252, 177, 223, 124, 176, 66, 221,
            155, 168, 104, 238, 8, 158, 172, 197, 42, 141, 183, 129, 245, 118,
            223, 48, 37, 116, 15, 148, 162, 90, 241, 21, 69, 122, 178, 41, 27,
            11, 139, 184, 230, 50, 86, 194, 225, 55, 51, 66, 91, 232, 206, 82,
            140, 169, 68, 57, 206, 49, 89, 207, 210, 89]
    doAssert dhParams.TLEncode() == @[uint8(92), 7, 232, 208, 16, 0, 0, 0, 0, 0,
            0, 0, 64, 192, 245, 51, 21, 127, 0, 0, 243, 49, 163, 206, 60, 3,
            159, 209, 163, 211, 98, 150, 193, 64, 220, 35, 254, 80, 2, 0, 82, 9,
            143, 55, 89, 149, 79, 209, 233, 39, 121, 193, 169, 22, 81, 20, 30,
            135, 11, 187, 79, 206, 94, 38, 36, 21, 99, 230, 53, 80, 206, 106,
            152, 131, 64, 52, 203, 4, 10, 92, 81, 41, 94, 159, 147, 163, 176,
            184, 228, 123, 251, 206, 149, 240, 216, 248, 172, 110, 90, 213, 36,
            162, 206, 124, 19, 112, 42, 255, 230, 126, 81, 5, 158, 117, 129,
            236, 190, 65, 127, 66, 80, 237, 91, 59, 45, 142, 85, 247, 51, 58,
            145, 33, 184, 223, 235, 61, 194, 97, 214, 227, 184, 92, 204, 15, 3,
            236, 129, 156, 145, 40, 52, 107, 190, 198, 84, 202, 182, 112, 227,
            30, 30, 220, 214, 51, 50, 209, 62, 116, 142, 216, 163, 244, 23, 20,
            198, 8, 195, 234, 9, 202, 83, 63, 79, 252, 56, 7, 3, 115, 10, 189,
            232, 2, 142, 82, 118, 203, 59, 147, 250, 41, 86, 209, 89, 164, 24,
            235, 108, 209, 219, 233, 233, 174, 231, 193, 111, 151, 34, 30, 11,
            210, 28, 238, 54, 41, 146, 200, 169, 247, 50, 123, 165, 207, 166,
            75, 207, 73, 77, 52, 157, 189, 3, 65, 160, 185, 220, 110, 203, 235,
            237, 122, 93, 41, 117, 213, 149, 175, 142, 189, 144, 42, 141, 78,
            207, 184, 223, 151, 88, 33, 102, 215, 126, 18, 17, 95, 46, 219, 65,
            63, 147, 255, 244, 126, 63, 128, 175, 234, 191, 7, 22, 202, 108,
            124, 35, 96, 91, 240, 82, 93, 78, 230, 235, 169, 199, 212, 197, 208,
            195, 241, 75, 230, 242, 158, 240, 191, 107, 56, 184, 110, 127, 240,
            245, 187, 174, 93, 75, 149, 135, 181, 31, 90, 63, 170, 6, 194, 90,
            214, 33, 10, 122, 157, 171, 186, 42, 198, 75, 202, 11, 62, 35, 195,
            170, 135, 148, 18, 150, 114, 139, 194, 82, 226, 186, 39, 6, 198, 25,
            136, 192, 25, 218, 71, 224, 160, 208, 162, 169, 70, 19, 196, 144,
            224, 101, 44, 239, 65, 122, 41, 125, 89, 208, 227, 172, 230, 21, 33,
            188, 213, 181, 81, 188, 33, 79, 216, 26, 213, 223, 134, 128, 123,
            252, 239, 93, 232, 36, 69, 160, 117, 50, 137, 54, 59, 133, 192, 133,
            187, 209, 254, 198, 75, 220, 216, 206, 132, 1, 97, 88, 82, 126, 43,
            177, 199, 110, 80, 173, 224, 203, 167, 195, 105, 123, 75, 211, 171,
            125, 71, 241, 234, 101, 38, 84, 109, 151, 157, 179, 21, 247, 222,
            33, 35, 247, 173, 89, 170, 245, 46, 171, 138, 141, 97, 132, 243,
            233, 40, 55, 183, 4, 0, 229, 48, 215, 189, 183, 107, 101, 228, 175,
            217, 165, 65, 37, 98, 203, 72, 67, 58, 101, 19, 97, 93, 81, 247,
            158, 197, 217, 13, 235, 251, 133, 134, 104, 199, 245, 11, 243, 118,
            160, 153, 200, 18, 181, 118, 11, 163, 202, 197, 155, 175, 96, 207,
            57, 59, 198, 41, 251, 241, 239, 152, 45, 136, 87, 212, 96, 62, 70,
            57, 85, 53, 2, 30, 59, 233, 223, 15, 220, 116, 129, 118, 100, 77,
            153, 186, 38, 29, 171, 124, 220, 223, 32, 131, 214, 25, 26, 78, 106,
            191, 209, 81, 155, 210, 23, 42, 6, 81, 240, 112, 219, 222, 207, 191,
            89, 47, 114, 177, 100, 91, 8, 239, 128, 120, 207, 135, 26, 223, 116,
            91, 0, 172, 125, 239, 47, 55, 166, 81, 80, 143, 224, 194, 62, 16,
            251, 181, 226, 86]
    dummyNet.writeServerDummy(@[uint8(0), 0, 0, 0, 0, 0, 0, 0, 1, 32, 247, 212,
            138, 63, 58, 98, 52, 0, 0, 0, 52, 247, 203, 59, 16, 0, 0, 0, 0, 0,
                    0, 0,
            64, 192, 245, 51, 21, 127, 0, 0, 243, 49, 163, 206, 60, 3, 159, 209,
            163, 211, 98, 150, 193, 64, 220, 35, 222, 17, 89, 174, 89, 189, 200,
            137, 202, 90, 157, 153, 120, 247, 73, 149])
    echo "Executing stage3"

    let (gA, b, dhPrime) = await dummyNet.stage3(dhParams, newNonce, pq.nonce,
            pq.server_nonce, @[uint8(172), 106, 48, 55, 223, 49, 127, 9, 41, 40,
                    1, 132, 239, 9, 40, 16, 113, 127, 60, 164, 254, 102, 78,
                    110, 174, 80, 131, 104, 158, 15, 243, 62, 167, 250, 170,
                    173, 16, 70, 27, 22, 87, 87, 231, 228, 180, 71, 41, 254,
                    186, 120, 40, 242, 172, 35, 134, 173, 63, 58, 99, 215, 241,
                    121, 197, 40, 98, 66, 10, 114, 174, 46, 156, 249, 104, 233,
                    254, 143, 121, 255, 210, 67, 20, 230, 1, 149, 48, 234, 246,
                    128, 154, 30, 82, 123, 140, 176, 105, 119, 109, 90, 81, 39,
                    211, 158, 197, 150, 246, 121, 144, 107, 131, 125, 173, 28,
                    157, 49, 3, 101, 65, 160, 237, 16, 32, 132, 70, 60, 139, 45,
                    20, 154, 204, 97, 161, 220, 128, 111, 144, 119, 180, 116,
                    161, 83, 252, 240, 55, 246, 74, 168, 141, 139, 51, 81, 225,
                    29, 98, 246, 176, 214, 251, 29, 225, 194, 76, 182, 54, 47,
                    139, 79, 177, 86, 120, 202, 118, 92, 38, 11, 124, 13, 218,
                    106, 109, 8, 0, 119, 191, 108, 208, 82, 146, 171, 179, 164,
                    152, 214, 97, 84, 133, 68, 252, 127, 137, 249, 186, 131,
                    102, 50, 162, 102, 152, 155, 228, 242, 45, 93, 255, 184,
                    187, 38, 187, 149, 12, 83, 254, 153, 189, 51, 0, 217, 164,
                    144, 72, 158, 92, 92, 55, 11, 0, 135, 226, 254, 3, 103, 172,
                    146, 162, 238, 22, 130, 159, 34, 180, 66, 157, 166, 46, 165,
                    154, 23])
    doAssert gA.toBytesBE() == @[uint8(178), 125, 49, 59, 174, 254, 9, 74, 25,
            183, 196, 138, 134, 37, 81, 254, 164, 132, 58, 182, 202, 97, 156,
            117, 52, 249, 127, 59, 160, 164, 43, 79, 93, 134, 183, 219, 111,
            202, 225, 25, 38, 219, 87, 82, 70, 125, 155, 100, 171, 115, 73, 18,
            175, 152, 242, 234, 200, 242, 21, 141, 135, 65, 198, 21, 193, 184,
            131, 81, 215, 206, 251, 238, 100, 29, 39, 63, 167, 43, 193, 110,
            127, 171, 55, 158, 164, 81, 169, 207, 57, 174, 59, 60, 67, 208, 62,
            41, 171, 53, 209, 193, 162, 102, 204, 143, 207, 90, 94, 160, 157,
            165, 45, 128, 83, 197, 37, 213, 122, 44, 234, 148, 218, 101, 220,
            29, 195, 13, 247, 250, 253, 235, 190, 88, 12, 190, 136, 19, 41, 86,
            48, 228, 229, 143, 184, 110, 205, 252, 225, 233, 198, 120, 129, 215,
            207, 144, 46, 75, 196, 29, 43, 15, 233, 225, 133, 109, 103, 47, 155,
            187, 224, 227, 219, 112, 69, 93, 40, 95, 86, 9, 245, 90, 9, 4, 233,
            19, 11, 151, 255, 30, 169, 85, 63, 46, 138, 186, 150, 191, 107, 96,
            119, 79, 149, 209, 69, 156, 200, 180, 98, 134, 253, 52, 156, 36, 53,
            243, 98, 246, 45, 66, 176, 31, 39, 245, 146, 89, 155, 141, 239, 196,
            6, 165, 97, 159, 63, 3, 120, 219, 89, 213, 20, 72, 81, 196, 122, 31,
            135, 6, 38, 78, 157, 227, 245, 148, 34, 165, 38, 227]
    doAssert b.toBytesBE() == @[uint8(172), 106, 48, 55, 223, 49, 127, 9, 41, 40,
                    1, 132, 239, 9, 40, 16, 113, 127, 60, 164, 254, 102, 78,
                    110, 174, 80, 131, 104, 158, 15, 243, 62, 167, 250, 170,
                    173, 16, 70, 27, 22, 87, 87, 231, 228, 180, 71, 41, 254,
                    186, 120, 40, 242, 172, 35, 134, 173, 63, 58, 99, 215, 241,
                    121, 197, 40, 98, 66, 10, 114, 174, 46, 156, 249, 104, 233,
                    254, 143, 121, 255, 210, 67, 20, 230, 1, 149, 48, 234, 246,
                    128, 154, 30, 82, 123, 140, 176, 105, 119, 109, 90, 81, 39,
                    211, 158, 197, 150, 246, 121, 144, 107, 131, 125, 173, 28,
                    157, 49, 3, 101, 65, 160, 237, 16, 32, 132, 70, 60, 139, 45,
                    20, 154, 204, 97, 161, 220, 128, 111, 144, 119, 180, 116,
                    161, 83, 252, 240, 55, 246, 74, 168, 141, 139, 51, 81, 225,
                    29, 98, 246, 176, 214, 251, 29, 225, 194, 76, 182, 54, 47,
                    139, 79, 177, 86, 120, 202, 118, 92, 38, 11, 124, 13, 218,
                    106, 109, 8, 0, 119, 191, 108, 208, 82, 146, 171, 179, 164,
                    152, 214, 97, 84, 133, 68, 252, 127, 137, 249, 186, 131,
                    102, 50, 162, 102, 152, 155, 228, 242, 45, 93, 255, 184,
                    187, 38, 187, 149, 12, 83, 254, 153, 189, 51, 0, 217, 164,
                    144, 72, 158, 92, 92, 55, 11, 0, 135, 226, 254, 3, 103, 172,
                    146, 162, 238, 22, 130, 159, 34, 180, 66, 157, 166, 46, 165,
                    154, 23]
    doAssert b.toBytesBE() == @[uint8(172), 106, 48, 55, 223, 49, 127, 9, 41, 40,
                    1, 132, 239, 9, 40, 16, 113, 127, 60, 164, 254, 102, 78,
                    110, 174, 80, 131, 104, 158, 15, 243, 62, 167, 250, 170,
                    173, 16, 70, 27, 22, 87, 87, 231, 228, 180, 71, 41, 254,
                    186, 120, 40, 242, 172, 35, 134, 173, 63, 58, 99, 215, 241,
                    121, 197, 40, 98, 66, 10, 114, 174, 46, 156, 249, 104, 233,
                    254, 143, 121, 255, 210, 67, 20, 230, 1, 149, 48, 234, 246,
                    128, 154, 30, 82, 123, 140, 176, 105, 119, 109, 90, 81, 39,
                    211, 158, 197, 150, 246, 121, 144, 107, 131, 125, 173, 28,
                    157, 49, 3, 101, 65, 160, 237, 16, 32, 132, 70, 60, 139, 45,
                    20, 154, 204, 97, 161, 220, 128, 111, 144, 119, 180, 116,
                    161, 83, 252, 240, 55, 246, 74, 168, 141, 139, 51, 81, 225,
                    29, 98, 246, 176, 214, 251, 29, 225, 194, 76, 182, 54, 47,
                    139, 79, 177, 86, 120, 202, 118, 92, 38, 11, 124, 13, 218,
                    106, 109, 8, 0, 119, 191, 108, 208, 82, 146, 171, 179, 164,
                    152, 214, 97, 84, 133, 68, 252, 127, 137, 249, 186, 131,
                    102, 50, 162, 102, 152, 155, 228, 242, 45, 93, 255, 184,
                    187, 38, 187, 149, 12, 83, 254, 153, 189, 51, 0, 217, 164,
                    144, 72, 158, 92, 92, 55, 11, 0, 135, 226, 254, 3, 103, 172,
                    146, 162, 238, 22, 130, 159, 34, 180, 66, 157, 166, 46, 165,
                    154, 23]
    doAssert dhPrime.toBytesBE() == @[uint8(199), 28, 174, 185, 198, 177, 201,
            4, 142, 108, 82, 47, 112, 241, 63, 115, 152, 13, 64, 35, 142, 62,
            33, 193, 73, 52, 208, 55, 86, 61, 147, 15, 72, 25, 138, 10, 167,
            193, 64, 88, 34, 148, 147, 210, 37, 48, 244, 219, 250, 51, 111, 110,
            10, 201, 37, 19, 149, 67, 174, 212, 76, 206, 124, 55, 32, 253, 81,
            246, 148, 88, 112, 90, 198, 140, 212, 254, 107, 107, 19, 171, 220,
            151, 70, 81, 41, 105, 50, 132, 84, 241, 143, 175, 140, 89, 95, 100,
            36, 119, 254, 150, 187, 42, 148, 29, 91, 205, 29, 74, 200, 204, 73,
            136, 7, 8, 250, 155, 55, 142, 60, 79, 58, 144, 96, 190, 230, 124,
            249, 164, 164, 166, 149, 129, 16, 81, 144, 126, 22, 39, 83, 181,
            107, 15, 107, 65, 13, 186, 116, 216, 168, 75, 42, 20, 179, 20, 78,
            14, 241, 40, 71, 84, 253, 23, 237, 149, 13, 89, 101, 180, 185, 221,
            70, 88, 45, 177, 23, 141, 22, 156, 107, 196, 101, 176, 214, 255,
            156, 163, 146, 143, 239, 91, 154, 228, 228, 24, 252, 21, 232, 62,
            190, 160, 248, 127, 169, 255, 94, 237, 112, 5, 13, 237, 40, 73, 244,
            123, 249, 89, 217, 86, 133, 12, 233, 41, 133, 31, 13, 129, 21, 246,
            53, 177, 5, 238, 46, 78, 21, 208, 75, 36, 84, 191, 111, 79, 173,
            240, 52, 177, 4, 3, 17, 156, 216, 227, 185, 47, 204, 91]
    echo "Executing createAuthKeySalt"
    let (authKey, salt) = createAuthKeySalt(gA, b, dhPrime, toBytes(newNonce,
            bigEndian)[0..31], toBytes(dhParams.server_nonce, bigEndian)[
                    0..15])
    doAssert authKey == initBigInt("2815072920265221215882709835248151631682472534789976772388277679770177862385418168731432744522139506560243308041886140630035819126881983161557638770301359017434694499620036871886650720736931523175823582419192444712067366905607712739212847597775924373487930810937972572450459850821262770867188326152389248611382640422730581075745705696876265497573813798615306160916813001738259893767679667551326140681164865411809082666029229577199547603680503783969463069943293649575953057673651404273395448384306291837895652018782324116734174298952666881957733543450978340239228399167980601230138182763849873790030745942634916827032",
            10)
    doAssert salt == uint64(5472320661206588451)
