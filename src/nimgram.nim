import nimgram/private/rpc/raw
import nimgram/private/storage
import nimgram/private/network/tcp/abridged
import nimgram/private/network/tcp/intermediate
import nimgram/private/network/transports
import asyncdispatch
import tables
import random
import nimgram/private/shared
import nimgram/private/utils/auth_key
import nimgram/private/updates
import nimgram/private/utils/binmanager
import nimgram/private/session
export raw 
import strutils
export NetworkTypes
export NimgramConfig

type StorageTypes* = enum
    StorageSqlite
    StorageRam

type InternalTableOptions = ref object
    original: Table[int, binmanager.DcOption]

type NimgramClient* = ref object 
    sessions: Table[int, Session]
    mainDc: int
    isMainAuthorized: bool
    config: NimgramConfig
    storageManager: NimgramStorage

proc clearCache*(self: NimgramClient): Future[void] {.async.} =
    self.storageManager.ClearCache()

proc onUpdates*(self: NimgramClient, procedure: proc(updates: UpdatesI): Future[void] {.async.}) =
    self.sessions[self.mainDc].callbackUpdates.onUpdates(procedure)

proc onUpdateNewMessage*(self: NimgramClient, procedure: proc(updateNewMessage: UpdateNewMessage): Future[void] {.async.}) =
    self.sessions[self.mainDc].callbackUpdates.onUpdateNewMessage(procedure)

proc onUpdateNewChannelMessage*(self: NimgramClient, procedure: proc(updateNewChannelMessage: UpdateNewChannelMessage): Future[void] {.async.}) =
    self.sessions[self.mainDc].callbackUpdates.onUpdateNewChannelMessage(procedure)

proc onReconnection*(self: NimgramClient, procedure: proc(): Future[void] {.async.}) =
    ## Call the specified procedure when client is reconnected successfully to network (Only main datacenter)
    self.sessions[self.mainDc].callbackUpdates.onReconnection(procedure)

proc onDisconnection*(self: NimgramClient, procedure: proc(): Future[void] {.async.}) =
    ## Call the specified procedure when client is disconnected from network (Only main datacenter)
    self.sessions[self.mainDc].callbackUpdates.onDisconnection(procedure)
    
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

proc getSession(keys: InternalTableOptions, dcID: int, connectionType: NetworkTypes, ipv6, test: bool = false, storageManager: NimgramStorage, config: NimgramConfig): Future[Session] {.async.} =
    var ip = getIp(dcID, ipv6, test)
    if keys.original.hasKey(dcID):
        var connection = await getConnection(connectionType, ip, 443)
        result = initSession(connection, dcID, keys.original[dcID].authKey, keys.original[dcID].salt, storageManager, config)
    else:
        var connection = await getConnection(connectionType, ip, 443)
        var gen = await generateAuthKey(connection)
        keys.original[dcID] = binmanager.DcOption(number: uint16(dcID), isAuthorized: false, isMain: false, authKey: gen[0], salt: gen[1])
        await storageManager.WriteSessionsInfo(keys.original)
        result = initSession(connection, dcID, gen[0], gen[1], storageManager, config)


proc initNimgram*(databinFile: string, config: NimgramConfig, storageType: StorageTypes = StorageRam): Future[NimgramClient] {.async.} = 

    var driver: NimgramStorage
    if storageType == StorageSqlite:
        when compileOption("threads"): 
            driver = NimgramStorageSqlite().NimgramStorage
            driver.Init(NimgramStorageConfigSqlite(filename: databinFile, disableCache: config.disableCache))
        else:
            raise newException(CatchableError, "Threads are disabled, cannot use sqlite")
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
        result.sessions[result.mainDc] = await getSession(sessions, result.mainDc, config.transportMode, config.useIpv6, config.testMode, result.storageManager, config)
        result.sessions[result.mainDc].isRequired = true
    else:
        result.mainDc = 1
        result.isMainAuthorized = false
        result.sessions[result.mainDc] = await getSession(sessions, 1, config.transportMode, config.useIpv6, config.testMode, result.storageManager, config)
        result.sessions[result.mainDc].isRequired = true
        sessions.original[result.mainDc].isMain = true
        await result.storageManager.WriteSessionsInfo(sessions.original)

    asyncCheck result.sessions[result.mainDc].startHandler()
    let pingID = int64(rand(9999))
    try:
        var ponger = await result.sessions[result.mainDc].send(Ping(ping_id: pingID), true, true)
        if not(ponger of Pong):
            raise newException(CatchableError, "Ping failed with type " & ponger.getTypeName())
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
            query: HelpGetConfig())), true, true)
        doAssert config of Config, "Failed to get config, type is of " & config.getTypeName()
        result.sessions[result.mainDc].initDone = true
        result.sessions[result.mainDc].resumeConnectionWait.trigger()
        asyncCheck result.sessions[result.mainDc].checkConnectionLoop()
    except RPCException:
        raise
    except CatchableError:
        #TODO: Sync response from automatic reconnection, but config now is unused, so not working on that currently
        discard
