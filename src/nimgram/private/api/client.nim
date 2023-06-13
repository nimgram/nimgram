# Nimgram
# Copyright (C) 2020-2023 Daniele Cortesi <https://github.com/dadadani>
# This file is part of Nimgram, under the MIT License
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import std/asyncdispatch, std/strutils, std/options
import ../mtproto/[client, types], pkg/tltypes, ../utils/exceptions
import authorization_state, updates

type NimgramClient* = ref object
    mtprotoClient: MTProtoClient
    init: bool
    sentFirstAuthorizationState: bool
    updateProc: Option[proc(client: NimgramClient, update: Update) {.async.}]
    authenticated: bool
    closed: bool
    starting: bool
    loggingOut: bool
    closing: bool


proc send*(self: NimgramClient, body: TLFunction): Future[TL] {.async.} = 
    ## Send a low level TL Function
    ## import `pkg/tltypes` to access the correct types
    if self.closed:
        raise newException(CatchableError, "The client was closed, create a new instance to continue")
    if not self.init:
        raise newException(CatchableError, "The client has not been started yet")
    return await self.mtprotoClient.send(body)

proc startClient(self: NimgramClient) {.async.} =
    ## (Internal) start the low-level client and check if user is authorized
    try:
        await self.mtprotoClient.startClient()
    except:
        self.starting = false
        raise
    self.init = true            
    self.starting = false
    try:
        discard await self.mtprotoClient.send(UsersGetFullUser(id: InputUserSelf().setConstructorID).setConstructorID)
        self.authenticated = true  
        if self.updateProc.isSome: await self.updateProc.get()(self, UpdateAuthorizationState(authorizationState: AuthorizationStateReady()))
    except exceptions.RPCError as ex:
        if ex.errorMessage == "AUTH_KEY_UNREGISTERED":
            if self.updateProc.isSome: await self.updateProc.get()(self, UpdateAuthorizationState(authorizationState: AuthorizationStateWaitAuthentication()))
        else:
            raise

proc setUpdateCallback*(self: NimgramClient, updateProc: (proc(client: NimgramClient, update: Update) {.async.})) = 
    ## Set the procedure to be called when an update is sent
    
    self.updateProc = some(updateProc)

proc logOut*(self: NimgramClient) {.async.} =
    ## Logout from the current user session
    if self.closed:
        raise newException(CatchableError, "The client was closed, create a new instance to continue")
    if not self.init:
        raise newException(CatchableError, "The client has not been started yet")
    
    self.authenticated = false
    self.loggingOut = true        
    if self.updateProc.isSome: await self.updateProc.get()(self, UpdateAuthorizationState(authorizationState: AuthorizationStateLoggingOut()))
    try:
        doAssert (await self.send(AuthLogOut().setConstructorID)) of AuthLoggedOut
        if self.updateProc.isSome: await self.updateProc.get()(self, UpdateAuthorizationState(authorizationState: AuthorizationStateWaitAuthentication()))
    except:
        self.loggingOut = false
        raise

proc initializeNimgram*(client: NimgramClient, apiId: int, apiHash: string, databaseFilename: string, useTestDc = false, systemLanguageCode: string, deviceModel: string, systemVersion: string, applicationVersion: string) {.async.} = 
    ## Initialize Nimgram with the specified parameters
    if client.closed:
        raise newException(CatchableError, "The client was closed, create a new instance to continue")
    if client.starting or client.init:
        return
    client.starting = true
    client.mtprotoClient = newClient(apiId, apiHash, deviceModel, systemVersion,
            applicationVersion, systemLanguageCode, systemLanguageCode, useTestMode = useTestDc, storageFileName = databaseFilename)
    asyncCheck client.startClient()

proc initializeNimgram*(apiId: int, apiHash: string, databaseFilename: string, useTestDc = false, systemLanguageCode: string, deviceModel: string, systemVersion: string, applicationVersion: string): NimgramClient = 
    ## Initialize Nimgram with the specified parameters
    
    result = new NimgramClient
    waitFor result.initializeNimgram(apiId, apiHash, databaseFilename, useTestDc, systemLanguageCode, deviceModel, systemVersion, applicationVersion)

proc startNimgram*(apiId: int, apiHash: string, useTestDc = false, databaseFilename = "nimgram-sessions.db", langCode = "en", systemLanguageCode = "en", deviceModel = "Unknown", systemVersion = "Unknown", applicationVersion = "devel", ipv6 = false): Future[NimgramClient] {.async.} =
    ## Start Nimgram with the specified parameters.
    ## This function is different from initializeNimgram because it will wait the client to be initialized
    
    result = new NimgramClient
    result.starting = true
    result.mtprotoClient = newClient(apiId, apiHash, deviceModel, systemVersion,
            applicationVersion, langCode, systemLanguageCode, useTestMode = useTestDc, storageFileName = databaseFilename, useIpv6 = ipv6)
    await result.startClient()

proc botLogin*(self: NimgramClient, token: string) {.async.} =
    ## Login as a bot. 
    ## Works only when the current authorization state is authorizationStateWaitPhoneNumber.
    
    if self.authenticated:
        return
    if not self.init:
        raise newException(CatchableError, "The client has not been started yet")
    while true:
        try:
            discard await self.mtprotoClient.send(AuthImportBotAuthorization(
                api_id: self.mtprotoClient.connectionInfo.apiID, api_hash: self.mtprotoClient.connectionInfo.apiHash,
                bot_auth_token: token).setConstructorID)
            self.authenticated = true
            if self.updateProc.isSome: await self.updateProc.get()(self, UpdateAuthorizationState(authorizationState: AuthorizationStateReady()))
            break
        except exceptions.RPCError as ex:
            if ex.errorMessage.startsWith("USER_MIGRATE_"):
                let migrateDC = parseInt(ex.errorMessage.split("_")[2])
                await self.mtprotoClient.switchDc(migrateDC)
            else:
                raise

proc close*(self: NimgramClient) {.async.} =
    self.closing = true
    if self.updateProc.isSome: await self.updateProc.get()(self, UpdateAuthorizationState(authorizationState: AuthorizationStateClosing()))

    try:
        await self.mtprotoClient.stop()
    except:
        self.closing = false
        self.closed = true
        self.init = false
        raise
    self.closing = false
    self.closed = true
    self.init = false

proc getAuthorizationState*(self: NimgramClient): Future[AuthorizationState] {.async.} = 
    ## Get the current authorization state
    
    if self.init:
        if self.authenticated:
            return AuthorizationStateReady()
        elif self.loggingOut:
            return AuthorizationStateLoggingOut()
        elif self.closing:
            return AuthorizationStateClosing()
        return AuthorizationStateWaitAuthentication()
    elif self.closed:
        return AuthorizationStateClosed()
    else:
        if not self.sentFirstAuthorizationState:
            self.sentFirstAuthorizationState = true
            if self.updateProc.isSome: await self.updateProc.get()(self, UpdateAuthorizationState(authorizationState: AuthorizationStateUninitialized()))
        return AuthorizationStateUninitialized()