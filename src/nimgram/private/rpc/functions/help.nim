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
    HelpGetConfig* = ref object of TLFunction
    HelpGetNearestDc* = ref object of TLFunction
    HelpGetAppUpdate* = ref object of TLFunction
        source*: string
    HelpGetInviteText* = ref object of TLFunction
    HelpGetSupport* = ref object of TLFunction
    HelpGetAppChangelog* = ref object of TLFunction
        prev_app_version*: string
    HelpSetBotUpdatesStatus* = ref object of TLFunction
        pending_updates_count*: int32
        message*: string
    HelpGetCdnConfig* = ref object of TLFunction
    HelpGetRecentMeUrls* = ref object of TLFunction
        referer*: string
    HelpGetTermsOfServiceUpdate* = ref object of TLFunction
    HelpAcceptTermsOfService* = ref object of TLFunction
        id*: DataJSONI
    HelpGetDeepLinkInfo* = ref object of TLFunction
        path*: string
    HelpGetAppConfig* = ref object of TLFunction
    HelpSaveAppLog* = ref object of TLFunction
        events*: seq[InputAppEventI]
    HelpGetPassportConfig* = ref object of TLFunction
        hash*: int32
    HelpGetSupportName* = ref object of TLFunction
    HelpGetUserInfo* = ref object of TLFunction
        user_id*: InputUserI
    HelpEditUserInfo* = ref object of TLFunction
        user_id*: InputUserI
        message*: string
        entities*: seq[MessageEntityI]
    HelpGetPromoData* = ref object of TLFunction
    HelpHidePromoData* = ref object of TLFunction
        peer*: InputPeerI
    HelpDismissSuggestion* = ref object of TLFunction
        peer*: InputPeerI
        suggestion*: string
    HelpGetCountriesList* = ref object of TLFunction
        lang_code*: string
        hash*: int32
method getTypeName*(self: HelpGetConfig): string = "HelpGetConfig"
method getTypeName*(self: HelpGetNearestDc): string = "HelpGetNearestDc"
method getTypeName*(self: HelpGetAppUpdate): string = "HelpGetAppUpdate"
method getTypeName*(self: HelpGetInviteText): string = "HelpGetInviteText"
method getTypeName*(self: HelpGetSupport): string = "HelpGetSupport"
method getTypeName*(self: HelpGetAppChangelog): string = "HelpGetAppChangelog"
method getTypeName*(self: HelpSetBotUpdatesStatus): string = "HelpSetBotUpdatesStatus"
method getTypeName*(self: HelpGetCdnConfig): string = "HelpGetCdnConfig"
method getTypeName*(self: HelpGetRecentMeUrls): string = "HelpGetRecentMeUrls"
method getTypeName*(self: HelpGetTermsOfServiceUpdate): string = "HelpGetTermsOfServiceUpdate"
method getTypeName*(self: HelpAcceptTermsOfService): string = "HelpAcceptTermsOfService"
method getTypeName*(self: HelpGetDeepLinkInfo): string = "HelpGetDeepLinkInfo"
method getTypeName*(self: HelpGetAppConfig): string = "HelpGetAppConfig"
method getTypeName*(self: HelpSaveAppLog): string = "HelpSaveAppLog"
method getTypeName*(self: HelpGetPassportConfig): string = "HelpGetPassportConfig"
method getTypeName*(self: HelpGetSupportName): string = "HelpGetSupportName"
method getTypeName*(self: HelpGetUserInfo): string = "HelpGetUserInfo"
method getTypeName*(self: HelpEditUserInfo): string = "HelpEditUserInfo"
method getTypeName*(self: HelpGetPromoData): string = "HelpGetPromoData"
method getTypeName*(self: HelpHidePromoData): string = "HelpHidePromoData"
method getTypeName*(self: HelpDismissSuggestion): string = "HelpDismissSuggestion"
method getTypeName*(self: HelpGetCountriesList): string = "HelpGetCountriesList"

method TLEncode*(self: HelpGetConfig): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc4f9186b))
method TLDecode*(self: HelpGetConfig, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: HelpGetNearestDc): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x1fb33026))
method TLDecode*(self: HelpGetNearestDc, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: HelpGetAppUpdate): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x522d5a7d))
    result = result & TLEncode(self.source)
