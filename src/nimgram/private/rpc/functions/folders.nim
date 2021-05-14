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
    FoldersEditPeerFolders* = ref object of TLFunction
        folder_peers*: seq[InputFolderPeerI]
    FoldersDeleteFolder* = ref object of TLFunction
        folder_id*: int32
method getTypeName*(self: FoldersEditPeerFolders): string = "FoldersEditPeerFolders"
method getTypeName*(self: FoldersDeleteFolder): string = "FoldersDeleteFolder"

method TLEncode*(self: FoldersEditPeerFolders): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x6847d0ab))
    result = result & TLEncode(cast[seq[TL]](self.folder_peers))
method TLDecode*(self: FoldersEditPeerFolders, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.folder_peers = cast[seq[InputFolderPeerI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: FoldersDeleteFolder): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x1c295881))
    result = result & TLEncode(self.folder_id)
method TLDecode*(self: FoldersDeleteFolder, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.folder_id)
