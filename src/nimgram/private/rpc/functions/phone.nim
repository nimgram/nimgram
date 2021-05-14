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
    PhoneGetCallConfig* = ref object of TLFunction
    PhoneRequestCall* = ref object of TLFunction
        flags: int32
        video*: bool
        user_id*: InputUserI
        random_id*: int32
        g_a_hash*: seq[uint8]
        protocol*: PhoneCallProtocolI
    PhoneAcceptCall* = ref object of TLFunction
        peer*: InputPhoneCallI
        g_b*: seq[uint8]
        protocol*: PhoneCallProtocolI
    PhoneConfirmCall* = ref object of TLFunction
        peer*: InputPhoneCallI
        g_a*: seq[uint8]
        key_fingerprint*: int64
        protocol*: PhoneCallProtocolI
    PhoneReceivedCall* = ref object of TLFunction
        peer*: InputPhoneCallI
    PhoneDiscardCall* = ref object of TLFunction
        flags: int32
        video*: bool
        peer*: InputPhoneCallI
        duration*: int32
        reason*: PhoneCallDiscardReasonI
        connection_id*: int64
    PhoneSetCallRating* = ref object of TLFunction
        flags: int32
        user_initiative*: bool
        peer*: InputPhoneCallI
        rating*: int32
        comment*: string
    PhoneSaveCallDebug* = ref object of TLFunction
        peer*: InputPhoneCallI
        debug*: DataJSONI
    PhoneSendSignalingData* = ref object of TLFunction
        peer*: InputPhoneCallI
        data*: seq[uint8]
    PhoneCreateGroupCall* = ref object of TLFunction
        peer*: InputPeerI
        random_id*: int32
    PhoneJoinGroupCall* = ref object of TLFunction
        flags: int32
        muted*: bool
        call*: InputGroupCallI
        join_as*: InputPeerI
        invite_hash*: Option[string]
        params*: DataJSONI
    PhoneLeaveGroupCall* = ref object of TLFunction
        call*: InputGroupCallI
        source*: int32
    PhoneInviteToGroupCall* = ref object of TLFunction
        call*: InputGroupCallI
        users*: seq[InputUserI]
    PhoneDiscardGroupCall* = ref object of TLFunction
        call*: InputGroupCallI
    PhoneToggleGroupCallSettings* = ref object of TLFunction
        flags: int32
        reset_invite_hash*: bool
        call*: InputGroupCallI
        join_muted*: Option[bool]
    PhoneGetGroupCall* = ref object of TLFunction
        call*: InputGroupCallI
    PhoneGetGroupParticipants* = ref object of TLFunction
        call*: InputGroupCallI
        ids*: seq[InputPeerI]
        sources*: seq[int32]
        offset*: string
        limit*: int32
    PhoneCheckGroupCall* = ref object of TLFunction
        call*: InputGroupCallI
        source*: int32
    PhoneToggleGroupCallRecord* = ref object of TLFunction
        flags: int32
        start*: bool
        call*: InputGroupCallI
        title*: Option[string]
    PhoneEditGroupCallParticipant* = ref object of TLFunction
        flags: int32
        muted*: bool
        call*: InputGroupCallI
        participant*: InputPeerI
        volume*: Option[int32]
        raise_hand*: Option[bool]
    PhoneEditGroupCallTitle* = ref object of TLFunction
        call*: InputGroupCallI
        title*: string
    PhoneGetGroupCallJoinAs* = ref object of TLFunction
        peer*: InputPeerI
    PhoneExportGroupCallInvite* = ref object of TLFunction
        flags: int32
        can_self_unmute*: bool
        call*: InputGroupCallI
method getTypeName*(self: PhoneGetCallConfig): string = "PhoneGetCallConfig"
method getTypeName*(self: PhoneRequestCall): string = "PhoneRequestCall"
method getTypeName*(self: PhoneAcceptCall): string = "PhoneAcceptCall"
method getTypeName*(self: PhoneConfirmCall): string = "PhoneConfirmCall"
method getTypeName*(self: PhoneReceivedCall): string = "PhoneReceivedCall"
method getTypeName*(self: PhoneDiscardCall): string = "PhoneDiscardCall"
method getTypeName*(self: PhoneSetCallRating): string = "PhoneSetCallRating"
method getTypeName*(self: PhoneSaveCallDebug): string = "PhoneSaveCallDebug"
method getTypeName*(self: PhoneSendSignalingData): string = "PhoneSendSignalingData"
method getTypeName*(self: PhoneCreateGroupCall): string = "PhoneCreateGroupCall"
method getTypeName*(self: PhoneJoinGroupCall): string = "PhoneJoinGroupCall"
method getTypeName*(self: PhoneLeaveGroupCall): string = "PhoneLeaveGroupCall"
method getTypeName*(self: PhoneInviteToGroupCall): string = "PhoneInviteToGroupCall"
method getTypeName*(self: PhoneDiscardGroupCall): string = "PhoneDiscardGroupCall"
method getTypeName*(self: PhoneToggleGroupCallSettings): string = "PhoneToggleGroupCallSettings"
method getTypeName*(self: PhoneGetGroupCall): string = "PhoneGetGroupCall"
method getTypeName*(self: PhoneGetGroupParticipants): string = "PhoneGetGroupParticipants"
method getTypeName*(self: PhoneCheckGroupCall): string = "PhoneCheckGroupCall"
method getTypeName*(self: PhoneToggleGroupCallRecord): string = "PhoneToggleGroupCallRecord"
method getTypeName*(self: PhoneEditGroupCallParticipant): string = "PhoneEditGroupCallParticipant"
method getTypeName*(self: PhoneEditGroupCallTitle): string = "PhoneEditGroupCallTitle"
method getTypeName*(self: PhoneGetGroupCallJoinAs): string = "PhoneGetGroupCallJoinAs"
method getTypeName*(self: PhoneExportGroupCallInvite): string = "PhoneExportGroupCallInvite"

