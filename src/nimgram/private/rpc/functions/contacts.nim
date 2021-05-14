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
    ContactsGetContactIDs* = ref object of TLFunction
        hash*: int32
    ContactsGetStatuses* = ref object of TLFunction
    ContactsGetContacts* = ref object of TLFunction
        hash*: int32
    ContactsImportContacts* = ref object of TLFunction
        contacts*: seq[InputContactI]
    ContactsDeleteContacts* = ref object of TLFunction
        id*: seq[InputUserI]
    ContactsDeleteByPhones* = ref object of TLFunction
        phones*: seq[string]
    ContactsBlock* = ref object of TLFunction
        id*: InputPeerI
    ContactsUnblock* = ref object of TLFunction
        id*: InputPeerI
    ContactsGetBlocked* = ref object of TLFunction
        offset*: int32
        limit*: int32
    ContactsSearch* = ref object of TLFunction
        q*: string
        limit*: int32
    ContactsResolveUsername* = ref object of TLFunction
        username*: string
    ContactsGetTopPeers* = ref object of TLFunction
        flags: int32
        correspondents*: bool
        bots_pm*: bool
        bots_inline*: bool
        phone_calls*: bool
        forward_users*: bool
        forward_chats*: bool
        groups*: bool
        channels*: bool
        offset*: int32
        limit*: int32
        hash*: int32
    ContactsResetTopPeerRating* = ref object of TLFunction
        category*: TopPeerCategoryI
        peer*: InputPeerI
    ContactsResetSaved* = ref object of TLFunction
    ContactsGetSaved* = ref object of TLFunction
    ContactsToggleTopPeers* = ref object of TLFunction
        enabled*: bool
    ContactsAddContact* = ref object of TLFunction
        flags: int32
        add_phone_privacy_exception*: bool
        id*: InputUserI
        first_name*: string
        last_name*: string
        phone*: string
    ContactsAcceptContact* = ref object of TLFunction
        id*: InputUserI
    ContactsGetLocated* = ref object of TLFunction
        flags: int32
        background*: bool
        geo_point*: InputGeoPointI
        self_expires*: Option[int32]
    ContactsBlockFromReplies* = ref object of TLFunction
        flags: int32
        delete_message*: bool
        delete_history*: bool
        report_spam*: bool
        msg_id*: int32
method getTypeName*(self: ContactsGetContactIDs): string = "ContactsGetContactIDs"
method getTypeName*(self: ContactsGetStatuses): string = "ContactsGetStatuses"
method getTypeName*(self: ContactsGetContacts): string = "ContactsGetContacts"
method getTypeName*(self: ContactsImportContacts): string = "ContactsImportContacts"
method getTypeName*(self: ContactsDeleteContacts): string = "ContactsDeleteContacts"
method getTypeName*(self: ContactsDeleteByPhones): string = "ContactsDeleteByPhones"
method getTypeName*(self: ContactsBlock): string = "ContactsBlock"
method getTypeName*(self: ContactsUnblock): string = "ContactsUnblock"
method getTypeName*(self: ContactsGetBlocked): string = "ContactsGetBlocked"
method getTypeName*(self: ContactsSearch): string = "ContactsSearch"
method getTypeName*(self: ContactsResolveUsername): string = "ContactsResolveUsername"
method getTypeName*(self: ContactsGetTopPeers): string = "ContactsGetTopPeers"
method getTypeName*(self: ContactsResetTopPeerRating): string = "ContactsResetTopPeerRating"
method getTypeName*(self: ContactsResetSaved): string = "ContactsResetSaved"
method getTypeName*(self: ContactsGetSaved): string = "ContactsGetSaved"
method getTypeName*(self: ContactsToggleTopPeers): string = "ContactsToggleTopPeers"
method getTypeName*(self: ContactsAddContact): string = "ContactsAddContact"
method getTypeName*(self: ContactsAcceptContact): string = "ContactsAcceptContact"
method getTypeName*(self: ContactsGetLocated): string = "ContactsGetLocated"
method getTypeName*(self: ContactsBlockFromReplies): string = "ContactsBlockFromReplies"

method TLEncode*(self: ContactsGetContactIDs): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x2caa4a42))
    result = result & TLEncode(self.hash)
method TLDecode*(self: ContactsGetContactIDs, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: ContactsGetStatuses): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc4a353ee))
method TLDecode*(self: ContactsGetStatuses, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: ContactsGetContacts): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc023849f))
    result = result & TLEncode(self.hash)
method TLDecode*(self: ContactsGetContacts, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: ContactsImportContacts): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x2c800be5))
    result = result & TLEncode(cast[seq[TL]](self.contacts))
method TLDecode*(self: ContactsImportContacts, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.contacts = cast[seq[InputContactI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: ContactsDeleteContacts): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x96a0e00))
    result = result & TLEncode(cast[seq[TL]](self.id))
method TLDecode*(self: ContactsDeleteContacts, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.id = cast[seq[InputUserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: ContactsDeleteByPhones): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x1013fd9e))
    result = result & TLEncode(cast[seq[TL]](self.phones))
method TLDecode*(self: ContactsDeleteByPhones, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.phones = cast[seq[string]](bytes.TLDecodeSeq())
method TLEncode*(self: ContactsBlock): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x68cc1411))
    result = result & TLEncode(self.id)
