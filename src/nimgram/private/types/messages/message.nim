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


type Message* = ref object                 ## A message
    empty*: bool                           ## Whether this is a empty message
    edited*: bool                          ## Whether this is a edited message
    deleted*: bool                          ## Wheter this is a deleted message
    service*: bool                         ## Whether this is a service message
    action*: Option[MessageActionI] ## For service messages, the event connected with the service message

    client: NimgramClient                  ## Nimgram instance, used for high level api calls
    outgoing*: bool                        ## Is this an outgoing message
    mentioned*: bool                       ## Whether we were mentioned in this message

    fromScheduled*: bool                   ## Whether this is a scheduled message

    legacy*: bool ## This is a legacy message: it has to be refetched with the new layer
    hideEdit*: bool ## Whether the message should be shown as not modified to the user, even if an edit date is present
    pinned*: bool                          ## Whether this message is pinned
    post*: bool                            ## Whether this is a channel post
    mediaUnread*: bool ## Whether there are unread media attachments in this message
    silent*: bool ## Whether this is a silent message (no notification triggered)
    messageID*: int32                      ## ID of the message

    # TODO: fromUser
    fromID*: Option[int64]                 ## ID of the sender of the message
    peer*: Peer                            ## Peer ID, the chat where this message was sent

    chatID*: int64

    forwardFromID*: Option[int64] ## For forwarded messages, Sender of the original message
    forwardFromName*: Option[string] ## For forwarded messages, Name of the sender that sended the original message
    forwardMessageID*: Option[int32] ## For forwarded messages, ID of the original message if forwarded from a channel
    forwardSignature*: Option[string] ## For forwarded messages, Signature of the post author if forwarded from a channel
    forwardDate*: Option[int32] ## For forwarded messages, Date when the forwarded message was originally sent
    forwardSavedMessageID*: Option[int32] ## For forwarded messages sent to saved messages, the original message id where it was sent
    forwardSavedFromID*: Option[int64] ## For forwarded messages sent to saved messages, the original chat where it was sent

    viaBotID*: Option[int32]               ## ID of the inline bot that generated the message

    # TODO: Directly get message info instead of giving just the id
    replyToMessageID*: Option[int32]       ## ID of message to which this message is replying
    replyToPeerID*: Option[int64] ## For replies sent in channel discussion threads of which the current user is not a member, the discussion group ID
    replyTopMessageID*: Option[int32]      ## ID of the message that started the message thread
    date*: int32                           ## Date of the message
    text*: string                          ## Text/caption of the message, empty if not used

    # TODO: `photo`, `document`, `video`, etc...
    # and media: Option[string]
    media*: Option[Media] ## Whether the message has an attached media (and what kind of media as string)
    replyMarkup*: Option[KeyboardMarkup] ## Reply markup (bot/inline keyboards)
    entities*: Option[seq[MessageEntityI]] ## Message entities for styled text
    views*: Option[int32] ## View count for channel posts
    forwards*: Option[int32] ## Forward counter
    replies*: Option[MessageRepliesI] ## Info about post comments (for channels) or message replies (for groups)
    editDate*: Option[int32] ## Last edit date of this message
    postAuthor*: Option[string] ## Name of the author of this message for channel posts (with signatures enabled)
    groupedID*: Option[int64] ## Multiple media messages sent with the same grouped ID indicate an album or media group
    restrictionReason*: Option[seq[RestrictionReason]] ## Contains the reason why access to this message must be restricted.
    ttlPeriod*: Option[int32]

    # TODO: webpage: Option[Webpage]