method TLEncode*(self: PhoneGetCallConfig): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x55451fa9))
method TLDecode*(self: PhoneGetCallConfig, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: PhoneRequestCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x42ff96ed))
    if self.video:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.user_id)
    result = result & TLEncode(self.random_id)
    result = result & TLEncode(self.g_a_hash)
    result = result & TLEncode(self.protocol)
method TLDecode*(self: PhoneRequestCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.video = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.user_id = cast[InputUserI](tempObj)
    bytes.TLDecode(addr self.random_id)
    self.g_a_hash = bytes.TLDecode()
    tempObj.TLDecode(bytes)
    self.protocol = cast[PhoneCallProtocolI](tempObj)
method TLEncode*(self: PhoneAcceptCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x3bd2b4a0))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.g_b)
    result = result & TLEncode(self.protocol)
method TLDecode*(self: PhoneAcceptCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPhoneCallI](tempObj)
    self.g_b = bytes.TLDecode()
    tempObj.TLDecode(bytes)
    self.protocol = cast[PhoneCallProtocolI](tempObj)
method TLEncode*(self: PhoneConfirmCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x2efe1722))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.g_a)
    result = result & TLEncode(self.key_fingerprint)
    result = result & TLEncode(self.protocol)
method TLDecode*(self: PhoneConfirmCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPhoneCallI](tempObj)
    self.g_a = bytes.TLDecode()
    bytes.TLDecode(addr self.key_fingerprint)
    tempObj.TLDecode(bytes)
    self.protocol = cast[PhoneCallProtocolI](tempObj)
method TLEncode*(self: PhoneReceivedCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x17d54f61))
    result = result & TLEncode(self.peer)
method TLDecode*(self: PhoneReceivedCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPhoneCallI](tempObj)
method TLEncode*(self: PhoneDiscardCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb2cbc1c0))
    if self.video:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.duration)
    result = result & TLEncode(self.reason)
    result = result & TLEncode(self.connection_id)
method TLDecode*(self: PhoneDiscardCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.video = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPhoneCallI](tempObj)
    bytes.TLDecode(addr self.duration)
    tempObj.TLDecode(bytes)
    self.reason = cast[PhoneCallDiscardReasonI](tempObj)
    bytes.TLDecode(addr self.connection_id)
method TLEncode*(self: PhoneSetCallRating): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x59ead627))
    if self.user_initiative:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.rating)
    result = result & TLEncode(self.comment)
method TLDecode*(self: PhoneSetCallRating, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.user_initiative = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPhoneCallI](tempObj)
    bytes.TLDecode(addr self.rating)
    self.comment = cast[string](bytes.TLDecode())
method TLEncode*(self: PhoneSaveCallDebug): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x277add7e))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.debug)
method TLDecode*(self: PhoneSaveCallDebug, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPhoneCallI](tempObj)
    tempObj.TLDecode(bytes)
    self.debug = cast[DataJSONI](tempObj)
method TLEncode*(self: PhoneSendSignalingData): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xff7a9383))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.data)
method TLDecode*(self: PhoneSendSignalingData, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPhoneCallI](tempObj)
    self.data = bytes.TLDecode()
method TLEncode*(self: PhoneCreateGroupCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xbd3dabe0))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.random_id)
method TLDecode*(self: PhoneCreateGroupCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    bytes.TLDecode(addr self.random_id)
method TLEncode*(self: PhoneJoinGroupCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb132ff7b))
    if self.muted:
        self.flags = self.flags or 1 shl 0
    if self.invite_hash.isSome():
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.call)
    result = result & TLEncode(self.join_as)
    if self.invite_hash.isSome():
        result = result & TLEncode(self.invite_hash.get())
    result = result & TLEncode(self.params)
method TLDecode*(self: PhoneJoinGroupCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.muted = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.call = cast[InputGroupCallI](tempObj)
    tempObj.TLDecode(bytes)
    self.join_as = cast[InputPeerI](tempObj)
    if (self.flags and (1 shl 1)) != 0:
        self.invite_hash = some(cast[string](bytes.TLDecode()))
    tempObj.TLDecode(bytes)
    self.params = cast[DataJSONI](tempObj)
method TLEncode*(self: PhoneLeaveGroupCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x500377f9))
    result = result & TLEncode(self.call)
    result = result & TLEncode(self.source)
