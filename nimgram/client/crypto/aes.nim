
import nimcrypto

# Since Nimcrypto does not have an implementation of IGE, here's one made by me 

proc xorBlock(destination: seq[uint8], source: seq[uint8]): seq[uint8] =
    result.newSeq(16)
    var i = 0
    for _ in destination:
        result[i] =  source[i] xor destination[i]
        inc(i)




proc aesIGE(message, key, iv: seq[uint8], doEncrypt: bool): seq[uint8] =
    var cipher: aes256
    cipher.init(key)

    if message.len mod 16 != 0:
        raise newException(Exception, "data lenght must be a multiple of 16 bytes, instead is " & $message.len)

    var ivp = iv[0..15]
    var ivp2 = iv[16..31]
    var ciphered: seq[uint8]

    var i = 0
    while i < len(message):
        var indata = message[i..i+15]
        if doEncrypt == false:
            var xored = xorBlock(indata, ivp2)
            var decryptedXored = newSeq[uint8](16)
            cipher.decrypt(xored, decryptedXored)

            var outdata = xorBlock(decryptedXored, ivp)
            ivp = indata
            ivp2 = outdata
            ciphered.add(outdata)
        else:
            var xored = xorBlock(indata,  ivp)
            var encryptedXored = newSeq[uint8](16)
            cipher.encrypt(xored, encryptedXored)
            var outdata = xorBlock(encryptedXored, ivp2)
            ivp = outdata
            ivp2 = indata
            ciphered.add(outdata)

        i += 16

    return ciphered


type AesIGE* = object 
    key: seq[uint8]
    iv: seq[uint8]

proc initAesIGE*(key, iv: seq[uint8]): AesIGE =
    if key.len != 32:
        raise newException(Exception, "key must be 32 bytes long")

    if len(iv) != 32:
        raise newException(Exception, "iv must be 32 bytes long")
    
    result.key = key
    result.iv = iv

proc decrypt*(self: AesIGE, data: seq[uint8]): seq[uint8] = aesIGE(data, self.key, self.iv, false)


proc encrypt*(self: AesIGE, data: seq[uint8]): seq[uint8] = aesIGE(data, self.key, self.iv, true)
