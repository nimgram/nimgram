type
    ContactsContactsNotModified* = ref object of ContactsContactsI
    ContactsContacts* = ref object of ContactsContactsI
        contacts*: seq[ContactI]
        saved_count*: int32
        users*: seq[UserI]
    ContactsImportedContacts* = ref object of ContactsImportedContactsI
        imported*: seq[ImportedContactI]
        popular_invites*: seq[PopularContactI]
        retry_contacts*: seq[int64]
        users*: seq[UserI]
    ContactsBlocked* = ref object of ContactsBlockedI
        blocked*: seq[PeerBlockedI]
        chats*: seq[ChatI]
        users*: seq[UserI]
    ContactsBlockedSlice* = ref object of ContactsBlockedI
        count*: int32
        blocked*: seq[PeerBlockedI]
        chats*: seq[ChatI]
        users*: seq[UserI]
    ContactsFound* = ref object of ContactsFoundI
        my_results*: seq[PeerI]
        results*: seq[PeerI]
        chats*: seq[ChatI]
        users*: seq[UserI]
    ContactsResolvedPeer* = ref object of ContactsResolvedPeerI
        peer*: PeerI
        chats*: seq[ChatI]
        users*: seq[UserI]
    ContactsTopPeersNotModified* = ref object of ContactsTopPeersI
    ContactsTopPeers* = ref object of ContactsTopPeersI
        categories*: seq[TopPeerCategoryPeersI]
        chats*: seq[ChatI]
        users*: seq[UserI]
    ContactsTopPeersDisabled* = ref object of ContactsTopPeersI
method getTypeName*(self: ContactsContactsNotModified): string = "ContactsContactsNotModified"
method getTypeName*(self: ContactsContacts): string = "ContactsContacts"
method getTypeName*(self: ContactsImportedContacts): string = "ContactsImportedContacts"
method getTypeName*(self: ContactsBlocked): string = "ContactsBlocked"
method getTypeName*(self: ContactsBlockedSlice): string = "ContactsBlockedSlice"
method getTypeName*(self: ContactsFound): string = "ContactsFound"
method getTypeName*(self: ContactsResolvedPeer): string = "ContactsResolvedPeer"
method getTypeName*(self: ContactsTopPeersNotModified): string = "ContactsTopPeersNotModified"
method getTypeName*(self: ContactsTopPeers): string = "ContactsTopPeers"
method getTypeName*(self: ContactsTopPeersDisabled): string = "ContactsTopPeersDisabled"

method TLEncode*(self: ContactsContactsNotModified): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb74ba9d2))
method TLDecode*(self: ContactsContactsNotModified, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: ContactsContacts): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xeae87e42))
    result = result & TLEncode(cast[seq[TL]](self.contacts))
    result = result & TLEncode(self.saved_count)
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: ContactsContacts, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.contacts = cast[seq[ContactI]](tempVector)
    tempVector.setLen(0)
    bytes.TLDecode(addr self.saved_count)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: ContactsImportedContacts): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x77d01c3b))
    result = result & TLEncode(cast[seq[TL]](self.imported))
    result = result & TLEncode(cast[seq[TL]](self.popular_invites))
    result = result & TLEncode(self.retry_contacts)
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: ContactsImportedContacts, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.imported = cast[seq[ImportedContactI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.popular_invites = cast[seq[PopularContactI]](tempVector)
    tempVector.setLen(0)
    bytes.TLDecode(self.retry_contacts)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: ContactsBlocked): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xade1591))
    result = result & TLEncode(cast[seq[TL]](self.blocked))
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: ContactsBlocked, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.blocked = cast[seq[PeerBlockedI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: ContactsBlockedSlice): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xe1664194))
    result = result & TLEncode(self.count)
    result = result & TLEncode(cast[seq[TL]](self.blocked))
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: ContactsBlockedSlice, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.count)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.blocked = cast[seq[PeerBlockedI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: ContactsFound): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb3134d9d))
    result = result & TLEncode(cast[seq[TL]](self.my_results))
    result = result & TLEncode(cast[seq[TL]](self.results))
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: ContactsFound, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.my_results = cast[seq[PeerI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.results = cast[seq[PeerI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: ContactsResolvedPeer): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x7f077ad9))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: ContactsResolvedPeer, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[PeerI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: ContactsTopPeersNotModified): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xde266ef5))
method TLDecode*(self: ContactsTopPeersNotModified, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: ContactsTopPeers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x70b772a8))
    result = result & TLEncode(cast[seq[TL]](self.categories))
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: ContactsTopPeers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.categories = cast[seq[TopPeerCategoryPeersI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: ContactsTopPeersDisabled): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb52c939d))
method TLDecode*(self: ContactsTopPeersDisabled, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
