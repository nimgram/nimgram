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

## Module implementing the IGE algorithm for AES

import pkg/nimcrypto/rijndael

import tltypes/decode


proc aesIGE*(key: seq[uint8], iv: seq[uint8], message: TLStream, doEncrypt: bool): seq[uint8] =

    doAssert key.len == 32, "key must be 32 bytes long"
    doAssert iv.len == 32, "iv must be 32 bytes long"

    var cipher: aes256 
    cipher.init(key)

    doAssert message.len mod 16 == 0, "data lenght must be a multiple of 16 bytes"

    var cryptedXored = (if not doEncrypt: iv[16..31] else: iv[0..15])
    var ivp = (if not doEncrypt: iv[0..15] else: iv[16..31])
    var chunk = newSeq[uint8](16)
    while message.len > 0:
        
        chunk = message.readBytes(16)

        for i2 in countup(0, 15):
            cryptedXored[i2] = cryptedXored[i2] xor chunk[i2]
        if doEncrypt:
            cipher.encrypt(cryptedXored, cryptedXored)
        else:
            cipher.decrypt(cryptedXored, cryptedXored)

        for i2 in countup(0, 15):
            cryptedXored[i2] = ivp[i2] xor cryptedXored[i2]

        ivp = chunk
        result.add(cryptedXored)

        


