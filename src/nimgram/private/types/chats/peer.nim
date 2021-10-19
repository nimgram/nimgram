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

type PeerType* = enum
    TypeUser,
    TypeChannel,
    TypeChat

type Peer* = ref object
    id*: int64
    `type`*: PeerType

proc parse*(peer: raw.PeerI): Peer =
    result = new Peer
    if peer of PeerUser:
        return Peer(
            id: peer.PeerUser.user_id,
            `type`: TypeUser
        )
    if peer of PeerChat:
        return Peer(
            id: peer.PeerChat.chat_id,
            `type`: TypeChat
        )
    if peer of PeerChannel:
        return Peer(
            id: peer.PeerChannel.channel_id,
            `type`: TypeChannel
        )
