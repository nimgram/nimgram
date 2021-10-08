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

type User* = ref object           ## A user
    client: NimgramClient         ## Nimgram instance, used for high level api calls
    self*: bool                   ## Whether this user indicates the currently logged in user
    contact*: bool                ## Whether this user is a contact
    mutualContact*: bool          ## Whether this user is a mutual contact
    deleted*: bool                ## Whether the account of this user was deleted
    bot*: bool                    ## Is this user a bot?
    botChatHistory*: bool         ## Can the bot see all messages in groups?
    botNoChats*: bool             ## Can the bot be added to groups?
    verified*: bool               ## Whether this user is verified
    restricted*: bool ## Access to this user must be restricted for the reason specified in restriction_reason
    min*: bool                    ## Min constructor
    botInlineGeo*: bool           ## Whether the bot can request our geolocation in inline mode
    support*: bool                ## Whether this is an official support user
    scam*: bool                   ## This may be a scam user
    applyMinPhoto*: bool ## If set, the profile picture for this user should be refetched
    fake*: bool                   ## This may be a fake user
    userID*: int64                ## ID of the user
    accessHash*: Option[int64]    ## Access hash of the user
    firstName*: string            ## First name
    lastName*: string             ## Last name
    username*: string             ## Username
    nextOfflineDate: Option[int32] ## Date when the user will be considered automatically offline
    lastOnlineDate: Option[int32] ## Date when the user was last seen
    phone*: Option[string]        ## Phone number
    photo*: Option[ChatPhoto]     ## Profile picture of user
    status*: UserStatus           ## Online status of user
    botInfoVersion*: Option[int32] ## Version of the bot_info field in userFull, incremented every time it changes
    restrictionReason*: Option[seq[RestrictionReason]] ## Contains the reason why access to this user must be restricted.
    botInlinePlaceholder*: Option[string] ## Inline placeholder for this inline bot
    langCode*: Option[string]     ## Language code of the user


proc parse*(user: raw.User, client: NimgramClient): User =
    result = new User

    if user.photo.isSome():
        result.photo = parse(user.photo.get()).some()

    if user.restriction_reason.isSome():
        var restrictionTemp: seq[RestrictionReason]
        for restrictions in user.restriction_reason.get():
            restrictionTemp.add(parse(restrictions))
        result.restrictionReason = some(restrictionTemp)

    if user.status.isSome():
        var status = user.status.get()
        if status of UserStatusOnline:
            result.status = Online
            result.nextOfflineDate = user.status.get().UserStatusOnline.expires.some()
        elif status of UserStatusOffline:
            result.status = Offline
            result.lastOnlineDate = user.status.get().UserStatusOffline.was_online.some()
        elif status of UserStatusRecently:
            result.status = Recently
        elif status of UserStatusLastWeek:
            result.status = WithinWeek
        elif status of UserStatusLastMonth:
            result.status = WithinMonth
        else:
            result.status = LongTimeAgo

    if user.bot:
        result.status = None
    if user.first_name.isSome():
        result.firstName = user.first_name.get()
    if user.last_name.isSome():
        result.lastName = user.last_name.get()
    if user.username.isSome():
        result.username = user.username.get()

    result.client = client
    result.self = user.self
    result.contact = user.contact
    result.mutualContact = user.mutual_contact
    result.deleted = user.deleted
    result.bot = user.bot
    result.botChatHistory = user.bot_chat_history
    result.botNoChats = user.bot_nochats
    result.verified = user.verified
    result.restricted = user.restricted
    result.min = user.min
    result.botInlineGeo = user.bot_inline_geo
    result.support = user.support
    result.scam = user.scam
    result.applyMinPhoto = user.apply_min_photo
    result.fake = user.fake
    result.userID = user.id
    result.accessHash = user.accessHash
    result.phone = user.phone
