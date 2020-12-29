type
    FoldersEditPeerFolders* = ref object of TLFunction
        folder_peers*: seq[InputFolderPeerI]
    FoldersDeleteFolder* = ref object of TLFunction
        folder_id*: int32
method getTypeName*(self: FoldersEditPeerFolders): string = "FoldersEditPeerFolders"
method getTypeName*(self: FoldersDeleteFolder): string = "FoldersDeleteFolder"

method TLEncode*(self: FoldersEditPeerFolders): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x6847d0ab))
    result = result & TLEncode(cast[seq[TL]](self.folder_peers))
method TLDecode*(self: FoldersEditPeerFolders, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.folder_peers = cast[seq[InputFolderPeerI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: FoldersDeleteFolder): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x1c295881))
    result = result & TLEncode(self.folder_id)
method TLDecode*(self: FoldersDeleteFolder, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.folder_id)
