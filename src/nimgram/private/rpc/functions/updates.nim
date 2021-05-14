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

## This file was generated automatically by the TL Parser (built at 2021-04-14T08:10:40+02:00)
type
    UpdatesGetState* = ref object of TLFunction
    UpdatesGetDifference* = ref object of TLFunction
        flags: int32
        pts*: int32
        pts_total_limit*: Option[int32]
        date*: int32
        qts*: int32
    UpdatesGetChannelDifference* = ref object of TLFunction
        flags: int32
        force*: bool
        channel*: InputChannelI
        filter*: ChannelMessagesFilterI
        pts*: int32
        limit*: int32
method getTypeName*(self: UpdatesGetState): string = "UpdatesGetState"
method getTypeName*(self: UpdatesGetDifference): string = "UpdatesGetDifference"
method getTypeName*(self: UpdatesGetChannelDifference): string = "UpdatesGetChannelDifference"

method TLEncode*(self: UpdatesGetState): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xedd4882a))
method TLDecode*(self: UpdatesGetState, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: UpdatesGetDifference): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x25939651))
    if self.pts_total_limit.isSome():
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.pts)
    if self.pts_total_limit.isSome():
        result = result & TLEncode(self.pts_total_limit.get())
    result = result & TLEncode(self.date)
    result = result & TLEncode(self.qts)
method TLDecode*(self: UpdatesGetDifference, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    bytes.TLDecode(addr self.pts)
    if (self.flags and (1 shl 0)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.pts_total_limit = some(tempVal)
    bytes.TLDecode(addr self.date)
    bytes.TLDecode(addr self.qts)
method TLEncode*(self: UpdatesGetChannelDifference): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x3173d78))
    if self.force:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.filter)
    result = result & TLEncode(self.pts)
    result = result & TLEncode(self.limit)
method TLDecode*(self: UpdatesGetChannelDifference, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.force = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    tempObj.TLDecode(bytes)
    self.filter = cast[ChannelMessagesFilterI](tempObj)
    bytes.TLDecode(addr self.pts)
    bytes.TLDecode(addr self.limit)
