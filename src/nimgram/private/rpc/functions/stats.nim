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
    StatsGetBroadcastStats* = ref object of TLFunction
        flags: int32
        dark*: bool
        channel*: InputChannelI
    StatsLoadAsyncGraph* = ref object of TLFunction
        flags: int32
        token*: string
        x*: Option[int64]
    StatsGetMegagroupStats* = ref object of TLFunction
        flags: int32
        dark*: bool
        channel*: InputChannelI
    StatsGetMessagePublicForwards* = ref object of TLFunction
        channel*: InputChannelI
        msg_id*: int32
        offset_rate*: int32
        offset_peer*: InputPeerI
        offset_id*: int32
        limit*: int32
    StatsGetMessageStats* = ref object of TLFunction
        flags: int32
        dark*: bool
        channel*: InputChannelI
        msg_id*: int32
method getTypeName*(self: StatsGetBroadcastStats): string = "StatsGetBroadcastStats"
method getTypeName*(self: StatsLoadAsyncGraph): string = "StatsLoadAsyncGraph"
method getTypeName*(self: StatsGetMegagroupStats): string = "StatsGetMegagroupStats"
method getTypeName*(self: StatsGetMessagePublicForwards): string = "StatsGetMessagePublicForwards"
method getTypeName*(self: StatsGetMessageStats): string = "StatsGetMessageStats"

method TLEncode*(self: StatsGetBroadcastStats): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xab42441a))
    if self.dark:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.channel)
method TLDecode*(self: StatsGetBroadcastStats, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.dark = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
method TLEncode*(self: StatsLoadAsyncGraph): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x621d5fa0))
    if self.x.isSome():
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.token)
    if self.x.isSome():
        result = result & TLEncode(self.x.get())
method TLDecode*(self: StatsLoadAsyncGraph, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    self.token = cast[string](bytes.TLDecode())
    if (self.flags and (1 shl 0)) != 0:
        var tempVal: int64 = 0
        bytes.TLDecode(addr tempVal)
        self.x = some(tempVal)
method TLEncode*(self: StatsGetMegagroupStats): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xdcdf8607))
    if self.dark:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.channel)
method TLDecode*(self: StatsGetMegagroupStats, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.dark = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
method TLEncode*(self: StatsGetMessagePublicForwards): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x5630281b))
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.msg_id)
    result = result & TLEncode(self.offset_rate)
    result = result & TLEncode(self.offset_peer)
    result = result & TLEncode(self.offset_id)
    result = result & TLEncode(self.limit)
method TLDecode*(self: StatsGetMessagePublicForwards, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    bytes.TLDecode(addr self.msg_id)
    bytes.TLDecode(addr self.offset_rate)
    tempObj.TLDecode(bytes)
    self.offset_peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.offset_id)
    bytes.TLDecode(addr self.limit)
method TLEncode*(self: StatsGetMessageStats): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb6e0a3f5))
    if self.dark:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.channel)
    result = result & TLEncode(self.msg_id)
method TLDecode*(self: StatsGetMessageStats, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.dark = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.channel = cast[InputChannelI](tempObj)
    bytes.TLDecode(addr self.msg_id)
