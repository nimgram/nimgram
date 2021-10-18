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

proc sendDocument(self: NimgramClient, peer: int64, inputFile: InputFile,
        caption: string = "",
    replyToMessageID: int32 = 0, replyMarkup: KeyboardMarkup = nil,
            disableWebPage: bool = false, silent: bool = false,
            background: bool = false, clearDraft: bool = false,
            ttl: int32 = 0): Future[Message] {.async.} =
    ## Send a document with a already uploaded file (InputFile, should only be used internally)
    let rawInput = if inputFile of InputFileSmall: parse(
            inputFile.InputFileSmall) else: parse(inputFile)


    var markup: Option[ReplyMarkupI]
    if replyMarkup != nil: markup = some(replyMarkup.parse())

    randomize()
    let tmpResult = await self.send(MessagesSendMedia(
      silent: silent,
      background: background,
      clear_draft: clearDraft,
      media: InputMediaUploadedDocument(
          file: rawInput,
          mime_type: newMimetypes().getMimetype(splitFile(inputFile.name).ext),
          force_file: true,
          attributes: @[DocumentAttributeFilename(
              file_name: inputFile.name
        ).DocumentAttributeI],
        ttl_seconds: if ttl != 0: some(ttl) else: none(int32)
      ),
        reply_to_msg_id: if replyToMessageID != 0: some(
                replyToMessageID) else: none(int32),
        peer: await self.resolveInputPeer(peer),
        message: caption,
        random_id: int64(rand(2147483646)),
        reply_markup: markup
    ))
    if tmpResult of Updates:
        let updates = tmpResult.Updates
        for update in updates.updates:
            if update of UpdateNewMessage:
                return update.UpdateNewMessage.message.parse(self)
            if update of UpdateNewChannelMessage:
                return update.UpdateNewChannelMessage.message.parse(self)
            if update of UpdateNewScheduledMessage:
                return update.UpdateNewScheduledMessage.message.parse(self)

proc sendDocument*(self: NimgramClient, peer: int64, document: Document,
        caption: string = "",
    replyToMessageID: int32 = 0, replyMarkup: KeyboardMarkup = nil,
            disableWebPage: bool = false, silent: bool = false,
            background: bool = false, clearDraft: bool = false,
            ttl: int32 = 0): Future[Message] {.async.} =
    ## Send a document with a already uploaded file (InputFile, should only be used internally)

    var markup: Option[ReplyMarkupI]
    if replyMarkup != nil: markup = some(replyMarkup.parse())

    randomize()
    let tmpResult = await self.send(MessagesSendMedia(
      silent: silent,
      background: background,
      clear_draft: clearDraft,
      media: InputMediaDocument(
          id: InputDocument(id: document.ID, access_hash: document.accessHash,
                  file_reference: document.fileReference),
          ttl_seconds: if ttl != 0: some(ttl) else: none(int32)
      ),
      reply_to_msg_id: if replyToMessageID != 0: some(
              replyToMessageID) else: none(int32),
      peer: await self.resolveInputPeer(peer),
      message: caption,
      random_id: int64(rand(2147483646)),
      reply_markup: markup
    ))
    if tmpResult of Updates:
        let updates = tmpResult.Updates
        for update in updates.updates:
            if update of UpdateNewMessage:
                return update.UpdateNewMessage.message.parse(self)
            if update of UpdateNewChannelMessage:
                return update.UpdateNewChannelMessage.message.parse(self)
            if update of UpdateNewScheduledMessage:
                return update.UpdateNewScheduledMessage.message.parse(self)

proc sendDocument*(self: NimgramClient, peer: int64, fileLocation: string,
        caption: string = "",
    replyToMessageID: int32 = 0, replyMarkup: KeyboardMarkup = nil): Future[
            Message] {.async.} =
    ## Send a document with a local file

    let inputFile = await self.uploadInternalFile(fileLocation)
    return await self.sendDocument(peer, inputFile, caption, replyToMessageID, replyMarkup)


