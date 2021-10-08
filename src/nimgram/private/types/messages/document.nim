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

type DocumentAttributes* = object
    height: Option[int32]        ## If a video or photo, the height of the content
    width: Option[int32]         ## If a video or photo, the width of the content
    animated: bool               ## If this document is an animation
    roundMessage: bool           ## If this document is a round message
    supportsStreaming: bool      ## If this document supports streaming (video)
    duration: int32              ## Duration of the document (video)
    voice: bool                  ## If audio, the file is a voice message
    title: Option[string]        ## If audio, title of the audio
    performer: Option[string]    ## If audio, performer of the audio
    waveform: Option[seq[uint8]] ## If audio, waveform of the audio
    filename: string             ## Name of the file
    hasStickers: bool            ## If the file has stickers


type Document* = ref object of Media       ## A document, NOT FULLY READY
    ttlSeconds*: Option[int32]             ## Time to live of self-destructing document
    ID*: int64                             ## ID of the photo
    accessHash*: int64                     ## Access hash
    fileReference*: seq[uint8]             ## File reference
    mimeType: string                       ## Mime Type
    size: int32                            ## Size of the file
    date*: int32                           ## Date of upload
    dcID*: int32                           ## DC ID to use for download
    documentAttributes: DocumentAttributes ## Attributes of the document

proc parse*(document: raw.Document): Document =
    result = new Document
    result.ID = document.id
    result.accessHash = document.access_hash
    result.fileReference = document.file_reference
    result.date = document.date
    result.dcID = document.dc_id
    for attribute in document.attributes:
        if attribute of DocumentAttributeImageSize:
            result.documentAttributes.height = some(
                    attribute.DocumentAttributeImageSize.h)
            result.documentAttributes.width = some(
                    attribute.DocumentAttributeImageSize.w)
        if attribute of DocumentAttributeAnimated:
            result.documentAttributes.animated = true
        if attribute of DocumentAttributeVideo:
            let video = attribute.DocumentAttributeVideo
            result.documentAttributes.roundMessage = video.round_message
            result.documentAttributes.supportsStreaming = video.supports_streaming
            result.documentAttributes.duration = video.duration
            result.documentAttributes.height = some(video.h)
            result.documentAttributes.width = some(video.w)
        if attribute of DocumentAttributeAudio:
            let audio = attribute.DocumentAttributeAudio
            result.documentAttributes.voice = audio.voice
            result.documentAttributes.duration = audio.duration
            result.documentAttributes.title = audio.title
            result.documentAttributes.performer = audio.performer
            result.documentAttributes.waveform = audio.waveform
        if attribute of DocumentAttributeFilename:
            result.documentAttributes.filename = attribute.DocumentAttributeFilename.filename
        if attribute of DocumentAttributeHasStickers:
            result.documentAttributes.hasStickers = true


proc parse*(document: raw.MessageMediaDocument): Option[Document] =
    if not document.document.isSome():
        return
    let documentInternal = document.document.get()
    if not(documentInternal of raw.Document):
        return
    var tempResult = parse((raw.Document)(documentInternal))
    tempResult.ttlSeconds = document.ttl_seconds

    result = some(tempResult)
