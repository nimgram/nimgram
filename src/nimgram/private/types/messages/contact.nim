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


type Contact* = ref object of Media 
    number*: string ## Phone number
    firstName*: string ## Contact's first name 
    lastName*: string ## Contact's last name
    vcard*: string ## vcard of the contact
    ID*: int32 ## ID of the contact (0 if not registered on Telegram)


proc parse*(contact: raw.MessageMediaContact): Contact =
    return Contact(
        number: contact.phone_number,
        firstName: contact.first_name,
        lastName: contact.last_name,
        vcard: contact.vcard,
        ID: contact.user_id
    )