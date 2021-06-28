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

proc sendMessage*(self: NimgramClient, peer: int64, text: string, replyMarkup: KeyboardMarkup = nil): Future[
        Message] {.async.} =

    var markup: Option[ReplyMarkupI] 
    if replyMarkup != nil: markup = some(replyMarkup.parse()) 

    var peert = await self.resolveInputPeer(peer)

    let tmpResult = await self.send(MessagesSendMessage(
      no_webpage: true,
      silent: false,
      background: false,
      clear_draft: false,
      peer: peert,
      message: text,
      random_id: int64(rand(2147483646)),
      reply_markup: markup
    ))

    if tmpResult of UpdateShortSentMessage:
        let sentMessage = tmpResult.UpdateShortSentMessage

        var userpeer = await self.storageManager.getPeer(peer)

        return Message(
          client: self,
          messageID: sentMessage.id,
          peer: Peer(
                id: int32(userpeer.peerID),
                type: TypeUser
            ),
            text: text,
            date: sentMessage.date,
            outgoing: sentMessage.isout,
            entities: sentMessage.entities
        )
    if tmpResult of Updates:
        let updates = tmpResult.Updates
        for update in updates.updates:
            if update of UpdateNewMessage:
                return update.UpdateNewMessage.message.parse(self)
            if update of UpdateNewChannelMessage:
                return update.UpdateNewChannelMessage.message.parse(self)
            if update of UpdateNewScheduledMessage:
                return update.UpdateNewScheduledMessage.message.parse(self)