method TLDecode*(self: PhoneLeaveGroupCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.call = cast[InputGroupCallI](tempObj)
    bytes.TLDecode(addr self.source)
method TLEncode*(self: PhoneInviteToGroupCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x7b393160))
    result = result & TLEncode(self.call)
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: PhoneInviteToGroupCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.call = cast[InputGroupCallI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.users = cast[seq[InputUserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: PhoneDiscardGroupCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x7a777135))
    result = result & TLEncode(self.call)
method TLDecode*(self: PhoneDiscardGroupCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.call = cast[InputGroupCallI](tempObj)
method TLEncode*(self: PhoneToggleGroupCallSettings): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x74bbb43d))
    if self.reset_invite_hash:
        self.flags = self.flags or 1 shl 1
    if self.join_muted.isSome():
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.call)
    if self.join_muted.isSome():
        result = result & TLEncode(self.join_muted.get())
method TLDecode*(self: PhoneToggleGroupCallSettings, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 1)) != 0:
        self.reset_invite_hash = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.call = cast[InputGroupCallI](tempObj)
    if (self.flags and (1 shl 0)) != 0:
        var tempVal: bool
        bytes.TLDecode(tempVal)
        self.join_muted = some(tempVal)
method TLEncode*(self: PhoneGetGroupCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc7cb017))
    result = result & TLEncode(self.call)
method TLDecode*(self: PhoneGetGroupCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.call = cast[InputGroupCallI](tempObj)
method TLEncode*(self: PhoneGetGroupParticipants): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc558d8ab))
    result = result & TLEncode(self.call)
    result = result & TLEncode(cast[seq[TL]](self.ids))
    result = result & TLEncode(self.sources)
    result = result & TLEncode(self.offset)
    result = result & TLEncode(self.limit)
method TLDecode*(self: PhoneGetGroupParticipants, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.call = cast[InputGroupCallI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.ids = cast[seq[InputPeerI]](tempVector)
    tempVector.setLen(0)
    bytes.TLDecode(self.sources)
    self.offset = cast[string](bytes.TLDecode())
    bytes.TLDecode(addr self.limit)
method TLEncode*(self: PhoneCheckGroupCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb74a7bea))
    result = result & TLEncode(self.call)
    result = result & TLEncode(self.source)
method TLDecode*(self: PhoneCheckGroupCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.call = cast[InputGroupCallI](tempObj)
    bytes.TLDecode(addr self.source)
method TLEncode*(self: PhoneToggleGroupCallRecord): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc02a66d7))
    if self.start:
        self.flags = self.flags or 1 shl 0
    if self.title.isSome():
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.call)
    if self.title.isSome():
        result = result & TLEncode(self.title.get())
method TLDecode*(self: PhoneToggleGroupCallRecord, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.start = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.call = cast[InputGroupCallI](tempObj)
    if (self.flags and (1 shl 1)) != 0:
        self.title = some(cast[string](bytes.TLDecode()))
method TLEncode*(self: PhoneEditGroupCallParticipant): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xd975eb80))
    if self.muted:
        self.flags = self.flags or 1 shl 0
    if self.volume.isSome():
        self.flags = self.flags or 1 shl 1
    if self.raise_hand.isSome():
        self.flags = self.flags or 1 shl 2
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.call)
    result = result & TLEncode(self.participant)
    if self.volume.isSome():
        result = result & TLEncode(self.volume.get())
    if self.raise_hand.isSome():
        result = result & TLEncode(self.raise_hand.get())
method TLDecode*(self: PhoneEditGroupCallParticipant, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.muted = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.call = cast[InputGroupCallI](tempObj)
    tempObj.TLDecode(bytes)
    self.participant = cast[InputPeerI](tempObj)
    if (self.flags and (1 shl 1)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.volume = some(tempVal)
    if (self.flags and (1 shl 2)) != 0:
        var tempVal: bool
        bytes.TLDecode(tempVal)
        self.raise_hand = some(tempVal)
method TLEncode*(self: PhoneEditGroupCallTitle): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x1ca6ac0a))
    result = result & TLEncode(self.call)
    result = result & TLEncode(self.title)
method TLDecode*(self: PhoneEditGroupCallTitle, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.call = cast[InputGroupCallI](tempObj)
    self.title = cast[string](bytes.TLDecode())
method TLEncode*(self: PhoneGetGroupCallJoinAs): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xef7c213a))
    result = result & TLEncode(self.peer)
method TLDecode*(self: PhoneGetGroupCallJoinAs, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
method TLEncode*(self: PhoneExportGroupCallInvite): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xe6aa647f))
    if self.can_self_unmute:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.call)
method TLDecode*(self: PhoneExportGroupCallInvite, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.can_self_unmute = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.call = cast[InputGroupCallI](tempObj)
