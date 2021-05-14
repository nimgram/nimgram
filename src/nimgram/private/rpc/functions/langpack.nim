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
    LangpackGetLangPack* = ref object of TLFunction
        lang_pack*: string
        lang_code*: string
    LangpackGetStrings* = ref object of TLFunction
        lang_pack*: string
        lang_code*: string
        keys*: seq[string]
    LangpackGetDifference* = ref object of TLFunction
        lang_pack*: string
        lang_code*: string
        from_version*: int32
    LangpackGetLanguages* = ref object of TLFunction
        lang_pack*: string
    LangpackGetLanguage* = ref object of TLFunction
        lang_pack*: string
        lang_code*: string
method getTypeName*(self: LangpackGetLangPack): string = "LangpackGetLangPack"
method getTypeName*(self: LangpackGetStrings): string = "LangpackGetStrings"
method getTypeName*(self: LangpackGetDifference): string = "LangpackGetDifference"
method getTypeName*(self: LangpackGetLanguages): string = "LangpackGetLanguages"
method getTypeName*(self: LangpackGetLanguage): string = "LangpackGetLanguage"

method TLEncode*(self: LangpackGetLangPack): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf2f2330a))
    result = result & TLEncode(self.lang_pack)
    result = result & TLEncode(self.lang_code)
method TLDecode*(self: LangpackGetLangPack, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.lang_pack = cast[string](bytes.TLDecode())
    self.lang_code = cast[string](bytes.TLDecode())
method TLEncode*(self: LangpackGetStrings): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xefea3803))
    result = result & TLEncode(self.lang_pack)
    result = result & TLEncode(self.lang_code)
    result = result & TLEncode(cast[seq[TL]](self.keys))
method TLDecode*(self: LangpackGetStrings, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.lang_pack = cast[string](bytes.TLDecode())
    self.lang_code = cast[string](bytes.TLDecode())
    self.keys = cast[seq[string]](bytes.TLDecodeSeq())
method TLEncode*(self: LangpackGetDifference): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xcd984aa5))
    result = result & TLEncode(self.lang_pack)
    result = result & TLEncode(self.lang_code)
    result = result & TLEncode(self.from_version)
method TLDecode*(self: LangpackGetDifference, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.lang_pack = cast[string](bytes.TLDecode())
    self.lang_code = cast[string](bytes.TLDecode())
    bytes.TLDecode(addr self.from_version)
method TLEncode*(self: LangpackGetLanguages): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x42c6978f))
    result = result & TLEncode(self.lang_pack)
method TLDecode*(self: LangpackGetLanguages, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.lang_pack = cast[string](bytes.TLDecode())
method TLEncode*(self: LangpackGetLanguage): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x6a596502))
    result = result & TLEncode(self.lang_pack)
    result = result & TLEncode(self.lang_code)
method TLDecode*(self: LangpackGetLanguage, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.lang_pack = cast[string](bytes.TLDecode())
    self.lang_code = cast[string](bytes.TLDecode())
