
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
import nimgram/private/network/tcp/abridged
import nimgram/private/network/tcp/intermediate
import nimgram/private/network/transports
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



include nimgram/private/types/files/file_location
include nimgram/private/types/chats/pic
include nimgram/private/types/other
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



include nimgram/private/types/chats/user
include nimgram/private/types/messages/message

proc send*(self: Session, tl: TL, waitResponse: bool = true,
        ignoreInitDone: bool = false): Future[TL] {.async.}
proc checkConnectionLoop*(self: Session) {.async.}

include nimgram/private/updates

include nimgram/private/session

include nimgram/private/utils/init

include nimgram/private/methods/messages/send_message


when isMainModule:
  {.fatal: "Hey! This is the main module file of Nimgram, please import the library instead of running it directly".}
