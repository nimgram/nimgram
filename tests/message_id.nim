# Nimgram
# Copyright (C) 2020-2023 Daniele Cortesi <https://github.com/dadadani>
# This file is part of Nimgram, under the MIT License
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import ../src/nimgram/private/utils/message_id
import std/math
import std/os

echo "Checking message_id syncing..."

let msgID = createMessageID()

msgID.updateTime(1657894301)
doAssert msgID.get() div (2 ^ 32) == 1657894301, "Expecting extracted time to be 1657894301"
sleep(1000)
doAssert msgID.get() div (2 ^ 32) == 1657894302, "Expecting extracted time to be 1657894302"
sleep(1000)
doAssert msgID.get() div (2 ^ 32) == 1657894303, "Expecting extracted time to be 1657894303"
sleep(3000)
doAssert msgID.get() div (2 ^ 32) == 1657894306, "Expecting extracted time to be 1657894306"

echo "message_id syncing PASSED"
