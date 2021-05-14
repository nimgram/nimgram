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
    UpdatesState* = ref object of UpdatesStateI
        pts*: int32
        qts*: int32
        date*: int32
        seq*: int32
        unread_count*: int32
    UpdatesDifferenceEmpty* = ref object of UpdatesDifferenceI
        date*: int32
        seq*: int32
    UpdatesDifference* = ref object of UpdatesDifferenceI
        new_messages*: seq[MessageI]
        new_encrypted_messages*: seq[EncryptedMessageI]
        other_updates*: seq[UpdateI]
        chats*: seq[ChatI]
        users*: seq[UserI]
        state*: UpdatesStateI
    UpdatesDifferenceSlice* = ref object of UpdatesDifferenceI
        new_messages*: seq[MessageI]
        new_encrypted_messages*: seq[EncryptedMessageI]
        other_updates*: seq[UpdateI]
        chats*: seq[ChatI]
        users*: seq[UserI]
        intermediate_state*: UpdatesStateI
    UpdatesDifferenceTooLong* = ref object of UpdatesDifferenceI
        pts*: int32
    UpdatesChannelDifferenceEmpty* = ref object of UpdatesChannelDifferenceI
        flags: int32
        final*: bool
        pts*: int32
        timeout*: Option[int32]
    UpdatesChannelDifferenceTooLong* = ref object of UpdatesChannelDifferenceI
        flags: int32
        final*: bool
        timeout*: Option[int32]
        dialog*: DialogI
        messages*: seq[MessageI]
        chats*: seq[ChatI]
        users*: seq[UserI]
    UpdatesChannelDifference* = ref object of UpdatesChannelDifferenceI
        flags: int32
        final*: bool
        pts*: int32
        timeout*: Option[int32]
        new_messages*: seq[MessageI]
        other_updates*: seq[UpdateI]
        chats*: seq[ChatI]
        users*: seq[UserI]
method getTypeName*(self: UpdatesState): string = "UpdatesState"
method getTypeName*(self: UpdatesDifferenceEmpty): string = "UpdatesDifferenceEmpty"
method getTypeName*(self: UpdatesDifference): string = "UpdatesDifference"
method getTypeName*(self: UpdatesDifferenceSlice): string = "UpdatesDifferenceSlice"
method getTypeName*(self: UpdatesDifferenceTooLong): string = "UpdatesDifferenceTooLong"
method getTypeName*(self: UpdatesChannelDifferenceEmpty): string = "UpdatesChannelDifferenceEmpty"
method getTypeName*(self: UpdatesChannelDifferenceTooLong): string = "UpdatesChannelDifferenceTooLong"
method getTypeName*(self: UpdatesChannelDifference): string = "UpdatesChannelDifference"

method TLEncode*(self: UpdatesState): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xa56c2a3e))
    result = result & TLEncode(self.pts)
    result = result & TLEncode(self.qts)
    result = result & TLEncode(self.date)
    result = result & TLEncode(self.seq)
    result = result & TLEncode(self.unread_count)
method TLDecode*(self: UpdatesState, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.pts)
    bytes.TLDecode(addr self.qts)
    bytes.TLDecode(addr self.date)
    bytes.TLDecode(addr self.seq)
    bytes.TLDecode(addr self.unread_count)
method TLEncode*(self: UpdatesDifferenceEmpty): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x5d75a138))
    result = result & TLEncode(self.date)
    result = result & TLEncode(self.seq)
method TLDecode*(self: UpdatesDifferenceEmpty, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.date)
    bytes.TLDecode(addr self.seq)
method TLEncode*(self: UpdatesDifference): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf49ca0))
    result = result & TLEncode(cast[seq[TL]](self.new_messages))
    result = result & TLEncode(cast[seq[TL]](self.new_encrypted_messages))
    result = result & TLEncode(cast[seq[TL]](self.other_updates))
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
    result = result & TLEncode(self.state)
method TLDecode*(self: UpdatesDifference, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.new_messages = cast[seq[MessageI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.new_encrypted_messages = cast[seq[EncryptedMessageI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.other_updates = cast[seq[UpdateI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.state = cast[UpdatesStateI](tempObj)
method TLEncode*(self: UpdatesDifferenceSlice): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xa8fb1981))
    result = result & TLEncode(cast[seq[TL]](self.new_messages))
    result = result & TLEncode(cast[seq[TL]](self.new_encrypted_messages))
    result = result & TLEncode(cast[seq[TL]](self.other_updates))
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
    result = result & TLEncode(self.intermediate_state)
method TLDecode*(self: UpdatesDifferenceSlice, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.new_messages = cast[seq[MessageI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.new_encrypted_messages = cast[seq[EncryptedMessageI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.other_updates = cast[seq[UpdateI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.intermediate_state = cast[UpdatesStateI](tempObj)
method TLEncode*(self: UpdatesDifferenceTooLong): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x4afe8f6d))
    result = result & TLEncode(self.pts)
method TLDecode*(self: UpdatesDifferenceTooLong, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.pts)
method TLEncode*(self: UpdatesChannelDifferenceEmpty): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x3e11affb))
    if self.final:
        self.flags = self.flags or 1 shl 0
    if self.timeout.isSome():
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.pts)
    if self.timeout.isSome():
        result = result & TLEncode(self.timeout.get())
method TLDecode*(self: UpdatesChannelDifferenceEmpty, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.final = true
    bytes.TLDecode(addr self.pts)
    if (self.flags and (1 shl 1)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.timeout = some(tempVal)
method TLEncode*(self: UpdatesChannelDifferenceTooLong): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xa4bcc6fe))
    if self.final:
        self.flags = self.flags or 1 shl 0
    if self.timeout.isSome():
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    if self.timeout.isSome():
        result = result & TLEncode(self.timeout.get())
    result = result & TLEncode(self.dialog)
    result = result & TLEncode(cast[seq[TL]](self.messages))
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: UpdatesChannelDifferenceTooLong, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.final = true
    if (self.flags and (1 shl 1)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.timeout = some(tempVal)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.dialog = cast[DialogI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.messages = cast[seq[MessageI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: UpdatesChannelDifference): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x2064674e))
    if self.final:
        self.flags = self.flags or 1 shl 0
    if self.timeout.isSome():
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.pts)
    if self.timeout.isSome():
        result = result & TLEncode(self.timeout.get())
    result = result & TLEncode(cast[seq[TL]](self.new_messages))
    result = result & TLEncode(cast[seq[TL]](self.other_updates))
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: UpdatesChannelDifference, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.final = true
    bytes.TLDecode(addr self.pts)
    if (self.flags and (1 shl 1)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.timeout = some(tempVal)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.new_messages = cast[seq[MessageI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.other_updates = cast[seq[UpdateI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
