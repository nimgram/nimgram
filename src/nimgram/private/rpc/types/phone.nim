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
    PhonePhoneCall* = ref object of PhonePhoneCallI
        phone_call*: PhoneCallI
        users*: seq[UserI]
    PhoneGroupCall* = ref object of PhoneGroupCallI
        call*: GroupCallI
        participants*: seq[GroupCallParticipantI]
        participants_next_offset*: string
        chats*: seq[ChatI]
        users*: seq[UserI]
    PhoneGroupParticipants* = ref object of PhoneGroupParticipantsI
        count*: int32
        participants*: seq[GroupCallParticipantI]
        next_offset*: string
        chats*: seq[ChatI]
        users*: seq[UserI]
        version*: int32
    PhoneJoinAsPeers* = ref object of PhoneJoinAsPeersI
        peers*: seq[PeerI]
        chats*: seq[ChatI]
        users*: seq[UserI]
    PhoneExportedGroupCallInvite* = ref object of PhoneExportedGroupCallInviteI
        link*: string
method getTypeName*(self: PhonePhoneCall): string = "PhonePhoneCall"
method getTypeName*(self: PhoneGroupCall): string = "PhoneGroupCall"
method getTypeName*(self: PhoneGroupParticipants): string = "PhoneGroupParticipants"
method getTypeName*(self: PhoneJoinAsPeers): string = "PhoneJoinAsPeers"
method getTypeName*(self: PhoneExportedGroupCallInvite): string = "PhoneExportedGroupCallInvite"

method TLEncode*(self: PhonePhoneCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xec82e140))
    result = result & TLEncode(self.phone_call)
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: PhonePhoneCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.phone_call = cast[PhoneCallI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: PhoneGroupCall): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x9e727aad))
    result = result & TLEncode(self.call)
    result = result & TLEncode(cast[seq[TL]](self.participants))
    result = result & TLEncode(self.participants_next_offset)
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: PhoneGroupCall, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.call = cast[GroupCallI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.participants = cast[seq[GroupCallParticipantI]](tempVector)
    tempVector.setLen(0)
    self.participants_next_offset = cast[string](bytes.TLDecode())
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: PhoneGroupParticipants): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf47751b6))
    result = result & TLEncode(self.count)
    result = result & TLEncode(cast[seq[TL]](self.participants))
    result = result & TLEncode(self.next_offset)
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
    result = result & TLEncode(self.version)
method TLDecode*(self: PhoneGroupParticipants, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.count)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.participants = cast[seq[GroupCallParticipantI]](tempVector)
    tempVector.setLen(0)
    self.next_offset = cast[string](bytes.TLDecode())
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
    bytes.TLDecode(addr self.version)
method TLEncode*(self: PhoneJoinAsPeers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xafe5623f))
    result = result & TLEncode(cast[seq[TL]](self.peers))
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: PhoneJoinAsPeers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.peers = cast[seq[PeerI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: PhoneExportedGroupCallInvite): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x204bd158))
    result = result & TLEncode(self.link)
method TLDecode*(self: PhoneExportedGroupCallInvite, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.link = cast[string](bytes.TLDecode())
