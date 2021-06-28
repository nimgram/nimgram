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


type UserStatus* = enum ## User's Last Seen & Online status
    None, ## No status available, usually for bots
    Online, ## User is online right now
    Offline, ## User is currently offline
    Recently, ## user with hidden last seen time who was online between 1 second and 2-3 days ago.
    WithinWeek, ## user with hidden last seen time who was online between 2-3 and seven days ago.
    WithinMonth, ## user with hidden last seen time who was online between 6-7 days and a month ago.
    LongTimeAgo ## blocked user or user with hidden last seen time who was online more than a month ago.


type UnsupportedMessage* = ref object of Media ## Current version of the client does not support this media type.

type RestrictionReason* = ref object ## Contains the reason why access to a certain object must be restricted. Clients are supposed to deny access to the channel if the platform field is equal to all or to the current platform (ios, android, wp, etc.). Platforms can be concatenated (ios-android, ios-wp), unknown platforms are to be ignored. The text is the error message that should be shown to the user.
    
    platform*: string ## Platform identifier (ios, android, wp, all, etc.), can be concatenated with a dash as separator (android-ios, ios-wp, etc)
    reason*: string ## Restriction reason (porno, terms, etc.)
    text*: string ## Error message to be shown to the user

proc parse*(restriction: raw.RestrictionReasonI): RestrictionReason =
    var restrictionReal = cast[raw.RestrictionReason](restriction)
    return RestrictionReason(
        platform: restrictionReal.platform,
        reason: restrictionReal.reason,
        text: restrictionReal.text
    )
