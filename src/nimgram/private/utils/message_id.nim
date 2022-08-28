# Nimgram
# Copyright (C) 2020-2022 Daniele Cortesi <https://github.com/dadadani>
# This file is part of Nimgram, under the MIT License
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import std/math, std/times
import std/logging, std/monotimes

type MessageID* = ref object
    serverTime: int64
    referenceMonotime: float64
    lastTime: int64
    timeOffset: int64

proc createMessageID*(): MessageID = 
    return MessageID(serverTime: 2, referenceMonotime: 0, lastTime: 0, timeOffset: 0)

proc updateTime*(self: MessageID, serverTime: int64, force = false) =
        if self.serverTime == 2 or force:
            self.referenceMonotime = float64(ticks(getMonoTime())) / float64(1000000000)
            self.serverTime = serverTime
            debug("[MESSAGEID SYNC] Time has been updated to ", fromUnix(serverTime))

proc getUnix*(self: MessageID): int64 = 
    return int64((float64(ticks(getMonoTime())) / float64(1000000000)) - self.referenceMonotime + float64(self.serverTime))

proc get*(self: MessageID): int64 = 
    let currentTime = self.getUnix()
    self.timeOffset = self.timeOffset + (if int64(currentTime) == self.lastTime: 4 else: 0)
    result = int64(currentTime) * 2 ^ 32 + self.timeOffset
    self.lastTime = int64(currentTime)