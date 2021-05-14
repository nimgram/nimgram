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
    UsersGetUsers* = ref object of TLFunction
        id*: seq[InputUserI]
    UsersGetFullUser* = ref object of TLFunction
        id*: InputUserI
    UsersSetSecureValueErrors* = ref object of TLFunction
        id*: InputUserI
        errors*: seq[SecureValueErrorI]
method getTypeName*(self: UsersGetUsers): string = "UsersGetUsers"
method getTypeName*(self: UsersGetFullUser): string = "UsersGetFullUser"
method getTypeName*(self: UsersSetSecureValueErrors): string = "UsersSetSecureValueErrors"

method TLEncode*(self: UsersGetUsers): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xd91a548))
    result = result & TLEncode(cast[seq[TL]](self.id))
method TLDecode*(self: UsersGetUsers, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.id = cast[seq[InputUserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: UsersGetFullUser): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xca30a5b1))
    result = result & TLEncode(self.id)
method TLDecode*(self: UsersGetFullUser, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.id = cast[InputUserI](tempObj)
method TLEncode*(self: UsersSetSecureValueErrors): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x90c894b5))
    result = result & TLEncode(self.id)
    result = result & TLEncode(cast[seq[TL]](self.errors))
method TLDecode*(self: UsersSetSecureValueErrors, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.id = cast[InputUserI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.errors = cast[seq[SecureValueErrorI]](tempVector)
    tempVector.setLen(0)
