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

method TLEncode*(self: UploadFile): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x96a18d5))
    result = result & TLEncode(self.typeof)
    result = result & TLEncode(self.mtime)
    result = result & TLEncode(self.bytes)
method TLDecode*(self: UploadFile, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.typeof = cast[StorageFileTypeI](tempObj)
    bytes.TLDecode(addr self.mtime)
    self.bytes = bytes.TLDecode()
method TLEncode*(self: UploadFileCdnRedirect): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf18cda44))
    result = result & TLEncode(self.dc_id)
    result = result & TLEncode(self.file_token)
    result = result & TLEncode(self.encryption_key)
    result = result & TLEncode(self.encryption_iv)
    result = result & TLEncode(cast[seq[TL]](self.file_hashes))
method TLDecode*(self: UploadFileCdnRedirect, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.dc_id)
    self.file_token = bytes.TLDecode()
    self.encryption_key = bytes.TLDecode()
    self.encryption_iv = bytes.TLDecode()
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.file_hashes = cast[seq[FileHashI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: UploadWebFile): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x21e753bc))
    result = result & TLEncode(self.size)
    result = result & TLEncode(self.mime_type)
    result = result & TLEncode(self.file_type)
    result = result & TLEncode(self.mtime)
    result = result & TLEncode(self.bytes)
method TLDecode*(self: UploadWebFile, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.size)
    self.mime_type = cast[string](bytes.TLDecode())
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.file_type = cast[StorageFileTypeI](tempObj)
    bytes.TLDecode(addr self.mtime)
    self.bytes = bytes.TLDecode()
method TLEncode*(self: UploadCdnFileReuploadNeeded): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xeea8e46e))
    result = result & TLEncode(self.request_token)
method TLDecode*(self: UploadCdnFileReuploadNeeded, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.request_token = bytes.TLDecode()
method TLEncode*(self: UploadCdnFile): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xa99fca4f))
    result = result & TLEncode(self.bytes)
method TLDecode*(self: UploadCdnFile, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.bytes = bytes.TLDecode()