method TLDecode*(self: ContactsBlock, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.id = cast[InputPeerI](tempObj)
method TLEncode*(self: ContactsUnblock): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xbea65d50))
    result = result & TLEncode(self.id)
method TLDecode*(self: ContactsUnblock, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.id = cast[InputPeerI](tempObj)
method TLEncode*(self: ContactsGetBlocked): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf57c350f))
    result = result & TLEncode(self.offset)
    result = result & TLEncode(self.limit)
method TLDecode*(self: ContactsGetBlocked, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.offset)
    bytes.TLDecode(addr self.limit)
method TLEncode*(self: ContactsSearch): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x11f812d8))
    result = result & TLEncode(self.q)
    result = result & TLEncode(self.limit)
method TLDecode*(self: ContactsSearch, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.q = cast[string](bytes.TLDecode())
    bytes.TLDecode(addr self.limit)
method TLEncode*(self: ContactsResolveUsername): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf93ccba3))
    result = result & TLEncode(self.username)
method TLDecode*(self: ContactsResolveUsername, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.username = cast[string](bytes.TLDecode())
method TLEncode*(self: ContactsGetTopPeers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xd4982db5))
    if self.correspondents:
        self.flags = self.flags or 1 shl 0
    if self.bots_pm:
        self.flags = self.flags or 1 shl 1
    if self.bots_inline:
        self.flags = self.flags or 1 shl 2
    if self.phone_calls:
        self.flags = self.flags or 1 shl 3
    if self.forward_users:
        self.flags = self.flags or 1 shl 4
    if self.forward_chats:
        self.flags = self.flags or 1 shl 5
    if self.groups:
        self.flags = self.flags or 1 shl 10
    if self.channels:
        self.flags = self.flags or 1 shl 15
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.offset)
    result = result & TLEncode(self.limit)
    result = result & TLEncode(self.hash)
method TLDecode*(self: ContactsGetTopPeers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.correspondents = true
    if (self.flags and (1 shl 1)) != 0:
        self.bots_pm = true
    if (self.flags and (1 shl 2)) != 0:
        self.bots_inline = true
    if (self.flags and (1 shl 3)) != 0:
        self.phone_calls = true
    if (self.flags and (1 shl 4)) != 0:
        self.forward_users = true
    if (self.flags and (1 shl 5)) != 0:
        self.forward_chats = true
    if (self.flags and (1 shl 10)) != 0:
        self.groups = true
    if (self.flags and (1 shl 15)) != 0:
        self.channels = true
    bytes.TLDecode(addr self.offset)
    bytes.TLDecode(addr self.limit)
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: ContactsResetTopPeerRating): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x1ae373ac))
    result = result & TLEncode(self.category)
    result = result & TLEncode(self.peer)
method TLDecode*(self: ContactsResetTopPeerRating, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.category = cast[TopPeerCategoryI](tempObj)
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
method TLEncode*(self: ContactsResetSaved): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x879537f1))
method TLDecode*(self: ContactsResetSaved, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: ContactsGetSaved): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x82f1e39f))
method TLDecode*(self: ContactsGetSaved, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: ContactsToggleTopPeers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x8514bdda))
    result = result & TLEncode(self.enabled)
method TLDecode*(self: ContactsToggleTopPeers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(self.enabled)
method TLEncode*(self: ContactsAddContact): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xe8f463d0))
    if self.add_phone_privacy_exception:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.id)
    result = result & TLEncode(self.first_name)
    result = result & TLEncode(self.last_name)
    result = result & TLEncode(self.phone)
method TLDecode*(self: ContactsAddContact, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.add_phone_privacy_exception = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.id = cast[InputUserI](tempObj)
    self.first_name = cast[string](bytes.TLDecode())
    self.last_name = cast[string](bytes.TLDecode())
    self.phone = cast[string](bytes.TLDecode())
method TLEncode*(self: ContactsAcceptContact): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf831a20f))
    result = result & TLEncode(self.id)
method TLDecode*(self: ContactsAcceptContact, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.id = cast[InputUserI](tempObj)
method TLEncode*(self: ContactsGetLocated): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xd348bc44))
    if self.background:
        self.flags = self.flags or 1 shl 1
    if self.self_expires.isSome():
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.geo_point)
    if self.self_expires.isSome():
        result = result & TLEncode(self.self_expires.get())
method TLDecode*(self: ContactsGetLocated, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 1)) != 0:
        self.background = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.geo_point = cast[InputGeoPointI](tempObj)
    if (self.flags and (1 shl 0)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.self_expires = some(tempVal)
method TLEncode*(self: ContactsBlockFromReplies): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x29a8962c))
    if self.delete_message:
        self.flags = self.flags or 1 shl 0
    if self.delete_history:
        self.flags = self.flags or 1 shl 1
    if self.report_spam:
        self.flags = self.flags or 1 shl 2
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.msg_id)
method TLDecode*(self: ContactsBlockFromReplies, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.delete_message = true
    if (self.flags and (1 shl 1)) != 0:
        self.delete_history = true
    if (self.flags and (1 shl 2)) != 0:
        self.report_spam = true
    bytes.TLDecode(addr self.msg_id)
