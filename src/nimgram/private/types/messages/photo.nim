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

import sequtils
import algorithm

type Photo* = ref object of Media ## A photo
    hasStickers: bool ## Whether the photo has mask stickers attached to it
    ttlSeconds*: Option[int32] ## Time to live in seconds of self-destructing photo
    ID*: int64 ## ID of the photo
    accessHash*: int64 ## Access hash
    fileReference*: seq[uint8] ## File reference
    date*: int32 ## Date of upload
    size*: int32 ## Size of the photo
    width*: int32 ## Photo width
    height*: int32 ## Photo height
    dcID*: int32 ## DC ID to use for download

proc parse*(photo: raw.MessageMediaPhoto): Option[Photo] =
    if not photo.photo.isSome():
        return
    let photoInternal = photo.photo.get()
    if not(photoInternal of raw.Photo):
        return
    let photoExtracted = cast[raw.Photo](photoInternal)
    var tempResult = new Photo
    tempResult.ttlSeconds = photo.ttl_seconds
    tempResult.hasStickers = photoExtracted.has_stickers
    tempResult.ID = photoExtracted.id
    tempResult.accessHash = photoExtracted.access_hash
    tempResult.fileReference = photoExtracted.file_reference
    tempResult.date = photoExtracted.date
    tempResult.dcID = photoExtracted.dc_id
    var photos: seq[raw.PhotoSize]
    
    for size in photoExtracted.sizes:
        if size of PhotoSize:
            photos.add(size.PhotoSize)
        if size of PhotoSizeProgressive:
            let sizec = size.PhotoSizeProgressive
            photos.add(PhotoSize(typeof: sizec.typeof, location: sizec.location, w: sizec.w, h: sizec.h, size: sizec.sizes[maxIndex(sizec.sizes)]))

    photos.sort(proc (x,y: PhotoSize): int =
        cmp(x.size, y.size))

    let photo = photos[photos.len-1]
    tempResult.size = photo.size
    tempResult.width = photo.w
    tempResult.height = photo.h
    result = some(tempResult)