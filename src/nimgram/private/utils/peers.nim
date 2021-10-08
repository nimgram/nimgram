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

proc resolveInputPeer*(self: NimgramClient, id: int64): Future[InputPeerI] {.async.} =
    ## Get a InputPeer object by resolving access hash on local database

    # chat
    if id < 0 and id notin CHANNEL_RANGE:
        return InputPeerChat(chat_id: int32(id))
    var userpeer = await self.storageManager.getPeer(id)
    # channel
    if id in CHANNEL_RANGE:
        return InputPeerChannel(channel_id: int32(revertChannelId(id)), access_hash: userpeer.accessHash)
    # user
    return InputPeerUser(user_id: int32(id), access_hash: userpeer.accessHash)



proc resolveInputPeer*(self: NimgramClient, peer: PeerI): Future[InputPeerI] {.async.} =
    ## Get a InputPeer object by resolving access hash on local database

    # chat
    if peer of PeerChat:
        return InputPeerChat(chat_id: peer.PeerChat.chat_id)
    # channel
    if peer of PeerChannel:
        var channelpeer = await self.storageManager.getPeer(getChannelId(peer.PeerChannel.channel_id))
        return InputPeerChannel(channel_id: peer.PeerChannel.channel_id, access_hash: channelpeer.accessHash)
    # user
    if peer of PeerUser:
        var userpeer = await self.storageManager.getPeer(peer.PeerUser.user_id)
        return InputPeerUser(user_id: peer.PeerUser.user_id, access_hash: userpeer.accessHash)

