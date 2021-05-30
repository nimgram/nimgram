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
 

## WIP, needs a complete rework
#[
import rpc/raw
import asyncdispatch
import storage
import shared
import strformat
import strutils
import options 
import types/message

type UpdatesCallback* = ref object
    callback: Option[proc(updates: UpdatesI): Future[void] {.async.}]
    eventUpdateNewMessage: Option[proc(updateNewMessage: UpdateNewMessage): Future[void] {.async.}]
    eventNetworkReconnected: Option[proc(): Future[void] {.async.}]
    eventNetworkDisconnected: Option[proc(): Future[void] {.async.}]
    eventUpdateNewChannelMessage: Option[proc(updateNewChannelMessage: UpdateNewChannelMessage): Future[void] {.async.}]
    eventMessage: Option[proc(message: message.Message): Future[void] {.async.}]


proc saveData(storage: NimgramStorage, users: seq[UserI], chats: seq[ChatI]) {.async.} = 
    for userGeneric in users:
        if userGeneric of User:
            let user = userGeneric.User
            if user.access_hash.isSome():
                await storage.AddPeer(StoragePeer(peerID: user.id, accessHash: user.access_hash.get()))
    for chatGeneric in chats:
        if chatGeneric of raw.Channel:
            let channel = cast[raw.Channel](chatGeneric)
            if channel.access_hash.isSome():
                await storage.AddPeer(StoragePeer(peerID: (&"-100{channel.id}").parseBiggestInt, accessHash: channel.access_hash.get()))



proc processUpdates*(self: UpdatesCallback, updates: UpdatesI, storage: NimgramStorage): Future[void] {.async.} =
    ## Process raw updates
    
    if self.callback.isSome():
        asyncCheck self.callback.get()(updates)

    if updates of Updates:
        var updatesType = updates.Updates
        await storage.saveData(updatesType.users, updatesType.chats)
        # Handle UpdateNewMessage
        for update in updatesType.updates:
            if update of UpdateNewMessage:
                if self.eventUpdateNewMessage.isSome():
                    asyncCheck self.eventUpdateNewMessage.get()(update.UpdateNewMessage)
                if update.UpdateNewMessage.message of raw.Message:
                    if self.eventMessage.isSome():
                        asyncCheck self.eventMessage.get()(parse(cast[raw.Message](update.UpdateNewMessage.message)))
        # Handle UpdateNewChannelMessage
            if update of UpdateNewChannelMessage:
                if self.eventUpdateNewChannelMessage.isSome():
                    asyncCheck self.eventUpdateNewChannelMessage.get()(update.UpdateNewChannelMessage)
                if update.UpdateNewChannelMessage.message of raw.Message:
                    if self.eventMessage.isSome():
                        asyncCheck self.eventMessage.get()(parse(cast[raw.Message](update.UpdateNewChannelMessage.message)))


    if updates of UpdateShort:
        var updateShort = updates.UpdateShort

        # Handle UpdateNewMessage
        if updateShort.update of UpdateNewMessage:
            if self.eventUpdateNewMessage.isSome():
                asyncCheck self.eventUpdateNewMessage.get()(updateShort.update.UpdateNewMessage)
            if updateShort.update.UpdateNewMessage.message of raw.Message:
                if self.eventMessage.isSome():
                    asyncCheck self.eventMessage.get()(parse(cast[raw.Message](updateShort.update.UpdateNewMessage.message)))
        # Handle UpdateNewChannelMessage
        if updateShort.update of UpdateNewChannelMessage:
            if self.eventUpdateNewChannelMessage.isSome():
                asyncCheck self.eventUpdateNewChannelMessage.get()(updateShort.update.UpdateNewChannelMessage)
            if updateShort.update.UpdateNewChannelMessage.message of raw.Message:
                if self.eventMessage.isSome():
                    asyncCheck self.eventMessage.get()(parse(cast[raw.Message](updateShort.update.UpdateNewChannelMessage.message)))

    if updates of UpdatesCombined:
        var updatesCombined = updates.UpdatesCombined
        await storage.saveData(updatesCombined.users, updatesCombined.chats)
        for update in updatesCombined.updates:
            
            # Handle UpdateNewMessage
            if update of UpdateNewMessage:
                if self.eventUpdateNewMessage.isSome():
                    asyncCheck self.eventUpdateNewMessage.get()(update.UpdateNewMessage)
                if update.UpdateNewMessage.message of raw.Message:
                    if self.eventMessage.isSome():
                        asyncCheck self.eventMessage.get()(parse(cast[raw.Message](update.UpdateNewMessage.message)))
            # Handle UpdateNewChannelMessage
            if update of UpdateNewChannelMessage:
                if self.eventUpdateNewChannelMessage.isSome():
                    asyncCheck self.eventUpdateNewChannelMessage.get()(update.UpdateNewChannelMessage)
                if update.UpdateNewChannelMessage.message of raw.Message:
                    if self.eventMessage.isSome():
                        asyncCheck self.eventMessage.get()(parse(cast[raw.Message](update.UpdateNewChannelMessage.message)))

proc onMessage*(self: UpdatesCallback, procedure: proc(message: message.Message): Future[void] {.async.}) =
    ## Procedure to be called when a Message is received (high level)

    self.eventMessage = some(procedure)

proc processNetworkReconnected*(self: UpdatesCallback) = 
    # Procedure to be called to handle "onReconnection"

    if self.eventNetworkReconnected.isSome():
        asyncCheck self.eventNetworkReconnected.get()()

proc processNetworkDisconnected*(self: UpdatesCallback) = 
    # Procedure to be called to handle "onDisconnection"

    if self.eventNetworkDisconnected.isSome():
        asyncCheck self.eventNetworkDisconnected.get()()
        
proc onReconnection*(self: UpdatesCallback, procedure: proc(): Future[void] {.async.}) =
    ## Call the specified procedure when client is reconnected successfully to network (Only main datacenter)
    
    self.eventNetworkReconnected = some(procedure)


proc onDisconnection*(self: UpdatesCallback, procedure: proc(): Future[void] {.async.}) =
    ## Call the specified procedure when client is disconnected from network (Only main datacenter)
    
    self.eventNetworkDisconnected = some(procedure)

proc onUpdateNewMessage*(self: UpdatesCallback, procedure: proc(updateNewMessage: UpdateNewMessage): Future[void] {.async.}) =
    ## Call the specified procedure when UpdateNewMessage is received
    
    self.eventUpdateNewMessage = some(procedure)


proc onUpdateNewChannelMessage*(self: UpdatesCallback, procedure: proc(updateNewChannelMessage: UpdateNewChannelMessage): Future[void] {.async.}) =
    ## Call the specified procedure when UpdateNewChannelMessage is received
    
    self.eventUpdateNewChannelMessage = some(procedure)

proc onUpdates*(self: UpdatesCallback, procedure: proc(updates: UpdatesI): Future[void] {.async.}) =
    ## Call the specified procedure when UpdatesI is received.
    ## You should use this if you want to handle low level updates
    self.callback = some(procedure)

