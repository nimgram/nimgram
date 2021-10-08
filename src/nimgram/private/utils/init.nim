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

proc getSession(self: NimgramClient, keys: InternalTableOptions, dcID: int,
        connectionType: NetworkTypes, ipv6, test: bool = false,
        storageManager: NimgramStorage, config: NimgramConfig, disableNewSessionCheck: bool = false): Future[
        Session] {.async.} =
    var ip = getIp(dcID, ipv6, test)
    if keys.original.hasKey(dcID):
        let connection = new MTProtoNetwork
        await connection.connect(connectionType, ip, 443)
        result = initSession(connection, self.logger, dcID, keys.original[
                dcID].authKey, keys.original[dcID].salt, storageManager, config, disableNewSessionCheck)
    else:
        self.logger.log(lvlDebug, &"Generating new session on DC{dcID}")
        let connection = new MTProtoNetwork
        await connection.connect(connectionType, ip, 443)
        var gen = await generateAuthKey(connection)
        keys.original[dcID] = binmanager.DcOption(number: uint16(dcID),
                isAuthorized: false, isMain: false, authKey: gen[0], salt: gen[1])
        await storageManager.writeSessionsInfo(keys.original)
        result = initSession(connection, self.logger, dcID, gen[0], gen[1],
                storageManager, config, disableNewSessionCheck)


proc initNimgram*(databinFile: string, config: NimgramConfig,
        storageType: StorageTypes = StorageRam, logLevel: int = 7): Future[
        NimgramClient] {.async.} =
    result = new NimgramClient
    result.logger = initLogger(logLevel, true)
    result.logger.log(lvlInfo, &"Starting Nimgram version {NIMGRAM_VERSION}")
    result.logger.log(lvlDebug, "Initializing storage")
    var driver: NimgramStorage
    if storageType == StorageSqlite:
        when compileOption("threads"):
            driver = NimgramStorageSqlite().NimgramStorage
            driver.init(NimgramStorageConfigSqlite(filename: databinFile,
                    disableCache: config.disableCache))
        else:
            raise newException(CatchableError, "Threads are disabled, cannot use sqlite")
    if storageType == StorageRam:
        driver = NimgramStorageRam().NimgramStorage
        driver.init(NimgramStorageConfigRam(binfilename: dataBinFile))

    result.logger.log(lvlDebug, "Loading sessions")
    result.config = config
    result.storageManager = driver
    result.updateHandler = newUpdateHandler()
    var sessions = InternalTableOptions(
            original: await result.storageManager.getSessionsInfo())
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
        result.sessions[result.mainDc] = await result.getSession(sessions,
                result.mainDc, config.transportMode, config.useIpv6,
                config.testMode, result.storageManager, config)
        result.sessions[result.mainDc].isRequired = true
    else:
        result.mainDc = 1
        result.isMainAuthorized = false
        result.sessions[result.mainDc] = await result.getSession(sessions, 1,
                config.transportMode, config.useIpv6, config.testMode,
                result.storageManager, config)
        result.sessions[result.mainDc].isRequired = true
        sessions.original[result.mainDc].isMain = true
        await result.storageManager.writeSessionsInfo(sessions.original)

    asyncCheck result.sessions[result.mainDc].startHandler(result,
            result.updateHandler)
    try:
        await result.sessions[result.mainDc].sendMTProtoInit(true, true)
    except RPCException:
        raise
    except CatchableError:
        discard


