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

import tables
import network/transports

const NIMGRAM_VERSION* = "0.1.0"

const MIN_CHANNEL_ID* = -1002147483647
const MAX_CHANNEL_ID* = -1000000000000
const CHANNEL_RANGE* = MIN_CHANNEL_ID .. MAX_CHANNEL_ID
const MIN_CHAT_ID* = -2147483647
const MAX_USER_ID* = 2147483647

const IP_TEST = {
    1: "149.154.175.10",
    2: "149.154.167.40",
    3: "149.154.175.117"
}

const IP_PROD = {
    1: "149.154.175.53",
    2: "149.154.167.51",
    3: "149.154.175.100",
    4: "149.154.167.91",
    5: "91.108.56.130"
}

const IP_TEST6 = {
    1: "2001:b28:f23d:f001::e",
    2: "2001:67c:4e8:f002::e",
    3: "2001:b28:f23d:f003::e"
}

const IP_PROD6 = {
    1: "2001:b28:f23d:f001::a",
    2: "2001:67c:4e8:f002::a",
    3: "2001:b28:f23d:f003::a",
    4: "2001:67c:4e8:f004::a",
    5: "2001:b28:f23f:f005::a"
}

proc getIP*(num: int, ipv6, test: bool = false): string =
    if ipv6:
        if test:
            return IP_TEST6.toTable[num]
        return IP_PROD6.toTable[num]
    if test:
        return IP_TEST.toTable[num]
    return IP_PROD.toTable[num]

type NimgramConfig* = object
    testMode*: bool
    transportMode*: transports.NetworkTypes
    useIpv6*: bool
    apiID*: int32
    disableCache*: bool
    apiHash*: string
    deviceModel*: string
    systemVersion*: string
    appVersion*: string
    systemLangCode*: string
    langPack*: string
    langCode*: string

type StoragePeer* = object
    peerID*: int64
    accessHash*: int64

