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




type ChatPhoto* = ref object ## Photo of a user/bot/chat/channel/supergroup
    hasVideo*: bool ## Whether an animated profile picture is available for this user
    photoID*: int64 ## Identifier of the respective photo
    dcID*: int32 ## DC ID where the photo is stored
    photoBig*: FileLocation ## Location of the profile picture in big resolution
    photoSmall*: FileLocation ## Location of the profile picture in small resolution

proc parse(profilePhoto: raw.UserProfilePhotoI): ChatPhoto =
    result = new ChatPhoto
    result.photoBig = parse(profilePhoto.UserProfilePhoto.photo_big)
    result.photoSmall = parse(profilePhoto.UserProfilePhoto.photo_small)

    result.dcID = profilePhoto.UserProfilePhoto.dc_id
    result.hasVideo = profilePhoto.UserProfilePhoto.has_video
    result.photoID = profilePhoto.UserProfilePhoto.photo_id