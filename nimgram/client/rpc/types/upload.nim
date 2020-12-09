type
    UploadFile* = ref object of UploadFileI
        typeof*: StorageFileTypeI
        mtime*: int32
        bytes*: seq[uint8]
    UploadFileCdnRedirect* = ref object of UploadFileI
        dc_id*: int32
        file_token*: seq[uint8]
        encryption_key*: seq[uint8]
        encryption_iv*: seq[uint8]
        file_hashes*: seq[FileHashI]
    UploadWebFile* = ref object of UploadWebFileI
        size*: int32
        mime_type*: string
        file_type*: StorageFileTypeI
        mtime*: int32
        bytes*: seq[uint8]
    UploadCdnFileReuploadNeeded* = ref object of UploadCdnFileI
        request_token*: seq[uint8]
    UploadCdnFile* = ref object of UploadCdnFileI
        bytes*: seq[uint8]
method getTypeName*(self: UploadFile): string = "UploadFile"
method getTypeName*(self: UploadFileCdnRedirect): string = "UploadFileCdnRedirect"
method getTypeName*(self: UploadWebFile): string = "UploadWebFile"
method getTypeName*(self: UploadCdnFileReuploadNeeded): string = "UploadCdnFileReuploadNeeded"
method getTypeName*(self: UploadCdnFile): string = "UploadCdnFile"

method TLEncode*(self: UploadFile): seq[uint8] =
    result = TLEncode(uint32(2527169872))
    result = result & TLEncode(self.typeof)
    result = result & TLEncode(self.mtime)
    result = result & TLEncode(self.bytes)
method TLDecode*(self: UploadFile, bytes: var ScalingSeq[uint8]) = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.typeof = cast[StorageFileTypeI](tempObj)
    bytes.TLDecode(addr self.mtime)
    self.bytes = bytes.TLDecode()
method TLEncode*(self: UploadFileCdnRedirect): seq[uint8] =
    result = TLEncode(uint32(4052539972))
    result = result & TLEncode(self.dc_id)
    result = result & TLEncode(self.file_token)
    result = result & TLEncode(self.encryption_key)
    result = result & TLEncode(self.encryption_iv)
    result = result & TLEncode(cast[seq[TL]](self.file_hashes))
method TLDecode*(self: UploadFileCdnRedirect, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.dc_id)
    self.file_token = bytes.TLDecode()
    self.encryption_key = bytes.TLDecode()
    self.encryption_iv = bytes.TLDecode()
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.file_hashes = cast[seq[FileHashI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: UploadWebFile): seq[uint8] =
    result = TLEncode(uint32(568808380))
    result = result & TLEncode(self.size)
    result = result & TLEncode(self.mime_type)
    result = result & TLEncode(self.file_type)
    result = result & TLEncode(self.mtime)
    result = result & TLEncode(self.bytes)
method TLDecode*(self: UploadWebFile, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.size)
    self.mime_type = cast[string](bytes.TLDecode())
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.file_type = cast[StorageFileTypeI](tempObj)
    bytes.TLDecode(addr self.mtime)
    self.bytes = bytes.TLDecode()
method TLEncode*(self: UploadCdnFileReuploadNeeded): seq[uint8] =
    result = TLEncode(uint32(4004045934))
    result = result & TLEncode(self.request_token)
method TLDecode*(self: UploadCdnFileReuploadNeeded, bytes: var ScalingSeq[uint8]) = 
    self.request_token = bytes.TLDecode()
method TLEncode*(self: UploadCdnFile): seq[uint8] =
    result = TLEncode(uint32(2845821519))
    result = result & TLEncode(self.bytes)
method TLDecode*(self: UploadCdnFile, bytes: var ScalingSeq[uint8]) = 
    self.bytes = bytes.TLDecode()
