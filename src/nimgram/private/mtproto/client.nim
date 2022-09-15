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

## Module implementing a low-level client object

import std/options, std/strformat, std/asyncdispatch, pkg/norm/sqlite, std/logging
import types, ../utils/[message_id, exceptions]
import network/[transports, generator], ../storage/[storage_interfaces], ../storage/generator as generatorNetwork
import auth_key_gen, session
import pkg/tltypes/decode, pkg/tltypes

type MTProtoClient* = ref object
  connectionInfo*: ConnectionInfo
  storage: NimgramStorage
  testMode: bool
  session: MTProtoSession
  messageID: MessageID

proc newClient*(apiID: int, apiHash, deviceModel, systemVersion, appVersion, langCode, systemLangCode: string, useIpv6 = false, useTestMode = false, storageFileName = "nimgram-sessions.db", storageType = SqliteStorage, connectionType = TCPAbridged): MTProtoClient = 
  result = MTProtoClient(
    connectionInfo: ConnectionInfo(
      apiID: uint32(apiID),
      apiHash: apiHash,
      deviceModel: deviceModel,
      systemVersion: systemVersion,
      appVersion: appVersion,
      systemLangCode: systemLangCode,
      langPack: "",
      langCode: langCode,
      connectionType: connectionType,
      ipv6: useIpv6,
    ),
    storage: createStorage(storageType, storageFileName),
    testMode: useTestMode,
    messageID: createMessageID()
  )

proc startClient*(self: MTProtoClient) {.async.} =
    ## Start the low-level client
    
    info("[MTPROTOCLIENT] Starting MTProtoClient...")

    var defaultSession: (int, bool, bool, seq[uint8], int64)

    try: 
        defaultSession = await self.storage.getDefaultSession()
    except NotFoundError:
        notice("[MTPROTOCLIENT] No default session found, generating a new session")
        
        while true:
            try:
                let authNetwork = createConnection(self.connectionInfo.connectionType, 2, self.connectionInfo.ipv6, self.testMode, false)
                await authNetwork.connect()
                (defaultSession[3], defaultSession[4]) = await authNetwork.executeAuthKeyGeneration()
                await authNetwork.close()
                break
            except SecurityError:
                notice("[MTPROTOCLIENT] Failed to generate auth key on dc2, retrying... ", getCurrentExceptionMsg())
                await sleepAsync(2000)

        defaultSession[0] = 2
        defaultSession[1] = self.testMode
        defaultSession[2] = false
        await self.storage.addOrEditSession(defaultSession[0], defaultSession[1], defaultSession[2], defaultSession[3], defaultSession[4], some(true))
    self.session = createSession(self.connectionInfo, self.messageID, self.storage, defaultSession[3], cast[uint64](defaultSession[4]), defaultSession[0], defaultSession[1], false, false)
    await self.session.start()


proc send*(self: MTProtoClient, body: TL): Future[TL] {.async.} =
    ## Send a raw TL object
    
    return await self.session.send(body)

proc switchDc*(self: MTProtoClient, newDcId: int) {.async.} = 
    ## Close the current session and switch to the specified datacenter
    ## This will also update the default datacenter to be used
    
    notice(&"[MTPROTOCLIENT] Switching to dc{newDcId}")

    var newSession: (seq[uint8], int64)

    try: 
        newSession = await self.storage.getSession(newDcId, self.testMode, false)
    except NotFoundError:
        notice(&"[MTPROTOCLIENT] No default session found for dc{newDcId}, generating a new session")
        
        while true:
            try:
                let authNetwork = createConnection(self.connectionInfo.connectionType, newDcId, self.connectionInfo.ipv6, self.testMode, false)
                await authNetwork.connect()
                newSession = await authNetwork.executeAuthKeyGeneration()
                await authNetwork.close()
                break
            except SecurityError:
                notice(&"[MTPROTOCLIENT] Failed to generate auth key on dc{newDcId}, retrying... ", getCurrentExceptionMsg())
                await sleepAsync(2000)
    
    let defaultSession = await self.storage.getDefaultSession()
    await self.storage.addOrEditSession(defaultSession[0], defaultSession[1], defaultSession[2], defaultSession[3], defaultSession[4], some(false))

    await self.storage.addOrEditSession(newDcId, self.testMode, false, newSession[0], newSession[1], some(true))
    await self.session.stop()   
    self.session = createSession(self.connectionInfo, self.messageID, self.storage, newSession[0], cast[uint64](newSession[1]), newDcId, self.testMode, false, false)
    await self.session.start()
    
    notice(&"[MTPROTOCLIENT] Switched to dc{newDcId}")

proc stop*(self: MTProtoClient) {.async.} =
    ## Stop the current session
    await self.session.stop()
    await self.storage.close()