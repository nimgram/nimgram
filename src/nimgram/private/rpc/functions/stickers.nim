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
    StickersCreateStickerSet* = ref object of TLFunction
        flags: int32
        masks*: bool
        animated*: bool
        user_id*: InputUserI
        title*: string
        short_name*: string
        thumb*: Option[InputDocumentI]
        stickers*: seq[InputStickerSetItemI]
    StickersRemoveStickerFromSet* = ref object of TLFunction
        sticker*: InputDocumentI
    StickersChangeStickerPosition* = ref object of TLFunction
        sticker*: InputDocumentI
        position*: int32
    StickersAddStickerToSet* = ref object of TLFunction
        stickerset*: InputStickerSetI
        sticker*: InputStickerSetItemI
    StickersSetStickerSetThumb* = ref object of TLFunction
        stickerset*: InputStickerSetI
        thumb*: InputDocumentI
method getTypeName*(self: StickersCreateStickerSet): string = "StickersCreateStickerSet"
method getTypeName*(self: StickersRemoveStickerFromSet): string = "StickersRemoveStickerFromSet"
method getTypeName*(self: StickersChangeStickerPosition): string = "StickersChangeStickerPosition"
method getTypeName*(self: StickersAddStickerToSet): string = "StickersAddStickerToSet"
method getTypeName*(self: StickersSetStickerSetThumb): string = "StickersSetStickerSetThumb"

method TLEncode*(self: StickersCreateStickerSet): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf1036780))
    if self.masks:
        self.flags = self.flags or 1 shl 0
    if self.animated:
        self.flags = self.flags or 1 shl 1
    if self.thumb.isSome():
        self.flags = self.flags or 1 shl 2
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.user_id)
    result = result & TLEncode(self.title)
    result = result & TLEncode(self.short_name)
    if self.thumb.isSome():
        result = result & TLEncode(self.thumb.get())
    result = result & TLEncode(cast[seq[TL]](self.stickers))
method TLDecode*(self: StickersCreateStickerSet, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.masks = true
    if (self.flags and (1 shl 1)) != 0:
        self.animated = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.user_id = cast[InputUserI](tempObj)
    self.title = cast[string](bytes.TLDecode())
    self.short_name = cast[string](bytes.TLDecode())
    if (self.flags and (1 shl 2)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.thumb = some(tempVal.InputDocumentI)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.stickers = cast[seq[InputStickerSetItemI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: StickersRemoveStickerFromSet): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf7760f51))
    result = result & TLEncode(self.sticker)
method TLDecode*(self: StickersRemoveStickerFromSet, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.sticker = cast[InputDocumentI](tempObj)
method TLEncode*(self: StickersChangeStickerPosition): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xffb6d4ca))
    result = result & TLEncode(self.sticker)
    result = result & TLEncode(self.position)
method TLDecode*(self: StickersChangeStickerPosition, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.sticker = cast[InputDocumentI](tempObj)
    bytes.TLDecode(addr self.position)
method TLEncode*(self: StickersAddStickerToSet): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x8653febe))
    result = result & TLEncode(self.stickerset)
    result = result & TLEncode(self.sticker)
method TLDecode*(self: StickersAddStickerToSet, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.stickerset = cast[InputStickerSetI](tempObj)
    tempObj.TLDecode(bytes)
    self.sticker = cast[InputStickerSetItemI](tempObj)
method TLEncode*(self: StickersSetStickerSetThumb): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x9a364e30))
    result = result & TLEncode(self.stickerset)
    result = result & TLEncode(self.thumb)
method TLDecode*(self: StickersSetStickerSetThumb, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.stickerset = cast[InputStickerSetI](tempObj)
    tempObj.TLDecode(bytes)
    self.thumb = cast[InputDocumentI](tempObj)