proc parse*(message: raw.Message, client: NimgramClient, edited: bool = false, deleted: bool = false): Message =
    result = new Message
    if edited:
        result.edited = true
    if deleted:
        result.deleted = true
    if message.fwd_from.isSome():
        var fwdfrom = message.fwd_from.get().MessageFwdHeader
        result.forwardDate = some(fwdfrom.date)
        if fwdfrom.post_author.isSome():
            result.forwardSignature = some(fwdfrom.post_author.get())
        if fwdfrom.channel_post.isSome():
            result.forwardMessageID = some(fwdfrom.channel_post.get())
        if fwdfrom.from_name.isSome():
            result.forwardFromName = some(fwdfrom.from_name.get())
        if fwdfrom.saved_from_msg_id.isSome():
            result.forwardSavedMessageID = some(fwdfrom.saved_from_msg_id.get())
        if fwdfrom.saved_from_peer.isSome():
            var peer = fwdfrom.saved_from_peer.get()
            result.forwardSavedFromID = some(getCorrectID(peer))

        if fwdfrom.from_id.isSome():
            var peer = fwdfrom.from_id.get()
            result.forwardFromID = some(getCorrectID(peer))

    if message.reply_to.isSome():
        let replyHeader = message.reply_to.get().MessageReplyHeader
        result.replyToMessageID = some(replyHeader.reply_to_msg_id)
        result.replyTopMessageID = replyHeader.reply_to_top_id
        if replyHeader.reply_to_peer_id.isSome():
            result.replyToPeerID = some(getCorrectID(
                    replyHeader.reply_to_peer_id.get()))


    if message.media.isSome():
        if message.media.get() of MessageMediaPhoto:
            result.media = cast[Option[Media]](message.media.get().MessageMediaPhoto.parse())
        if message.media.get() of MessageMediaGeo:
            result.media = cast[Option[Media]](some(message.media.get().MessageMediaGeo.parse()))
        if message.media.get() of MessageMediaContact:
            result.media = cast[Option[Media]](some(message.media.get().MessageMediaContact.parse()))
        if message.media.get() of MessageMediaUnsupported:
            result.media = cast[Option[Media]](UnsupportedMessage().some())
        if message.media.get() of MessageMediaDocument:
            result.media = cast[Option[Media]](message.media.get().MessageMediaDocument.parse())
        if message.media.get() of MessageMediaWebPage:
            result.media = cast[Option[Media]](message.media.get().MessageMediaWebPage.webpage.parse())
        if message.media.get() of MessageMediaVenue:
            result.media = cast[Option[Media]](some(message.media.get().MessageMediaVenue.parse()))
        if message.media.get() of MessageMediaGame:
            result.media = cast[Option[Media]](some(cast[raw.Game](
                    message.media.get().MessageMediaGame.game).parse()))
        if message.media.get() of MessageMediaInvoice:
            result.media = cast[Option[Media]](UnsupportedMessage().some())
        if message.media.get() of MessageMediaPoll:
            result.media = cast[Option[Media]](UnsupportedMessage().some())
        if message.media.get() of MessageMediaDice:
            result.media = cast[Option[Media]](some(message.media.get().MessageMediaDice.parse()))


    if message.restriction_reason.isSome():
        var restrictionTemp: seq[RestrictionReason]
        for restrictions in message.restriction_reason.get():
            restrictionTemp.add(parse(restrictions))
        result.restrictionReason = some(restrictionTemp)

    result.chatID = getCorrectID(message.peer_id)

    if message.from_id.isSome():
        result.fromID = some(getCorrectID(message.from_id.get()))

    result.client = client
    result.outgoing = message.isout
    result.mentioned = message.mentioned
    result.mediaUnread = message.media_unread
    result.silent = message.silent
    result.post = message.post
    result.fromScheduled = message.from_scheduled
    result.legacy = message.legacy
    result.hideEdit = message.edit_hide
    result.pinned = message.pinned
    result.messageID = message.id
    result.peer = parse(message.peer_id)
    result.viaBotID = message.via_bot_id
    result.date = message.date
    result.text = message.message
    if message.reply_markup.isSome():
        result.replyMarkup = some(parse(message.reply_markup.get(), client))
    result.entities = message.entities
    result.views = message.views
    result.forwards = message.forwards
    result.replies = message.replies
    result.editDate = message.edit_date
    result.postAuthor = message.post_author
    result.groupedID = message.grouped_id
    result.ttlPeriod = message.ttl_period

proc parse*(message: raw.MessageI, client: NimgramClient, edited: bool = false, deleted: bool = false): Message =
    if message of raw.Message:
        return parse(cast[raw.Message](message), client, edited, deleted)
    elif message of raw.MessageEmpty:
        let messageEmpty = cast[raw.MessageEmpty](message)
        var chatID = int64(0)
        if messageEmpty.peer_id.isSome():
            chatID = getCorrectID(messageEmpty.peer_id.get())
        return Message(
            empty: true,
            edited: if edited: true else: false,
            deleted: if deleted: true else: false,
            chatID: chatID,
            messageID: messageEmpty.id
        )
    elif message of raw.MessageService:
        let messageService = cast[raw.MessageService](message)
        result = new Message
        result.service = true
        if edited: 
            result.edited = true
        if deleted:
            result.deleted = true
        result.outgoing = messageService.isout
        result.mentioned = messageService.mentioned
        result.mediaUnread = messageService.media_unread
        result.silent = messageService.silent
        result.post = messageService.post
        result.legacy = messageService.legacy
        result.messageID = messageService.id
        if messageService.from_id.isSome():
            result.fromID = some(getCorrectID(messageService.from_id.get()))
        result.chatID = getCorrectID(messageService.peer_id)
        result.peer = parse(messageService.peer_id)
        if messageService.reply_to.isSome():
            let replyHeader = messageService.reply_to.get().MessageReplyHeader
            result.replyToMessageID = some(replyHeader.reply_to_msg_id)
            result.replyTopMessageID = replyHeader.reply_to_top_id
            if replyHeader.reply_to_peer_id.isSome():
                result.replyToPeerID = some(getCorrectID(
                        replyHeader.reply_to_peer_id.get()))
        result.date = messageService.date
        result.action = some(messageService.action)
        result.ttlPeriod = messageService.ttl_period

    else:
        client.logger.log(lvlWarn, &"Unable to resolve type real type of raw.MessageI")
