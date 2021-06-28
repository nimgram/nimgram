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
        raise newException(CatchableError, "key must be 32 bytes long")

    if iv.len != 32:
        raise newException(CatchableError, "iv must be 32 bytes long")

    var cipher: aes256
    cipher.init(key)

    if message.len mod 16 != 0:
        raise newException(CatchableError, "data lenght must be a multiple of 16 bytes, instead is " & $message.len)

    var ivp = iv[0..15].blockAsArray()
    var ivp2 = iv[16..31].blockAsArray()
    var ciphered: seq[uint8]

    var i = 0
    while i < message.len:
        if not doEncrypt:
            var xored = xorBlock(message[i..i+15].blockAsArray(), ivp2)
            var decryptedXored: array[16, uint8]
            cipher.decrypt(xored, decryptedXored)

            var outdata = xorBlock(decryptedXored, ivp)
            ivp = message[i..i+15].blockAsArray()
            ivp2 = outdata
            ciphered.add(outdata)
        else:
            var xored = xorBlock(message[i..i+15].blockAsArray(),  ivp)
            var encryptedXored: array[16, uint8]
            cipher.encrypt(xored, encryptedXored)
            
            var outdata = xorBlock(encryptedXored, ivp2)
            ivp = outdata
            ivp2 = message[i..i+15].blockAsArray()
            ciphered.add(outdata)

        i += 16

    return ciphered
