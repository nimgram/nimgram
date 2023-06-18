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

import macros, std/macros as nimmacros

import client_types
export NimgramClient

proc send*(self: NimgramClient, body: TLFunction): Future[TL] {.async.} =
    ## Send a low level TL Function
    ## import `pkg/tltypes` to access the correct types
    if self.private.closed:
        raise newException(CatchableError, "The client was closed, create a new instance to continue")
    if not self.private.init:
        raise newException(CatchableError, "The client has not been started yet")
    return await self.private.mtprotoClient.send(body)

proc startClient(self: NimgramClient) {.async.} =
    ## (Internal) start the low-level client and check if user is authorized
    try:
        await self.private.mtprotoClient.startClient()
    except CatchableError:
        self.private.starting = false
        raise
    self.private.init = true
    self.private.starting = false
    try:
        discard await self.private.mtprotoClient.send(UsersGetFullUser(
                id: InputUserSelf().setConstructorID).setConstructorID)
        self.private.authenticated = true
        #if self.private.updateProc.isSome: await self.private.updateProc.get()(self, UpdateAuthorizationState(authorizationState: AuthorizationStateReady()))
    except exceptions.RPCError as ex:
        if ex.errorMessage == "AUTH_KEY_UNREGISTERED":
            discard
            #if self.updateProc.isSome: await self.updateProc.get()(self, UpdateAuthorizationState(authorizationState: AuthorizationStateWaitAuthentication()))
        else:
            raise

proc logOut*(self: NimgramClient) {.async.} =
    ## Logout from the current user session
    if self.private.closed:
        raise newException(CatchableError, "The client was closed, create a new instance to continue")
    if not self.private.init:
        raise newException(CatchableError, "The client has not been started yet")

    self.private.authenticated = false
    self.private.loggingOut = true
    #if self.private.updateProc.isSome: await self.private.updateProc.get()(self, UpdateAuthorizationState(authorizationState: AuthorizationStateLoggingOut()))
    try:
        doAssert (await self.send(AuthLogOut().setConstructorID)) of AuthLoggedOut
    # if self.updateProc.isSome: await self.updateProc.get()(self, UpdateAuthorizationState(authorizationState: AuthorizationStateWaitAuthentication()))
    except CatchableError:
        self.private.loggingOut = false
        raise

proc initializeNimgram*(client: NimgramClient, apiId: int, apiHash: string,
        databaseFilename: string, useTestDc = false, systemLanguageCode: string,
        deviceModel: string, systemVersion: string,
        applicationVersion: string) {.async.} =
    ## Initialize Nimgram with the specified parameters
    if client.private.closed:
        raise newException(CatchableError, "The client was closed, create a new instance to continue")
    if client.private.starting or client.private.init:
        return
    client.private.starting = true
    client.private.mtprotoClient = newClient(apiId, apiHash, deviceModel,
            systemVersion, applicationVersion, systemLanguageCode,
                    systemLanguageCode, useTestMode = useTestDc,
                    storageFileName = databaseFilename)
    asyncCheck client.startClient()

proc initializeNimgram*(apiId: int, apiHash: string, databaseFilename: string,
        useTestDc = false, systemLanguageCode: string, deviceModel: string,
        systemVersion: string, applicationVersion: string): NimgramClient =
    ## Initialize Nimgram with the specified parameters

    result = new NimgramClient
    waitFor result.initializeNimgram(apiId, apiHash, databaseFilename,
            useTestDc, systemLanguageCode, deviceModel, systemVersion, applicationVersion)

proc startNimgram*(apiId: int, apiHash: string, useTestDc = false,
        databaseFilename = "nimgram-sessions.db", langCode = "en",
        systemLanguageCode = "en", deviceModel = "Unknown",
        systemVersion = "Unknown", applicationVersion = "devel",
        ipv6 = false): Future[NimgramClient] {.async.} =
    ## Start Nimgram with the specified parameters.
    ## This function is different from initializeNimgram because it will wait the client to be initialized

    result = new NimgramClient
    result.private.starting = true
    result.private.mtprotoClient = newClient(apiId, apiHash, deviceModel,
            systemVersion, applicationVersion, langCode, systemLanguageCode,
                    useTestMode = useTestDc, storageFileName = databaseFilename,
                    useIpv6 = ipv6)
    await result.startClient()

proc botLogin*(self: NimgramClient, token: string) {.NimgramApi, async.} =
    ## Login as a bot.
    ## Works only when the current authorization state is authorizationStateWaitPhoneNumber.

    if self.private.authenticated:
        return
    if not self.private.init:
        raise newException(CatchableError, "The client has not been started yet")
    while true:
        try:
            discard await self.private.mtprotoClient.send(AuthImportBotAuthorization(
                api_id: self.private.mtprotoClient.connectionInfo.apiID,
                api_hash: self.private.mtprotoClient.connectionInfo.apiHash,
                bot_auth_token: token).setConstructorID)
            self.private.authenticated = true
            #if self.updateProc.isSome: await self.updateProc.get()(self, UpdateAuthorizationState(authorizationState: AuthorizationStateReady()))
            break
        except exceptions.RPCError as ex:
            if ex.errorMessage.startsWith("USER_MIGRATE_"):
                let migrateDC = parseInt(ex.errorMessage.split("_")[2])
                await self.private.mtprotoClient.switchDc(migrateDC)
            else:
                raise

proc close*(self: NimgramClient) {.async.} =
    self.private.closing = true
    #if self.updateProc.isSome: await self.updateProc.get()(self, UpdateAuthorizationState(authorizationState: AuthorizationStateClosing()))

    try:
        await self.private.mtprotoClient.stop()
    except:
        self.private.closing = false
        self.private.closed = true
        self.private.init = false
        raise
    self.private.closing = false
    self.private.closed = true
    self.private.init = false

proc getAuthorizationState*(self: NimgramClient): Future[
        AuthorizationState] {.async.} =
    ## Get the current authorization state

    if self.private.init:
        if self.private.authenticated:
            return AuthorizationStateReady()
        elif self.private.loggingOut:
            return AuthorizationStateLoggingOut()
        elif self.private.closing:
            return AuthorizationStateClosing()
        return AuthorizationStateWaitAuthentication()
    elif self.private.closed:
        return AuthorizationStateClosed()
    else:
        if not self.private.sentFirstAuthorizationState:
            self.private.sentFirstAuthorizationState = true
            #if self.private.updateProc.isSome: await self.updateProc.get()(self, UpdateAuthorizationState(authorizationState: AuthorizationStateUninitialized()))
        return AuthorizationStateUninitialized()
