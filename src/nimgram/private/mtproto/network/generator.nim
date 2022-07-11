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

import std/tables
import std/nativesockets

import transports
import tcp/abridged
import tcp/intermediate

const
    IP_TEST = {
        1: "149.154.175.10",
        2: "149.154.167.40",
        3: "149.154.175.117",
    }

    IP_PROD = {
        1: "149.154.175.53",
        2: "149.154.167.51",
        3: "149.154.175.100",
        4: "149.154.167.91",
        5: "91.108.56.130"
    }

    IP_PROD_MEDIA = {
        2: "149.154.167.151",
        4: "149.154.164.250"
    }

    IP_TEST_IPV6 = {
        1: "2001:b28:f23d:f001::e",
        2: "2001:67c:4e8:f002::e",
        3: "2001:b28:f23d:f003::e",
    }

    IP_PROD_IPV6 = {
        1: "2001:b28:f23d:f001::a",
        2: "2001:67c:4e8:f002::a",
        3: "2001:b28:f23d:f003::a",
        4: "2001:67c:4e8:f004::a",
        5: "2001:b28:f23f:f005::a"
    }

    IP_PROD_IPV6_MEDIA = {
        2: "2001:067c:04e8:f002:0000:0000:0000:000b",
        4: "2001:067c:04e8:f004:0000:0000:0000:000b"
    }

proc getIP(num: int, ipv6 = false, test = false, media = false): string =
    if test:
        if ipv6:
            return IP_TEST_IPV6.toTable[num]
        else:
            return IP_TEST.toTable[num]
    else:
        if ipv6:
            if media:
                return IP_PROD_IPV6_MEDIA.toTable[num]
            else:
                return IP_PROD_IPV6.toTable[num]
        else:
            if media:
                return IP_PROD_MEDIA.toTable[num]
            else:
                return IP_PROD.toTable[num]

proc createConnection*(connectionType: ConnectionType, dcID: int, ipv6 = false, testmode = false, media = false): MTProtoNetwork =
    ## Prepare a new connection with the specified connection type to a datacenter
    
    case connectionType
    of TCPAbridged:
        result = newAbridged(getIP(dcID, ipv6, testmode, media), Port(80))
    of TCPIntermediate:
        result = newIntermediate(getIP(dcID, ipv6, testmode, media), Port(80))
