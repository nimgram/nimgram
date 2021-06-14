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

type Document* = ref object of Media ## A document, NOT FULLY READY
    ttlSeconds*: Option[int32] ## Time to live of self-destructing document
    ID*: int64 ## ID of the photo
    accessHash*: int64 ## Access hash
    fileReference*: seq[uint8] ## File reference
    date*: int32 ## Date of upload
    dcID*: int32 ## DC ID to use for download

proc parse*(document: raw.MessageMediaDocument): Option[Document] =
    if not document.document.isSome():
        return
    let documentInternal = document.document.get()
    if not(documentInternal of raw.Document):
        return
    let docExtracted = cast[raw.Document](documentInternal)
    var tempResult = new Document
    tempResult.ttlSeconds = document.ttl_seconds
    tempResult.ID = docExtracted.id
    tempResult.accessHash = docExtracted.access_hash
    tempResult.fileReference = docExtracted.file_reference
    tempResult.date = docExtracted.date
    tempResult.dcID = docExtracted.dc_id
    
    result = some(tempResult)