type
    StorageFileUnknown* = ref object of StorageFileTypeI
    StorageFilePartial* = ref object of StorageFileTypeI
    StorageFileJpeg* = ref object of StorageFileTypeI
    StorageFileGif* = ref object of StorageFileTypeI
    StorageFilePng* = ref object of StorageFileTypeI
    StorageFilePdf* = ref object of StorageFileTypeI
    StorageFileMp3* = ref object of StorageFileTypeI
    StorageFileMov* = ref object of StorageFileTypeI
    StorageFileMp4* = ref object of StorageFileTypeI
    StorageFileWebp* = ref object of StorageFileTypeI
method getTypeName*(self: StorageFileUnknown): string = "StorageFileUnknown"
method getTypeName*(self: StorageFilePartial): string = "StorageFilePartial"
method getTypeName*(self: StorageFileJpeg): string = "StorageFileJpeg"
method getTypeName*(self: StorageFileGif): string = "StorageFileGif"
method getTypeName*(self: StorageFilePng): string = "StorageFilePng"
method getTypeName*(self: StorageFilePdf): string = "StorageFilePdf"
method getTypeName*(self: StorageFileMp3): string = "StorageFileMp3"
method getTypeName*(self: StorageFileMov): string = "StorageFileMov"
method getTypeName*(self: StorageFileMp4): string = "StorageFileMp4"
method getTypeName*(self: StorageFileWebp): string = "StorageFileWebp"

method TLEncode*(self: StorageFileUnknown): seq[uint8] =
    result = TLEncode(uint32(2861972229))
method TLDecode*(self: StorageFileUnknown, bytes: var ScalingSeq[uint8]) = 
    discard
method TLEncode*(self: StorageFilePartial): seq[uint8] =
    result = TLEncode(uint32(1086091090))
method TLDecode*(self: StorageFilePartial, bytes: var ScalingSeq[uint8]) = 
    discard
method TLEncode*(self: StorageFileJpeg): seq[uint8] =
    result = TLEncode(uint32(2130578944))
method TLDecode*(self: StorageFileJpeg, bytes: var ScalingSeq[uint8]) = 
    discard
method TLEncode*(self: StorageFileGif): seq[uint8] =
    result = TLEncode(uint32(3403786975))
method TLDecode*(self: StorageFileGif, bytes: var ScalingSeq[uint8]) = 
    discard
method TLEncode*(self: StorageFilePng): seq[uint8] =
    result = TLEncode(uint32(2767600640))
method TLDecode*(self: StorageFilePng, bytes: var ScalingSeq[uint8]) = 
    discard
method TLEncode*(self: StorageFilePdf): seq[uint8] =
    result = TLEncode(uint32(2921222285))
method TLDecode*(self: StorageFilePdf, bytes: var ScalingSeq[uint8]) = 
    discard
method TLEncode*(self: StorageFileMp3): seq[uint8] =
    result = TLEncode(uint32(1384777335))
method TLDecode*(self: StorageFileMp3, bytes: var ScalingSeq[uint8]) = 
    discard
method TLEncode*(self: StorageFileMov): seq[uint8] =
    result = TLEncode(uint32(1258941372))
method TLDecode*(self: StorageFileMov, bytes: var ScalingSeq[uint8]) = 
    discard
method TLEncode*(self: StorageFileMp4): seq[uint8] =
    result = TLEncode(uint32(3016663268))
method TLDecode*(self: StorageFileMp4, bytes: var ScalingSeq[uint8]) = 
    discard
method TLEncode*(self: StorageFileWebp): seq[uint8] =
    result = TLEncode(uint32(276907596))
method TLDecode*(self: StorageFileWebp, bytes: var ScalingSeq[uint8]) = 
    discard
