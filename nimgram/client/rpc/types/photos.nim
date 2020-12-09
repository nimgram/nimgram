type
    PhotosPhotos* = ref object of PhotosPhotosI
        photos*: seq[PhotoI]
        users*: seq[UserI]
    PhotosPhotosSlice* = ref object of PhotosPhotosI
        count*: int32
        photos*: seq[PhotoI]
        users*: seq[UserI]
    PhotosPhoto* = ref object of PhotosPhotoI
        photo*: PhotoI
        users*: seq[UserI]
method getTypeName*(self: PhotosPhotos): string = "PhotosPhotos"
method getTypeName*(self: PhotosPhotosSlice): string = "PhotosPhotosSlice"
method getTypeName*(self: PhotosPhoto): string = "PhotosPhoto"

method TLEncode*(self: PhotosPhotos): seq[uint8] =
    result = TLEncode(uint32(2378853029))
    result = result & TLEncode(cast[seq[TL]](self.photos))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: PhotosPhotos, bytes: var ScalingSeq[uint8]) = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.photos = cast[seq[PhotoI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: PhotosPhotosSlice): seq[uint8] =
    result = TLEncode(uint32(352657236))
    result = result & TLEncode(self.count)
    result = result & TLEncode(cast[seq[TL]](self.photos))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: PhotosPhotosSlice, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.count)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.photos = cast[seq[PhotoI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: PhotosPhoto): seq[uint8] =
    result = TLEncode(uint32(539045032))
    result = result & TLEncode(self.photo)
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: PhotosPhoto, bytes: var ScalingSeq[uint8]) = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.photo = cast[PhotoI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
