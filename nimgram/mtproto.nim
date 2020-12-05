import client/rpc/mtproto
import client/rpc/api
import client/storage
import client/network/transports
import asyncdispatch
import random
import client/session

type NimgramClient* = ref object 
    mainSession: Session

type NimgramConfig* = object
    testMode*: bool
    transportMode*: TcpNetworkTypes
    apiID*: int32
    apiHash*: string
    deviceModel*: string
    systemVersion*: string
    appVersion*: string
    systemLangCode*: string
    langPack*: string
    langCode*: string



const TestModeIp = "149.154.167.40"
const TestmodePort = 443

const ProdModeIp = "149.154.167.91"
const ProdModePort = 443

proc initNimgram*(databinFile: string, config: NimgramConfig): Future[NimgramClient] {.async.} = 

    var ip = ""
    var port = 0

    if config.testMode:
        ip = TestModeIp
        port = TestmodePort
    else:
        ip = ProdModeIp
        port = ProdModePort


    result = new NimgramClient
    var autsalt = await authSalt(databinFile, ip, uint16(port), config.transportMode)
    if autsalt.connectionOpened:
        result.mainSession = initSession(autsalt.connection, 2, autsalt.authKey, autsalt.salt, databinFile)
    else:
        var connection = await newConnection(ip, uint16(port), config.transportMode) 
        result.mainSession = initSession(connection, 2, autsalt.authKey, autsalt.salt, databinFile)
    asyncCheck result.mainSession.startHandler()
    let pingID = int64(rand(9999))
    var ponger = await result.mainSession.send(ping(ping_id: pingID))
    if not(ponger of pong):
        raise newException(Exception, "Ping failed with type " & ponger.originalName)
    assert ponger.pong.ping_id == pingID

    #TODO: Use help_getConfig properly
    discard await result.mainSession.send(invokeWithLayer(layer: 120, query: initConnection(
        api_id: config.apiID,
        device_model: config.deviceModel,
        system_version: config.systemVersion,
        app_version: config.appVersion,
        system_lang_code: config.systemLangCode,
        lang_pack: config.langPack,
        lang_code: config.langCode,
        query: help_getConfig())), false)

    
proc send*(self: NimgramClient, function: TLFunction): Future[TLObject] {.async.} =
    result = await self.mainSession.send(function)

proc setCallback*(self: NimgramClient, callback: proc(updates: UpdatesI): Future[void] {.async.}) =
    self.mainSession.setCallback(callback)
