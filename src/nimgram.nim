
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

import nimgram/private/rpc/raw
import nimgram/private/storage
import nimgram/private/network/transports
import nimgram/private/network/generator
import asyncdispatch
import tables
import random
import strformat
import nimgram/private/shared
import nimgram/private/utils/[binmanager, auth_key, logging, revert_channel_id]
import strutils
export NetworkTypes
export NimgramConfig

import options


type Response = ref object
    event: AsyncEvent
    body: TL

type Session* = ref object
    isRequired*: bool
    isDead*: bool
    initDone*: bool
    authKey: seq[uint8]
    alreadyCalledDisconnected: bool
    resumeConnectionWait*: AsyncEvent
    authKeyID: seq[uint8]
    disableNewSessionCheck: bool
    storageManager: NimgramStorage
    clientConfig: NimgramConfig
    serverSalt: seq[uint8]
    dcID: int
    activeReceiver: bool
    logger: Logger
    sessionID: seq[uint8]
    seqNo: int
    acks: seq[int64]
    responses: Table[int64, Response]
    maxMessageID: uint64
    connection: MTProtoNetwork

type FunctionHandler = ref object of RootObj

type UpdateHandler* = ref object
    onMessageHandlers: FunctionHandler

proc newUpdateHandler(): UpdateHandler

type NimgramClient* = ref object
    logger: Logger
    sessions: Table[int, Session]
    updateHandler: UpdateHandler
    mainDc: int
    isMainAuthorized: bool
    config: NimgramConfig
    storageManager: NimgramStorage

type Media* = ref object of RootObj

include nimgram/private/utils/get_channel_id


proc getCorrectID*(peer: PeerI): int64 =
    if peer of PeerUser:
        result = peer.PeerUser.user_id.int64
    elif peer of PeerChat:
        result = int64(-peer.PeerChat.chat_id)
    elif peer of PeerChannel:
        result = getChannelId(peer.PeerChannel.channel_id)


include nimgram/private/types/files/input_file

include nimgram/private/types/chats/pic
include nimgram/private/types/chats/peer

include nimgram/private/types/keyboards/keyboard_button
include nimgram/private/types/keyboards/keyboard_markup
include nimgram/private/types/messages/location
include nimgram/private/types/messages/photo
include nimgram/private/types/messages/document
include nimgram/private/types/messages/webpage
include nimgram/private/types/messages/contact
include nimgram/private/types/messages/venue
include nimgram/private/types/messages/game
include nimgram/private/types/messages/dice
include nimgram/private/types/other



include nimgram/private/types/chats/user
include nimgram/private/types/messages/message

proc send*(self: Session, tl: TL, waitResponse: bool = true,
        ignoreInitDone: bool = false): Future[TL] {.async.}
proc checkConnectionLoop*(self: Session) {.async.}

proc sendMTProtoInit(self: Session, startCheck: bool, triggerDone: bool = false,
        miniInit: bool = false) {.async.}

include nimgram/private/updates

include nimgram/private/session

proc sendMTProtoInit(self: Session, startCheck: bool, triggerDone: bool = false,
        miniInit: bool = false) {.async.} =
    ## Used to initialize a connection to MTProto correctly
    ## `miniInit` is useful for example on session used by workers to get the fastest initialization possible

    let pingID = int64(rand(9999))
    let pong = await self.send(Ping(ping_id: pingID), not(miniInit), true)
    if not miniInit:
        doAssert pong of Pong
        doAssert pong.Pong.ping_id == pingID
    let config = await self.send(InvokeWithLayer(layer: LAYER_VERSION,
            query: InitConnection(api_id: self.clientConfig.apiID,
            device_model: self.clientConfig.deviceModel,
            system_version: self.clientConfig.systemVersion,
            app_version: self.clientConfig.appVersion,
            system_lang_code: self.clientConfig.systemLangCode,
            lang_pack: self.clientConfig.langPack,
            lang_code: self.clientConfig.langCode,
            query: HelpGetConfig())), not(miniInit), true)
    if not miniInit:
        doAssert config of Config
    if triggerDone:
        self.initDone = true
        self.resumeConnectionWait.trigger()
    if startCheck:
        asyncCheck self.checkConnectionLoop()



include nimgram/private/utils/init
include nimgram/private/utils/login
include nimgram/private/utils/peers
include nimgram/private/utils/data


include nimgram/private/methods/files/upload_file


include nimgram/private/methods/messages/send_message
include nimgram/private/methods/messages/send_document



when isMainModule:
    {.fatal: "Hey! This is the main module file of Nimgram, please import the library instead of running it directly".}
