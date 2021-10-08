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




type
    Dice* = ref object of Media
        value: int32     ## Dice value
        emoticon: string ## The emoji
        slot: Option[SlotMachine]

    Reel* = enum
        bar
        berries
        lemon
        seven

    SlotMachine* = object
        left*: Reel
        center*: Reel
        right*: Reel

proc getSlot(value: 1..64): SlotMachine =
    let v = value - 1
    let leftReel = v and 3
    let centerReel = v shr 2 and 3
    let rightReel = v shr 4
    result.left = Reel(leftReel)
    result.center = Reel(centerReel)
    result.right = Reel(rightReel)

proc parse*(dice: raw.MessageMediaDice): Dice =
    result = new Dice

    result.value = dice.value
    result.emoticon = dice.emoticon

    if dice.emoticon == "🎰":
        result.slot = some(getSlot(value = dice.value))