method TLDecode*(self: HelpGetAppUpdate, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.source = cast[string](bytes.TLDecode())
method TLEncode*(self: HelpGetInviteText): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x4d392343))
method TLDecode*(self: HelpGetInviteText, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: HelpGetSupport): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x9cdf08cd))
method TLDecode*(self: HelpGetSupport, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: HelpGetAppChangelog): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x9010ef6f))
    result = result & TLEncode(self.prev_app_version)
method TLDecode*(self: HelpGetAppChangelog, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.prev_app_version = cast[string](bytes.TLDecode())
method TLEncode*(self: HelpSetBotUpdatesStatus): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xec22cfcd))
    result = result & TLEncode(self.pending_updates_count)
    result = result & TLEncode(self.message)
method TLDecode*(self: HelpSetBotUpdatesStatus, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.pending_updates_count)
    self.message = cast[string](bytes.TLDecode())
method TLEncode*(self: HelpGetCdnConfig): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x52029342))
method TLDecode*(self: HelpGetCdnConfig, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: HelpGetRecentMeUrls): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x3dc0f114))
    result = result & TLEncode(self.referer)
method TLDecode*(self: HelpGetRecentMeUrls, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.referer = cast[string](bytes.TLDecode())
method TLEncode*(self: HelpGetTermsOfServiceUpdate): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x2ca51fd1))
method TLDecode*(self: HelpGetTermsOfServiceUpdate, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: HelpAcceptTermsOfService): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xee72f79a))
    result = result & TLEncode(self.id)
method TLDecode*(self: HelpAcceptTermsOfService, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.id = cast[DataJSONI](tempObj)
method TLEncode*(self: HelpGetDeepLinkInfo): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x3fedc75f))
    result = result & TLEncode(self.path)
method TLDecode*(self: HelpGetDeepLinkInfo, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.path = cast[string](bytes.TLDecode())
method TLEncode*(self: HelpGetAppConfig): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x98914110))
method TLDecode*(self: HelpGetAppConfig, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: HelpSaveAppLog): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x6f02f748))
    result = result & TLEncode(cast[seq[TL]](self.events))
method TLDecode*(self: HelpSaveAppLog, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.events = cast[seq[InputAppEventI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: HelpGetPassportConfig): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc661ad08))
    result = result & TLEncode(self.hash)
method TLDecode*(self: HelpGetPassportConfig, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.hash)
method TLEncode*(self: HelpGetSupportName): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xd360e72c))
method TLDecode*(self: HelpGetSupportName, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: HelpGetUserInfo): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x38a08d3))
    result = result & TLEncode(self.user_id)
method TLDecode*(self: HelpGetUserInfo, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.user_id = cast[InputUserI](tempObj)
method TLEncode*(self: HelpEditUserInfo): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x66b91b70))
    result = result & TLEncode(self.user_id)
    result = result & TLEncode(self.message)
    result = result & TLEncode(cast[seq[TL]](self.entities))
method TLDecode*(self: HelpEditUserInfo, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.user_id = cast[InputUserI](tempObj)
    self.message = cast[string](bytes.TLDecode())
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.entities = cast[seq[MessageEntityI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: HelpGetPromoData): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc0977421))
method TLDecode*(self: HelpGetPromoData, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: HelpHidePromoData): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x1e251c95))
    result = result & TLEncode(self.peer)
method TLDecode*(self: HelpHidePromoData, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
method TLEncode*(self: HelpDismissSuggestion): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xf50dbaa1))
    result = result & TLEncode(self.peer)
    result = result & TLEncode(self.suggestion)
method TLDecode*(self: HelpDismissSuggestion, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[InputPeerI](tempObj)
    self.suggestion = cast[string](bytes.TLDecode())
method TLEncode*(self: HelpGetCountriesList): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x735787a8))
    result = result & TLEncode(self.lang_code)
    result = result & TLEncode(self.hash)
method TLDecode*(self: HelpGetCountriesList, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.lang_code = cast[string](bytes.TLDecode())
    bytes.TLDecode(addr self.hash)
