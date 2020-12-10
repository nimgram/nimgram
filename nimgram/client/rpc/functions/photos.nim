type
    PhotosUpdateProfilePhoto* = ref object of TLFunction
        id*: InputPhotoI
    PhotosUploadProfilePhoto* = ref object of TLFunction
        flags: int32
        file*: Option[InputFileI]
        video*: Option[InputFileI]
        video_start_ts*: Option[float64]
    PhotosDeletePhotos* = ref object of TLFunction
        id*: seq[InputPhotoI]
    PhotosGetUserPhotos* = ref object of TLFunction
        user_id*: InputUserI
        offset*: int32
        max_id*: int64
        limit*: int32
method getTypeName*(self: PhotosUpdateProfilePhoto): string = "PhotosUpdateProfilePhoto"
method getTypeName*(self: PhotosUploadProfilePhoto): string = "PhotosUploadProfilePhoto"
method getTypeName*(self: PhotosDeletePhotos): string = "PhotosDeletePhotos"
method getTypeName*(self: PhotosGetUserPhotos): string = "PhotosGetUserPhotos"

method TLEncode*(self: PhotosUpdateProfilePhoto): seq[uint8] =
    result = TLEncode(uint32(0x72d4742c))
    result = result & TLEncode(self.id)
method TLDecode*(self: PhotosUpdateProfilePhoto, bytes: var ScalingSeq[uint8]) = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.id = cast[InputPhotoI](tempObj)
method TLEncode*(self: PhotosUploadProfilePhoto): seq[uint8] =
    result = TLEncode(uint32(0x89f30f69))
    if self.file.isSome():
        self.flags = self.flags or 1 shl 0
    if self.video.isSome():
        self.flags = self.flags or 1 shl 1
    if self.video_start_ts.isSome():
        self.flags = self.flags or 1 shl 2
    result = result & TLEncode(self.flags)
    if self.file.isSome():
        result = result & TLEncode(self.file.get())
    if self.video.isSome():
        result = result & TLEncode(self.video.get())
    if self.video_start_ts.isSome():
        result = result & TLEncode(self.video_start_ts.get())
method TLDecode*(self: PhotosUploadProfilePhoto, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.file = some(tempVal.InputFileI)
    if (self.flags and (1 shl 1)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.video = some(tempVal.InputFileI)
    if (self.flags and (1 shl 2)) != 0:
        var tempVal: float64 = 0
        bytes.TLDecode(addr tempVal)
        self.video_start_ts = some(tempVal)
method TLEncode*(self: PhotosDeletePhotos): seq[uint8] =
    result = TLEncode(uint32(0x87cf7f2f))
    result = result & TLEncode(cast[seq[TL]](self.id))
method TLDecode*(self: PhotosDeletePhotos, bytes: var ScalingSeq[uint8]) = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.id = cast[seq[InputPhotoI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: PhotosGetUserPhotos): seq[uint8] =
    result = TLEncode(uint32(0x91cd32a8))
    result = result & TLEncode(self.user_id)
    result = result & TLEncode(self.offset)
    result = result & TLEncode(self.max_id)
    result = result & TLEncode(self.limit)
method TLDecode*(self: PhotosGetUserPhotos, bytes: var ScalingSeq[uint8]) = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.user_id = cast[InputUserI](tempObj)
    bytes.TLDecode(addr self.offset)
    bytes.TLDecode(addr self.max_id)
    bytes.TLDecode(addr self.limit)
