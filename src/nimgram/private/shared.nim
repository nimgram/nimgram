import tables
import network/transports

const NIMGRAM_VERSION* = 0.01

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