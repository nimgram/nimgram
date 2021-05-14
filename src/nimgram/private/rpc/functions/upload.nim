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
    UploadSaveFilePart* = ref object of TLFunction
        file_id*: int64
        file_part*: int32
        bytes*: seq[uint8]
    UploadGetFile* = ref object of TLFunction
        flags: int32
        precise*: bool
        cdn_supported*: bool
        location*: InputFileLocationI
        offset*: int32
        limit*: int32
    UploadSaveBigFilePart* = ref object of TLFunction
        file_id*: int64
        file_part*: int32
        file_total_parts*: int32
        bytes*: seq[uint8]
    UploadGetWebFile* = ref object of TLFunction
        location*: InputWebFileLocationI
        offset*: int32
        limit*: int32
    UploadGetCdnFile* = ref object of TLFunction
        file_token*: seq[uint8]
        offset*: int32
        limit*: int32
    UploadReuploadCdnFile* = ref object of TLFunction
        file_token*: seq[uint8]
        request_token*: seq[uint8]
    UploadGetCdnFileHashes* = ref object of TLFunction
        file_token*: seq[uint8]
        offset*: int32
    UploadGetFileHashes* = ref object of TLFunction
        location*: InputFileLocationI
        offset*: int32
method getTypeName*(self: UploadSaveFilePart): string = "UploadSaveFilePart"
method getTypeName*(self: UploadGetFile): string = "UploadGetFile"
method getTypeName*(self: UploadSaveBigFilePart): string = "UploadSaveBigFilePart"
method getTypeName*(self: UploadGetWebFile): string = "UploadGetWebFile"
method getTypeName*(self: UploadGetCdnFile): string = "UploadGetCdnFile"
method getTypeName*(self: UploadReuploadCdnFile): string = "UploadReuploadCdnFile"
method getTypeName*(self: UploadGetCdnFileHashes): string = "UploadGetCdnFileHashes"
method getTypeName*(self: UploadGetFileHashes): string = "UploadGetFileHashes"

method TLEncode*(self: UploadSaveFilePart): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb304a621))
    result = result & TLEncode(self.file_id)
    result = result & TLEncode(self.file_part)
    result = result & TLEncode(self.bytes)
method TLDecode*(self: UploadSaveFilePart, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.file_id)
    bytes.TLDecode(addr self.file_part)
    self.bytes = bytes.TLDecode()
method TLEncode*(self: UploadGetFile): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xb15a9afc))
    if self.precise:
        self.flags = self.flags or 1 shl 0
    if self.cdn_supported:
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.location)
    result = result & TLEncode(self.offset)
    result = result & TLEncode(self.limit)
method TLDecode*(self: UploadGetFile, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.precise = true
    if (self.flags and (1 shl 1)) != 0:
        self.cdn_supported = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.location = cast[InputFileLocationI](tempObj)
    bytes.TLDecode(addr self.offset)
    bytes.TLDecode(addr self.limit)
method TLEncode*(self: UploadSaveBigFilePart): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xde7b673d))
    result = result & TLEncode(self.file_id)
    result = result & TLEncode(self.file_part)
    result = result & TLEncode(self.file_total_parts)
    result = result & TLEncode(self.bytes)
method TLDecode*(self: UploadSaveBigFilePart, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.file_id)
    bytes.TLDecode(addr self.file_part)
    bytes.TLDecode(addr self.file_total_parts)
    self.bytes = bytes.TLDecode()
method TLEncode*(self: UploadGetWebFile): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x24e6818d))
    result = result & TLEncode(self.location)
    result = result & TLEncode(self.offset)
    result = result & TLEncode(self.limit)
method TLDecode*(self: UploadGetWebFile, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.location = cast[InputWebFileLocationI](tempObj)
    bytes.TLDecode(addr self.offset)
    bytes.TLDecode(addr self.limit)
method TLEncode*(self: UploadGetCdnFile): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x2000bcc3))
    result = result & TLEncode(self.file_token)
    result = result & TLEncode(self.offset)
    result = result & TLEncode(self.limit)
method TLDecode*(self: UploadGetCdnFile, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.file_token = bytes.TLDecode()
    bytes.TLDecode(addr self.offset)
    bytes.TLDecode(addr self.limit)
method TLEncode*(self: UploadReuploadCdnFile): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x9b2754a8))
    result = result & TLEncode(self.file_token)
    result = result & TLEncode(self.request_token)
method TLDecode*(self: UploadReuploadCdnFile, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.file_token = bytes.TLDecode()
    self.request_token = bytes.TLDecode()
method TLEncode*(self: UploadGetCdnFileHashes): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x4da54231))
    result = result & TLEncode(self.file_token)
    result = result & TLEncode(self.offset)
method TLDecode*(self: UploadGetCdnFileHashes, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.file_token = bytes.TLDecode()
    bytes.TLDecode(addr self.offset)
method TLEncode*(self: UploadGetFileHashes): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc7025931))
    result = result & TLEncode(self.location)
    result = result & TLEncode(self.offset)
method TLDecode*(self: UploadGetFileHashes, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.location = cast[InputFileLocationI](tempObj)
    bytes.TLDecode(addr self.offset)
