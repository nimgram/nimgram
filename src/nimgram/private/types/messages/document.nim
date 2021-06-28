# Nimgram
# Copyright (C) 2020-2021 Daniele Cortesi <https://github.com/dadadani>
# This file is part of Nimgram, under the MIT License
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY
# OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

type Document* = ref object of Media ## A document, NOT FULLY READY
    ttlSeconds*: Option[int32] ## Time to live of self-destructing document
    ID*: int64 ## ID of the photo
    accessHash*: int64 ## Access hash
    fileReference*: seq[uint8] ## File reference
    date*: int32 ## Date of upload
    dcID*: int32 ## DC ID to use for download

proc parse*(document: raw.Document): Document = 
    result = new Document
    result.ID = document.id
    result.accessHash = document.access_hash
    result.fileReference = document.file_reference
    result.date = document.date
    result.dcID = document.dc_id

proc parse*(document: raw.MessageMediaDocument): Option[Document] =
    if not document.document.isSome():
        return
    let documentInternal = document.document.get()
    if not(documentInternal of raw.Document):
        return  
    var tempResult = parse(cast[raw.Document](documentInternal))
    tempResult.ttlSeconds = document.ttl_seconds

    result = some(tempResult)
    