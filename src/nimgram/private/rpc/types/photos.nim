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

method TLEncode*(self: PhotosPhotos): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x8dca6aa5))
    result = result & TLEncode(cast[seq[TL]](self.photos))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: PhotosPhotos, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.photos = cast[seq[PhotoI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: PhotosPhotosSlice): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x15051f54))
    result = result & TLEncode(self.count)
    result = result & TLEncode(cast[seq[TL]](self.photos))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: PhotosPhotosSlice, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.count)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.photos = cast[seq[PhotoI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: PhotosPhoto): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x20212ca8))
    result = result & TLEncode(self.photo)
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: PhotosPhoto, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.photo = cast[PhotoI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
