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

method TLEncode*(self: StorageFileUnknown): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xaa963b05))
method TLDecode*(self: StorageFileUnknown, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: StorageFilePartial): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x40bc6f52))
method TLDecode*(self: StorageFilePartial, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: StorageFileJpeg): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x7efe0e))
method TLDecode*(self: StorageFileJpeg, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: StorageFileGif): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xcae1aadf))
method TLDecode*(self: StorageFileGif, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: StorageFilePng): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xa4f63c0))
method TLDecode*(self: StorageFilePng, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: StorageFilePdf): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xae1e508d))
method TLDecode*(self: StorageFilePdf, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: StorageFileMp3): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x528a0677))
method TLDecode*(self: StorageFileMp3, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: StorageFileMov): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x4b09ebbc))
method TLDecode*(self: StorageFileMov, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: StorageFileMp4): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb3cea0e4))
method TLDecode*(self: StorageFileMp4, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: StorageFileWebp): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x1081464c))
method TLDecode*(self: StorageFileWebp, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
