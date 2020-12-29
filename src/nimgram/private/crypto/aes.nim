
import nimcrypto

# Since Nimcrypto does not have an implementation of IGE, here's one made by me 

proc xorBlock(destination: array[16, uint8], source: array[16, uint8]): array[16, uint8] =
    var i = 0
    for _ in destination:
        result[i] = source[i] xor destination[i]
        inc(i)

proc blockAsArray(data: seq[uint8]): array[16, uint8] =
    for i in countup(0, 15):
        result[i] = data[i]


proc aesIGE*(key, iv, message: seq[uint8], doEncrypt: bool): seq[uint8] =
    if key.len != 32:
        raise newException(Exception, "key must be 32 bytes long")

    if len(iv) != 32:
        raise newException(Exception, "iv must be 32 bytes long")

    var cipher: aes256
    cipher.init(key)

    if message.len mod 16 != 0:
        raise newException(Exception, "data lenght must be a multiple of 16 bytes, instead is " & $message.len)

    var ivp = blockAsArray(iv[0..15])
    var ivp2 = blockAsArray(iv[16..31])
    var ciphered: seq[uint8]

    var i = 0
    while i < len(message):
        if not doEncrypt:
            var xored = xorBlock(blockAsArray(message[i..i+15]), ivp2)
            var decryptedXored: array[16, uint8]
            cipher.decrypt(xored, decryptedXored)

            var outdata = xorBlock(decryptedXored, ivp)
            ivp = blockAsArray(message[i..i+15])
            ivp2 = outdata
            ciphered.add(outdata)
        else:
            var xored = xorBlock(blockAsArray(message[i..i+15]),  ivp)
            var encryptedXored: array[16, uint8]
            cipher.encrypt(xored, encryptedXored)
            
            var outdata = xorBlock(encryptedXored, ivp2)
            ivp = outdata
            ivp2 = blockAsArray(message[i..i+15])
            ciphered.add(outdata)

        i += 16

    return ciphered
