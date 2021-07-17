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

# Loaded by nimgram.nim
#
# This file contains essentials procs/types to initialize Nimgram

type StorageTypes* = enum
    StorageSqlite
    StorageRam

type InternalTableOptions = ref object
    original: Table[int, binmanager.DcOption]

proc clearCache*(self: NimgramClient): Future[void] {.async.} =
    self.storageManager.clearCache()

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

proc getSession(self: NimgramClient, keys: InternalTableOptions, dcID: int, connectionType: NetworkTypes, ipv6, test: bool = false, storageManager: NimgramStorage, config: NimgramConfig): Future[Session] {.async.} =
    var ip = getIp(dcID, ipv6, test)
    if keys.original.hasKey(dcID):
        var connection = await getConnection(connectionType, ip, 443)
        result = initSession(connection, self.logger, dcID, keys.original[dcID].authKey, keys.original[dcID].salt, storageManager, config)
    else:
        self.logger.log(lvlDebug, &"Generating new session on DC{dcID}")
        var connection = await getConnection(connectionType, ip, 443)
        var gen = await generateAuthKey(connection)
        keys.original[dcID] = binmanager.DcOption(number: uint16(dcID), isAuthorized: false, isMain: false, authKey: gen[0], salt: gen[1])
        await storageManager.writeSessionsInfo(keys.original)
        result = initSession(connection, self.logger, dcID, gen[0], gen[1], storageManager, config)


proc initNimgram*(databinFile: string, config: NimgramConfig, storageType: StorageTypes = StorageRam, logLevel: int = 7): Future[NimgramClient] {.async.} = 
    result = new NimgramClient
    result.logger = initLogger(logLevel, true)
    result.logger.log(lvlInfo, &"Starting Nimgram version {NIMGRAM_VERSION}, Copyright 2020 - 2021 Daniele Cortesi")
    result.logger.log(lvlDebug, "Initializing storage")
    var driver: NimgramStorage
    if storageType == StorageSqlite:
        when compileOption("threads"): 
            driver = NimgramStorageSqlite().NimgramStorage
            driver.init(NimgramStorageConfigSqlite(filename: databinFile, disableCache: config.disableCache))
        else:
            raise newException(CatchableError, "Threads are disabled, cannot use sqlite")
    if storageType == StorageRam:
        driver = NimgramStorageRam().NimgramStorage
        driver.init(NimgramStorageConfigRam(binfilename: dataBinFile))

    result.logger.log(lvlDebug, "Loading sessions")
    result.config = config
    result.storageManager = driver
    result.updateHandler = newUpdateHandler()
    var sessions = InternalTableOptions(original: await result.storageManager.getSessionsInfo())
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
        result.sessions[result.mainDc] = await result.getSession(sessions, result.mainDc, config.transportMode, config.useIpv6, config.testMode, result.storageManager, config)
        result.sessions[result.mainDc].isRequired = true
    else:
        result.mainDc = 1
        result.isMainAuthorized = false
        result.sessions[result.mainDc] = await result.getSession(sessions, 1, config.transportMode, config.useIpv6, config.testMode, result.storageManager, config)
        result.sessions[result.mainDc].isRequired = true
        sessions.original[result.mainDc].isMain = true
        await result.storageManager.writeSessionsInfo(sessions.original)

    asyncCheck result.sessions[result.mainDc].startHandler(result, result.updateHandler)
    let pingID = int64(rand(9999))
    try:
        var ponger = await result.sessions[result.mainDc].send(Ping(ping_id: pingID), true, true)
        if not(ponger of Pong):
            raise newException(CatchableError, "Ping failed!")
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
        doAssert config of Config, "Failed to get config"
        result.sessions[result.mainDc].initDone = true
        result.sessions[result.mainDc].resumeConnectionWait.trigger()
        asyncCheck result.sessions[result.mainDc].checkConnectionLoop()

    except RPCException:
        raise
    except CatchableError:
        #TODO: Sync response from automatic reconnection, but config now is unused, so not working on that currently
        discard
proc send*(self: NimgramClient, function: TLFunction, waitFor: bool = true): Future[TL] {.async.} =
    ## Send a raw TL function

    result = await self.sessions[self.mainDc].send(function, waitFor)


proc resolveInputPeer*(self: NimgramClient, id: int64): Future[InputPeerI] {.async.} =
    ## Get a InputPeer object by resolving access hash on local database

    #chat
    if id < 0 and id notin CHANNEL_RANGE:
        return InputPeerChat(chat_id: int32(id))
    var userpeer = await self.storageManager.getPeer(id)
    if id in CHANNEL_RANGE:
        return InputPeerChannel(channel_id: int32(revertChannelId(id)), access_hash: userpeer.accessHash)
    return InputPeerUser(user_id: int32(id), access_hash: userpeer.accessHash)



proc resolveInputPeer*(self: NimgramClient, peer: PeerI): Future[InputPeerI] {.async.} =
    ## Get a InputPeer object by resolving access hash on local database

    #chat
    if peer of PeerChat:
        return InputPeerChat(chat_id: peer.PeerChat.chat_id)
    #channel
    if peer of PeerChannel:
        var channelpeer = await self.storageManager.getPeer(getChannelId(peer.PeerChannel.channel_id))
        return InputPeerChannel(channel_id: peer.PeerChannel.channel_id, access_hash: channelpeer.accessHash)
    #user
    if peer of PeerUser:
        var userpeer = await self.storageManager.getPeer(peer.PeerUser.user_id)
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
                self.logger.log(lvlNotice, &"Switching to DC{migrateDC}")
                var sessions = InternalTableOptions(original: await self.storageManager.getSessionsInfo())
                #This will handle dh hankshake
                self.sessions[migrateDC] = await self.getSession(sessions, migrateDC, self.config.transportMode, self.config.useIpv6, self.config.testMode, self.storageManager, self.config)
                self.sessions[migrateDC].isRequired = true
                self.sessions[self.mainDc].isRequired = false
                #Connection initialization
                asyncCheck self.sessions[migrateDC].startHandler(self, self.updateHandler)
                let pingID = int64(rand(9999))

                try:
                    var ponger = await self.sessions[migrateDC].send(Ping(ping_id: pingID), true, true)
                    doAssert ponger of Pong, "Ping failed"
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
                    await self.storageManager.writeSessionsInfo(sessions.original)
                    asyncCheck self.sessions[migrateDC].checkConnectionLoop()
                except CatchableError:
                    #TODO: Sync response from automatic reconnection, but config now is unused, so not working on that currently
                    discard
                except RPCException:
                    raise

            else:
                raise
