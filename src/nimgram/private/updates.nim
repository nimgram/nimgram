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
 
#seq[proc(message: Message): Future[void] {.async.}]

type NewMessageHandler* = ref object of FunctionHandler
    message: seq[proc(message: Message): Future[void] {.async.}]

proc newUpdateHandler(): UpdateHandler =
    return UpdateHandler(
        onMessageHandlers: NewMessageHandler(message: newSeq[proc(
                message: Message): Future[void] {.async.}]())
    )

proc saveData(storage: NimgramStorage, users: seq[UserI], chats: seq[ChatI]) {.async.} =
    for userGeneric in users:
        if userGeneric of raw.User:
            let user = cast[raw.User](userGeneric)
            if user.access_hash.isSome():
                await storage.addPeer(StoragePeer(peerID: user.id,
                        accessHash: user.access_hash.get()))
    for chatGeneric in chats:
        if chatGeneric of raw.Channel:
            let channel = cast[raw.Channel](chatGeneric)
            if channel.access_hash.isSome():
                await storage.addPeer(
                    StoragePeer(
                        peerID: getChannelId(channel.id),
                        accessHash: channel.access_hash.get()
                    )
                )

proc addOnMessageHandler*(client: NimgramClient, event: proc(
        message: Message): Future[void] {.async.}) =
    var handler = client.updateHandler.onMessageHandlers.NewMessageHandler
    handler.message.add(event)
    client.updateHandler.onMessageHandlers = handler

proc sendUpdate(self: UpdateHandler, client: NimgramClient,
        gupdate: raw.UpdatesI) {.async.} =
    if gupdate of raw.Updates:
        let updates = cast[raw.Updates](gupdate)
        await saveData(client.storageManager, updates.users, updates.chats)
        for update in updates.updates:
            if update of UpdateEditChannelMessage:
                let message = parse(update.UpdateEditChannelMessage.message, client, true)
                for messageHandler in self.onMessageHandlers.NewMessageHandler.message:
                    asyncCheck messageHandler(message) 
            if update of UpdateEditMessage:
                let message = parse(update.UpdateEditMessage.message, client, true)
                for messageHandler in self.onMessageHandlers.NewMessageHandler.message:
                    asyncCheck messageHandler(message) 
            if update of UpdateNewChannelMessage:
                let message = parse(update.UpdateNewChannelMessage.message, client)
                for messageHandler in self.onMessageHandlers.NewMessageHandler.message:
                    asyncCheck messageHandler(message)
            if update of UpdateNewMessage:
                let message = parse(update.UpdateNewMessage.message, client)
                for messageHandler in self.onMessageHandlers.NewMessageHandler.message:
                    asyncCheck messageHandler(message)


proc startHandler(self: NimgramClient) {.async.} =
    ## Initialize update handling

    # Currently the fastest way to get updates working is by sending get state
    discard await self.sessions[self.mainDc].send(UpdatesGetState(), true)
