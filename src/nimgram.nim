import nimgram/private/rpc/raw
import nimgram/private/storage
import nimgram/private/network/tcp/abridged
import nimgram/private/network/tcp/intermediate
import nimgram/private/network/transports
import asyncdispatch
import tables
import tables
import random
import nimgram/private/shared
import nimgram/private/utils/auth_key
import nimgram/private/utils/binmanager
import nimgram/private/session
export raw 
import strutils
export NetworkTypes

type StorageTypes* = enum
    StorageSqlite
    StorageRam

type InternalTableOptions = ref object
    original: Table[int, binmanager.DcOption]

type NimgramConfig* = object
    testMode*: bool
    transportMode*: NetworkTypes
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

type NimgramClient* = ref object 
    sessions: Table[int, Session]
    mainDc: int
    isMainAuthorized: bool
    config: NimgramConfig
    storageManager: NimgramStorage

proc getConnection(connectionType: NetworkTypes, address: string, port: uint16): Future[MTProtoNetwork] {.async.} =
    case connectionType:
    of NetTcpAbridged:
        var connection = new TcpAbridged
        await connection.connect(address, port)
        result = connection.MTProtoNetwork
    of NetTcpIntermediate:
        var connection = new TcpIntermediate
        await connection.connect(address, port)
        result = connection.MTProtoNetwork

proc getSession(keys: InternalTableOptions, dcID: int, connectionType: NetworkTypes, ipv6, test: bool = false, storageManager: NimgramStorage): Future[Session] {.async.} =
    var ip = getIp(dcID, ipv6, test)
    if keys.original.hasKey(dcID):
        var connection = await getConnection(connectionType, ip, 443)
        result = initSession(connection, dcID, keys.original[dcID].authKey, keys.original[dcID].salt, storageManager)
    else:
        var connection = await getConnection(connectionType, ip, 443)
        var gen = await generateAuthKey(connection)
        keys.original[dcID] = binmanager.DcOption(number: uint16(dcID), isAuthorized: false, isMain: false, authKey: gen[0], salt: gen[1])
        await storageManager.WriteSessionsInfo(keys.original)
        result = initSession(connection, dcID, gen[0], gen[1], storageManager)


proc initNimgram*(databinFile: string, config: NimgramConfig, storageType: StorageTypes = StorageRam): Future[NimgramClient] {.async.} = 

    var driver: NimgramStorage
    if storageType == StorageSqlite:
        when compileOption("threads"): 
            driver = NimgramStorageSqlite().NimgramStorage
            driver.Init(NimgramStorageConfigSqlite(filename: databinFile, disableCache: config.disableCache))
        else:
            raise newException(Exception, "Threads are disabled, cannot use sqlite")
    if storageType == StorageRam:
        driver = NimgramStorageRam().NimgramStorage
        driver.Init(NimgramStorageConfigRam(binfilename: dataBinFile))
    result = new NimgramClient
    result.config = config
    result.storageManager = driver
    var sessions = InternalTableOptions(original: await result.storageManager.GetSessionsInfo())
    var found = false
    var sessionMain: binmanager.DcOption
    for _, key in sessions.original:
        if key.isMain:
            found = true
            result.mainDc = int(key.number)
            result.isMainAuthorized = key.isAuthorized
            sessionMain = key
            break
    if found:
        result.sessions[result.mainDc] = await getSession(sessions, result.mainDc, config.transportMode, config.useIpv6, config.testMode, result.storageManager)
    else:
        result.mainDc = 1
        result.isMainAuthorized = false
        result.sessions[result.mainDc] = await getSession(sessions, 1, config.transportMode, config.useIpv6, config.testMode, result.storageManager)
        sessions.original[result.mainDc].isMain = true
        await result.storageManager.WriteSessionsInfo(sessions.original)

    asyncCheck result.sessions[result.mainDc].startHandler()
    let pingID = int64(rand(9999))

    var ponger = await result.sessions[result.mainDc].send(Ping(ping_id: pingID))
    if not(ponger of Pong):
        raise newException(Exception, "Ping failed with type " & ponger.getTypeName())
    doAssert ponger.Pong.ping_id == pingID

    #TODO: Use help_getConfig properly
    var config = await result.sessions[result.mainDc].send(InvokeWithLayer(layer: LAYER_VERSION, query: InitConnection(
        api_id: config.apiID,
        device_model: config.deviceModel,
        system_version: config.systemVersion,
        app_version: config.appVersion,
        system_lang_code: config.systemLangCode,
        lang_pack: config.langPack,
        lang_code: config.langCode,
        query: HelpGetConfig())), true)
    if not(config of Config):
        raise newException(Exception, "Failed to get help, type is of " & config.getTypeName())

proc send*(self: NimgramClient, function: TLFunction): Future[TL] {.async.} =
    result = await self.sessions[self.mainDc].send(function)

proc setCallback*(self: NimgramClient, callback: proc(updates: UpdatesI): Future[void] {.async.}) =
    self.sessions[self.mainDc].setCallback(callback)

proc botLogin*(self: NimgramClient, token: string) {.async.} =
    ## Login as a bot.
    ## Token is only sent to Telegram once, and not stored internally
    
    #Check if we are already logged in
    try: 
        discard await self.sessions[self.mainDc].send(UsersGetFullUser(id: InputUserSelf()))
    except:
        try:
            discard await self.sessions[self.mainDc].send(AuthImportBotAuthorization(
                api_id: self.config.apiID,
                api_hash: self.config.apiHash,
                bot_auth_token: token
            ))
        except CatchableError:
            #If USER_MIGRATE_X is received, create a new connection to the new datacenter and set as main
            var msgerror = getCurrentExceptionMsg()
            if msgerror.startsWith("USER_MIGRATE_"):
                var migrateDC = parseInt(getCurrentException().RPCException.errorMessage.split("_")[2])
                var sessions = InternalTableOptions(original: await self.storageManager.GetSessionsInfo())
                self.sessions[migrateDC] = await getSession(sessions, migrateDC, self.config.transportMode, self.config.useIpv6, self.config.testMode, self.storageManager)
                asyncCheck self.sessions[migrateDC].startHandler()
                let pingID = int64(rand(9999))

                var ponger = await self.sessions[migrateDC].send(Ping(ping_id: pingID))
                if not(ponger of Pong):
                    raise newException(Exception, "Ping failed with type " & ponger.getTypeName())
                doAssert ponger.Pong.ping_id == pingID

                #TODO: Use help_getConfig properly
                discard await self.sessions[migrateDC].send(InvokeWithLayer(layer: LAYER_VERSION, query: InitConnection(
                    api_id: self.config.apiID,
                    device_model: self.config.deviceModel,
                    system_version: self.config.systemVersion,
                    app_version: self.config.appVersion,
                    system_lang_code: self.config.systemLangCode,
                    lang_pack: self.config.langPack,
                    lang_code: self.config.langCode,
                    query: HelpGetConfig())), false)
                discard await self.sessions[migrateDC].send(AuthImportBotAuthorization(
                    api_id: self.config.apiID,
                    api_hash: self.config.apiHash,
                    bot_auth_token: token
                ))
                sessions.original[self.mainDc].isMain = false
                self.mainDc = migrateDc
                self.isMainAuthorized = true
                sessions.original[migrateDc].isMain = true
                await self.storageManager.WriteSessionsInfo(sessions.original)
