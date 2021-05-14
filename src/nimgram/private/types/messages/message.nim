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
import locks
import options
type Message* = ref object ## A message 
    client: NimgramClient ## Nimgram instance, used for high level api calls
    outgoing*: bool ## Is this an outgoing message
    mentioned*: bool ## Whether we were mentioned in this message
    mediaUnread*: bool ## Whether there are unread media attachments in this message
    silent*: bool ## Whether this is a silent message (no notification triggered)
    post*: bool ## Whether this is a channel post
    fromScheduled*: bool ## Whether this is a scheduled message
    legacy*: bool ## This is a legacy message: it has to be refetched with the new layer
    hideEdit*: bool ## Whether the message should be shown as not modified to the user, even if an edit date is present
    pinned*: bool ## Whether this message is pinned
    messageID*: int32 ## ID of the message
    `from`*: Option[int32] ## ID of the sender of the message
    peer*: Peer ## Peer ID, the chat where this message was sent
    chatID*: int64
    # TODO: Directly get user info instead of giving just the id
    forwardFromID*: Option[int64] ## For forwarded messages, Sender of the original message 
    forwardFromName*: Option[string] ## For forwarded messages, Name of the sender that sended the original message
    forwardMessageID*: Option[int32] ## For forwarded messages, ID of the original message if forwarded from a channel
    forwardSignature*: Option[string] ## For forwarded messages, Signature of the post author if forwarded from a channel
    forwardDate*: Option[int32] ## For forwarded messages, Date when the forwarded message was originally sent
    forwardSavedMessageID*: Option[int32] ## For forwarded messages sent to saved messages, the original message id where it was sent
    forwardSavedFromID*: Option[int64] ## For forwarded messages sent to saved messages, the original chat where it was sent
    viaBotID*: Option[int32] ## ID of the inline bot that generated the message
    ## TODO: Directly get message info instead of giving just the id
    replyToMessageID: Option[int32] ## ID of message to which this message is replying
    replyToPeerID: Option[int64] ## For replies sent in channel discussion threads of which the current user is not a member, the discussion group ID
    replyTopMessageID: Option[int32] ## ID of the message that started the message thread
    date*: int32 ## Date of the message
    text*: string ## Text of the message
    media*: Option[Media] ## Media attachment
    replyMarkup*: Option[ReplyMarkupI] ## Reply markup (bot/inline keyboards)
    entities*: Option[seq[MessageEntityI]] ## Message entities for styled text
    views*: Option[int32] ## View count for channel posts
    forwards*: Option[int32] ## Forward counter
    replies*: Option[MessageRepliesI] ## Info about post comments (for channels) or message replies (for groups)
    editDate*: Option[int32] ## Last edit date of this message
    postAuthor*: Option[string] ## Name of the author of this message for channel posts (with signatures enabled)
    groupedID*: Option[int64] ## Multiple media messages sent with the same grouped ID indicate an album or media group
    restrictionReason*: Option[seq[RestrictionReason]] ## Contains the reason why access to this message must be restricted.
    ttlPeriod*: Option[int32]

proc parse*(message: raw.Message, client: NimgramClient): Message = 
    result = new Message
    
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
            if peer of PeerUser:
                result.forwardSavedFromID = some(peer.PeerUser.user_id.int64)
            if peer of PeerChat:
                result.forwardSavedFromID = some(parseBiggestInt("-" & $peer.PeerChat.chat_id))
            if peer of PeerChannel:
                result.forwardSavedFromID = some(parseBiggestInt("-100" & $peer.PeerChannel.channel_id))
        if fwdfrom.from_id.isSome():
            var peer = fwdfrom.from_id.get()
            if peer of PeerUser:
                result.forwardFromID = some(peer.PeerUser.user_id.int64)
            if peer of PeerChat:
                result.forwardFromID = some(parseBiggestInt("-" & $peer.PeerChat.chat_id))
            if peer of PeerChannel:
                result.forwardFromID = some(parseBiggestInt("-100" & $peer.PeerChannel.channel_id))
    if message.media.isSome():
        if message.media.get() of MessageMediaPhoto:
            result.media = cast[Option[Media]](message.media.get().MessageMediaPhoto.parse())
        if message.media.get() of MessageMediaGeo:
            result.media = cast[Option[Media]](message.media.get().MessageMediaGeo.parse())

    if message.restriction_reason.isSome():
        var restrictionTemp: seq[RestrictionReason]
        for restrictions in message.restriction_reason.get():
            restrictionTemp.add(parse(restrictions))
        result.restrictionReason = some(restrictionTemp)

    case message.peer_id.getTypeName()
    of "PeerUser":
        result.chatID = message.peer_id.PeerUser.user_id.int64
    of "PeerChat":
        result.chatID = parseBiggestInt("-" & $message.peer_id.PeerChat.chat_id)
    of "PeerChannel":
        result.chatID = parseBiggestInt("-100" & $message.peer_id.PeerChannel.channel_id)

    if message.from_id.isSome():
        var fromIDRaw = message.from_id.get()
        if fromIDRaw of PeerUser:
            result.from = fromIDRaw.PeerUser.user_id.some()
        if fromIDRaw of PeerChat:
            result.from = fromIDRaw.PeerChat.chat_id.some()
        if fromIDRaw of PeerChannel:
            result.from = fromIDRaw.PeerChannel.channel_id.some()
   
    result.client = client
    result.outgoing = message.isout
    result.mentioned = message.mentioned
    result.media_unread = message.media_unread
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
    result.replyMarkup = message.reply_markup
    result.entities = message.entities
    result.views = message.views
    result.forwards = message.forwards
    result.replies = message.replies
    result.editDate = message.edit_date
    result.postAuthor = message.post_author
    result.groupedID = message.grouped_id
    result.ttlPeriod = message.ttl_period
    
