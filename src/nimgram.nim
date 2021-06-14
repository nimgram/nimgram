
## Nimgram
## Copyright (C) 2020-2021 Daniele Cortesi <https://github.com/dadadani>
## This file is part of Nimgram, under the MIT License
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY
## OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
## SOFTWARE.

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
import nimgram/private/utils/[binmanager, auth_key, logging]
import nimgram/private/session
import strutils
export NetworkTypes
export NimgramConfig

import options

type Media* = ref object of RootObj

proc getCorrectID*(peer: PeerI): int64 = 
    if peer of PeerUser:
        result = peer.PeerUser.user_id.int64
    elif peer of PeerChat:
        result = int64(-peer.PeerChat.chat_id)
    elif peer of PeerChannel:
        result = int64(-1000000000000 + peer.PeerChannel.channel_id)


include nimgram/private/utils/init

include nimgram/private/types/files/file_location
include nimgram/private/types/chats/pic
include nimgram/private/types/other
include nimgram/private/types/chats/peer

include nimgram/private/types/messages/location
include nimgram/private/types/messages/photo
include nimgram/private/types/messages/document
include nimgram/private/types/messages/webpage
include nimgram/private/types/messages/contact

include nimgram/private/types/chats/user
include nimgram/private/types/messages/message

