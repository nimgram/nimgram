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


type WebPage* = ref object of Media ## Webpage preview
    id*: int64                      ## Preview ID
    url*: string                    ## URL of previewed webpage
    startedDate*: Option[int32] ## Date when processing has started (Only for WebPagePending)
    displayUrl*: string             ## Webpage URL to be displayed to the user
    hash*: int32                    ## Hash for pagination
    `type`*: Option[string] ## Type of the web page. Can be: article, photo, audio, video, document, profile, app, or something else
    siteName*: Option[string]       ## Short name of the site (e.g., Google Docs, App Store)
    title*: Option[string]          ## Title of the content
    description*: Option[string]    ## Content description
    photo*: Option[Photo]           ## Image representing the content
    embedUrl*: Option[string]       ## URL to show in the embedded preview
    embedType*: Option[string] ## MIME type of the embedded preview, (e.g., text/html or video/mp4)
    embedWidth*: Option[int32]      ## Width of the embedded preview
    embedHeight*: Option[int32]     ## Height of the embedded preview
    duration*: Option[int32]        ## Duration of the content, in seconds
    document*: Option[Document]     ## Author of the content
                                    ##cachedPage*: Option[raw.Page] ## Page contents in instant view format WIP
                                    ##attributes*: Option[seq[raw.WebPageAttributeI]] ## Webpage attributes WIP


proc parse*(webpage: raw.WebPageI): Option[WebPage] =
    if webpage of WebPageEmpty:
        return some(WebPage(
            id: webpage.WebPageEmpty.id
        ))
    if webpage of WebPagePending:
        return some(WebPage(
            id: webpage.WebPagePending.id,
            startedDate: some(webpage.WebPagePending.date)
        ))
    if webpage of raw.WebPage:
        var webpageConverted = (raw.WebPage)(webpage)
        var tmpResult = WebPage()
        tmpResult.id = webpageConverted.id
        tmpResult.url = webpageConverted.url
        tmpResult.displayUrl = webpageConverted.display_url
        tmpResult.hash = webpageConverted.hash
        tmpResult.`type` = webpageConverted.`typeof`
        tmpResult.siteName = webpageConverted.site_name
        tmpResult.title = webpageConverted.title
        tmpResult.description = webpageConverted.description
        if webpageConverted.photo.isSome():
            if webpageConverted.photo.get() of raw.Photo:
                tmpResult.photo = some(parse((raw.Photo)(
                        webpageConverted.photo.get())))
        tmpResult.embedUrl = webpageConverted.embed_url
        tmpResult.embedType = webpageConverted.embed_type
        tmpResult.embedWidth = webpageConverted.embed_width
        tmpResult.embedHeight = webpageConverted.embed_height
        tmpResult.duration = webpageConverted.duration
        if tmpResult.document.isSome():
            if webpageConverted.document.get() of raw.Document:
                tmpResult.document = some(parse(cast[raw.Document](
                        tmpResult.document.get())))