proc send*(self: NimgramClient, function: TLFunction, waitFor: bool = true): Future[TL] {.async.} =
    result = await self.sessions[self.mainDc].send(function, waitFor)


proc resolveInputPeer*(self: NimgramClient, id: int64): Future[InputPeerI] {.async.} =
    #chat
    if id < 0 and id > -1000000000000:
        return InputPeerChat(chat_id: int32(id))
    var userpeer = await self.storageManager.GetPeer(id)
    if id < -1000000000000:
        return InputPeerChannel(channel_id: int32(($id).replace("-100", "").parseBiggestInt), access_hash: userpeer.accessHash)
    return InputPeerUser(user_id: int32(id), access_hash: userpeer.accessHash)



proc resolveInputPeer*(self: NimgramClient, peer: PeerI): Future[InputPeerI] {.async.} =
    #chat
    if peer of PeerChat:
        return InputPeerChat(chat_id: peer.PeerChat.chat_id)
    #channel
    if peer of PeerChannel:
        var channelpeer = await self.storageManager.GetPeer(("-100"& ($peer.PeerChannel.channel_id)).parseBiggestInt)
        return InputPeerChannel(channel_id: peer.PeerChannel.channel_id, access_hash: channelpeer.accessHash)
    #user
    if peer of PeerUser:
        var userpeer = await self.storageManager.GetPeer(peer.PeerUser.user_id)
        return InputPeerUser(user_id: peer.PeerUser.user_id, access_hash: userpeer.accessHash)




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
        except RPCException:
            #If USER_MIGRATE_X is received, create a new connection to the new datacenter and set as main
            var msgerror = getCurrentExceptionMsg()
            if msgerror.startsWith("USER_MIGRATE_"):
                var migrateDC = parseInt(getCurrentException().RPCException.errorMessage.split("_")[2])
                var sessions = InternalTableOptions(original: await self.storageManager.GetSessionsInfo())
                #This will handle dh hankshake
                self.sessions[migrateDC] = await getSession(sessions, migrateDC, self.config.transportMode, self.config.useIpv6, self.config.testMode, self.storageManager, self.config)
                self.sessions[migrateDC].isRequired = true
                self.sessions[self.mainDc].isRequired = false
                #Connection initialization
                asyncCheck self.sessions[migrateDC].startHandler()
                let pingID = int64(rand(9999))

                try:
                    var ponger = await self.sessions[migrateDC].send(Ping(ping_id: pingID), true, true)
                    doAssert ponger of Pong, "Ping failed with type " & ponger.getTypeName()
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
                        query: HelpGetConfig())), false, true)
                    self.sessions[migrateDC].initDone = true
                    self.sessions[migrateDC].resumeConnectionWait.trigger()
                    discard await self.sessions[migrateDC].send(AuthImportBotAuthorization(
                        api_id: self.config.apiID,
                        api_hash: self.config.apiHash,
                        bot_auth_token: token
                    ), true, true)
                    sessions.original[self.mainDc].isMain = false
                    self.mainDc = migrateDc
                    self.isMainAuthorized = true
                    sessions.original[migrateDc].isMain = true
                    await self.storageManager.WriteSessionsInfo(sessions.original)
                    asyncCheck self.sessions[migrateDC].checkConnectionLoop()
                except CatchableError:
                    #TODO: Sync response from automatic reconnection, but config now is unused, so not working on that currently
                    discard
                except RPCException:
                    raise

            else:
                raise
