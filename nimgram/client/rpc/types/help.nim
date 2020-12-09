type
    HelpAppUpdate* = ref object of HelpAppUpdateI
        flags: int32
        can_not_skip*: bool
        id*: int32
        version*: string
        text*: string
        entities*: seq[MessageEntityI]
        document*: Option[DocumentI]
        url*: Option[string]
    HelpNoAppUpdate* = ref object of HelpAppUpdateI
    HelpInviteText* = ref object of HelpInviteTextI
        message*: string
    HelpSupport* = ref object of HelpSupportI
        phone_number*: string
        user*: UserI
    HelpTermsOfService* = ref object of HelpTermsOfServiceI
        flags: int32
        popup*: bool
        id*: DataJSONI
        text*: string
        entities*: seq[MessageEntityI]
        min_age_confirm*: Option[int32]
    HelpRecentMeUrls* = ref object of HelpRecentMeUrlsI
        urls*: seq[RecentMeUrlI]
        chats*: seq[ChatI]
        users*: seq[UserI]
    HelpTermsOfServiceUpdateEmpty* = ref object of HelpTermsOfServiceUpdateI
        expires*: int32
    HelpTermsOfServiceUpdate* = ref object of HelpTermsOfServiceUpdateI
        expires*: int32
        terms_of_service*: HelpTermsOfServiceI
    HelpDeepLinkInfoEmpty* = ref object of HelpDeepLinkInfoI
    HelpDeepLinkInfo* = ref object of HelpDeepLinkInfoI
        flags: int32
        update_app*: bool
        message*: string
        entities*: Option[seq[MessageEntityI]]
    HelpPassportConfigNotModified* = ref object of HelpPassportConfigI
    HelpPassportConfig* = ref object of HelpPassportConfigI
        hash*: int32
        countries_langs*: DataJSONI
    HelpSupportName* = ref object of HelpSupportNameI
        name*: string
    HelpUserInfoEmpty* = ref object of HelpUserInfoI
    HelpUserInfo* = ref object of HelpUserInfoI
        message*: string
        entities*: seq[MessageEntityI]
        author*: string
        date*: int32
    HelpPromoDataEmpty* = ref object of HelpPromoDataI
        expires*: int32
    HelpPromoData* = ref object of HelpPromoDataI
        flags: int32
        proxy*: bool
        expires*: int32
        peer*: PeerI
        chats*: seq[ChatI]
        users*: seq[UserI]
        psa_type*: Option[string]
        psa_message*: Option[string]
    HelpCountryCode* = ref object of HelpCountryCodeI
        flags: int32
        country_code*: string
        prefixes*: Option[seq[string]]
        patterns*: Option[seq[string]]
    HelpCountry* = ref object of HelpCountryI
        flags: int32
        hidden*: bool
        iso2*: string
        default_name*: string
        name*: Option[string]
        country_codes*: seq[HelpCountryCodeI]
    HelpCountriesListNotModified* = ref object of HelpCountriesListI
    HelpCountriesList* = ref object of HelpCountriesListI
        countries*: seq[HelpCountryI]
        hash*: int32
method getTypeName*(self: HelpAppUpdate): string = "HelpAppUpdate"
method getTypeName*(self: HelpNoAppUpdate): string = "HelpNoAppUpdate"
method getTypeName*(self: HelpInviteText): string = "HelpInviteText"
method getTypeName*(self: HelpSupport): string = "HelpSupport"
method getTypeName*(self: HelpTermsOfService): string = "HelpTermsOfService"
method getTypeName*(self: HelpRecentMeUrls): string = "HelpRecentMeUrls"
method getTypeName*(self: HelpTermsOfServiceUpdateEmpty): string = "HelpTermsOfServiceUpdateEmpty"
method getTypeName*(self: HelpTermsOfServiceUpdate): string = "HelpTermsOfServiceUpdate"
method getTypeName*(self: HelpDeepLinkInfoEmpty): string = "HelpDeepLinkInfoEmpty"
method getTypeName*(self: HelpDeepLinkInfo): string = "HelpDeepLinkInfo"
method getTypeName*(self: HelpPassportConfigNotModified): string = "HelpPassportConfigNotModified"
method getTypeName*(self: HelpPassportConfig): string = "HelpPassportConfig"
method getTypeName*(self: HelpSupportName): string = "HelpSupportName"
method getTypeName*(self: HelpUserInfoEmpty): string = "HelpUserInfoEmpty"
method getTypeName*(self: HelpUserInfo): string = "HelpUserInfo"
method getTypeName*(self: HelpPromoDataEmpty): string = "HelpPromoDataEmpty"
method getTypeName*(self: HelpPromoData): string = "HelpPromoData"
method getTypeName*(self: HelpCountryCode): string = "HelpCountryCode"
method getTypeName*(self: HelpCountry): string = "HelpCountry"
method getTypeName*(self: HelpCountriesListNotModified): string = "HelpCountriesListNotModified"
method getTypeName*(self: HelpCountriesList): string = "HelpCountriesList"

method TLEncode*(self: HelpAppUpdate): seq[uint8] =
    result = TLEncode(uint32(497489295))
    if self.can_not_skip:
        self.flags = self.flags or 1 shl 0
    if self.document.isSome():
        self.flags = self.flags or 1 shl 1
    if self.url.isSome():
        self.flags = self.flags or 1 shl 2
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.id)
    result = result & TLEncode(self.version)
    result = result & TLEncode(self.text)
    result = result & TLEncode(cast[seq[TL]](self.entities))
    if self.document.isSome():
        result = result & TLEncode(self.document.get())
    if self.url.isSome():
        result = result & TLEncode(self.url.get())
method TLDecode*(self: HelpAppUpdate, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.can_not_skip = true
    bytes.TLDecode(addr self.id)
    self.version = cast[string](bytes.TLDecode())
    self.text = cast[string](bytes.TLDecode())
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.entities = cast[seq[MessageEntityI]](tempVector)
    tempVector.setLen(0)
    if (self.flags and (1 shl 1)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.document = some(tempVal.DocumentI)
    if (self.flags and (1 shl 2)) != 0:
        self.url = some(cast[string](bytes.TLDecode()))
method TLEncode*(self: HelpNoAppUpdate): seq[uint8] =
    result = TLEncode(uint32(3294258486))
method TLDecode*(self: HelpNoAppUpdate, bytes: var ScalingSeq[uint8]) = 
    discard
method TLEncode*(self: HelpInviteText): seq[uint8] =
    result = TLEncode(uint32(415997816))
    result = result & TLEncode(self.message)
method TLDecode*(self: HelpInviteText, bytes: var ScalingSeq[uint8]) = 
    self.message = cast[string](bytes.TLDecode())
method TLEncode*(self: HelpSupport): seq[uint8] =
    result = TLEncode(uint32(398898678))
    result = result & TLEncode(self.phone_number)
    result = result & TLEncode(self.user)
method TLDecode*(self: HelpSupport, bytes: var ScalingSeq[uint8]) = 
    self.phone_number = cast[string](bytes.TLDecode())
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.user = cast[UserI](tempObj)
method TLEncode*(self: HelpTermsOfService): seq[uint8] =
    result = TLEncode(uint32(2013922064))
    if self.popup:
        self.flags = self.flags or 1 shl 0
    if self.min_age_confirm.isSome():
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.id)
    result = result & TLEncode(self.text)
    result = result & TLEncode(cast[seq[TL]](self.entities))
    if self.min_age_confirm.isSome():
        result = result & TLEncode(self.min_age_confirm.get())
method TLDecode*(self: HelpTermsOfService, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.popup = true
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.id = cast[DataJSONI](tempObj)
    self.text = cast[string](bytes.TLDecode())
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.entities = cast[seq[MessageEntityI]](tempVector)
    tempVector.setLen(0)
    if (self.flags and (1 shl 1)) != 0:
        var tempVal: int32 = 0
        bytes.TLDecode(addr tempVal)
        self.min_age_confirm = some(tempVal)
method TLEncode*(self: HelpRecentMeUrls): seq[uint8] =
    result = TLEncode(uint32(3761311088))
    result = result & TLEncode(cast[seq[TL]](self.urls))
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: HelpRecentMeUrls, bytes: var ScalingSeq[uint8]) = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.urls = cast[seq[RecentMeUrlI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: HelpTermsOfServiceUpdateEmpty): seq[uint8] =
    result = TLEncode(uint32(3811614591))
    result = result & TLEncode(self.expires)
method TLDecode*(self: HelpTermsOfServiceUpdateEmpty, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.expires)
method TLEncode*(self: HelpTermsOfServiceUpdate): seq[uint8] =
    result = TLEncode(uint32(686618977))
    result = result & TLEncode(self.expires)
    result = result & TLEncode(self.terms_of_service)
method TLDecode*(self: HelpTermsOfServiceUpdate, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.expires)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.terms_of_service = cast[HelpTermsOfServiceI](tempObj)
method TLEncode*(self: HelpDeepLinkInfoEmpty): seq[uint8] =
    result = TLEncode(uint32(1722786150))
method TLDecode*(self: HelpDeepLinkInfoEmpty, bytes: var ScalingSeq[uint8]) = 
    discard
method TLEncode*(self: HelpDeepLinkInfo): seq[uint8] =
    result = TLEncode(uint32(1783556146))
    if self.update_app:
        self.flags = self.flags or 1 shl 0
    if self.entities.isSome():
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.message)
    if self.entities.isSome():
        result = result & TLEncode(cast[seq[TL]](self.entities.get()))
method TLDecode*(self: HelpDeepLinkInfo, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.update_app = true
    self.message = cast[string](bytes.TLDecode())
    if (self.flags and (1 shl 1)) != 0:
        var tempVal = newSeq[TL]()
        tempVal.TLDecode(bytes)
        self.entities = some(cast[seq[MessageEntityI]](tempVal))
method TLEncode*(self: HelpPassportConfigNotModified): seq[uint8] =
    result = TLEncode(uint32(3216634967))
method TLDecode*(self: HelpPassportConfigNotModified, bytes: var ScalingSeq[uint8]) = 
    discard
method TLEncode*(self: HelpPassportConfig): seq[uint8] =
    result = TLEncode(uint32(2694370991))
    result = result & TLEncode(self.hash)
    result = result & TLEncode(self.countries_langs)
method TLDecode*(self: HelpPassportConfig, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.hash)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.countries_langs = cast[DataJSONI](tempObj)
method TLEncode*(self: HelpSupportName): seq[uint8] =
    result = TLEncode(uint32(2349199817))
    result = result & TLEncode(self.name)
method TLDecode*(self: HelpSupportName, bytes: var ScalingSeq[uint8]) = 
    self.name = cast[string](bytes.TLDecode())
method TLEncode*(self: HelpUserInfoEmpty): seq[uint8] =
    result = TLEncode(uint32(4088278765))
method TLDecode*(self: HelpUserInfoEmpty, bytes: var ScalingSeq[uint8]) = 
    discard
method TLEncode*(self: HelpUserInfo): seq[uint8] =
    result = TLEncode(uint32(515077504))
    result = result & TLEncode(self.message)
    result = result & TLEncode(cast[seq[TL]](self.entities))
    result = result & TLEncode(self.author)
    result = result & TLEncode(self.date)
method TLDecode*(self: HelpUserInfo, bytes: var ScalingSeq[uint8]) = 
    self.message = cast[string](bytes.TLDecode())
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.entities = cast[seq[MessageEntityI]](tempVector)
    tempVector.setLen(0)
    self.author = cast[string](bytes.TLDecode())
    bytes.TLDecode(addr self.date)
method TLEncode*(self: HelpPromoDataEmpty): seq[uint8] =
    result = TLEncode(uint32(2566302837))
    result = result & TLEncode(self.expires)
method TLDecode*(self: HelpPromoDataEmpty, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.expires)
method TLEncode*(self: HelpPromoData): seq[uint8] =
    result = TLEncode(uint32(2352576831))
    if self.proxy:
        self.flags = self.flags or 1 shl 0
    if self.psa_type.isSome():
        self.flags = self.flags or 1 shl 1
    if self.psa_message.isSome():
        self.flags = self.flags or 1 shl 2
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.expires)
    result = result & TLEncode(self.peer)
    result = result & TLEncode(cast[seq[TL]](self.chats))
    result = result & TLEncode(cast[seq[TL]](self.users))
    if self.psa_type.isSome():
        result = result & TLEncode(self.psa_type.get())
    if self.psa_message.isSome():
        result = result & TLEncode(self.psa_message.get())
method TLDecode*(self: HelpPromoData, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.proxy = true
    bytes.TLDecode(addr self.expires)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.peer = cast[PeerI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.chats = cast[seq[ChatI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
    if (self.flags and (1 shl 1)) != 0:
        self.psa_type = some(cast[string](bytes.TLDecode()))
    if (self.flags and (1 shl 2)) != 0:
        self.psa_message = some(cast[string](bytes.TLDecode()))
method TLEncode*(self: HelpCountryCode): seq[uint8] =
    result = TLEncode(uint32(1107543535))
    if self.prefixes.isSome():
        self.flags = self.flags or 1 shl 0
    if self.patterns.isSome():
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.country_code)
    if self.prefixes.isSome():
        result = result & TLEncode(cast[seq[TL]](self.prefixes.get()))
    if self.patterns.isSome():
        result = result & TLEncode(cast[seq[TL]](self.patterns.get()))
method TLDecode*(self: HelpCountryCode, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.flags)
    self.country_code = cast[string](bytes.TLDecode())
    if (self.flags and (1 shl 0)) != 0:
        self.prefixes = some(cast[seq[string]](bytes.TLDecodeSeq()))
    if (self.flags and (1 shl 1)) != 0:
        self.patterns = some(cast[seq[string]](bytes.TLDecodeSeq()))
method TLEncode*(self: HelpCountry): seq[uint8] =
    result = TLEncode(uint32(3280440867))
    if self.hidden:
        self.flags = self.flags or 1 shl 0
    if self.name.isSome():
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.iso2)
    result = result & TLEncode(self.default_name)
    if self.name.isSome():
        result = result & TLEncode(self.name.get())
    result = result & TLEncode(cast[seq[TL]](self.country_codes))
method TLDecode*(self: HelpCountry, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.hidden = true
    self.iso2 = cast[string](bytes.TLDecode())
    self.default_name = cast[string](bytes.TLDecode())
    if (self.flags and (1 shl 1)) != 0:
        self.name = some(cast[string](bytes.TLDecode()))
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.country_codes = cast[seq[HelpCountryCodeI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: HelpCountriesListNotModified): seq[uint8] =
    result = TLEncode(uint32(2479628082))
method TLDecode*(self: HelpCountriesListNotModified, bytes: var ScalingSeq[uint8]) = 
    discard
method TLEncode*(self: HelpCountriesList): seq[uint8] =
    result = TLEncode(uint32(2278585758))
    result = result & TLEncode(cast[seq[TL]](self.countries))
    result = result & TLEncode(self.hash)
method TLDecode*(self: HelpCountriesList, bytes: var ScalingSeq[uint8]) = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.countries = cast[seq[HelpCountryI]](tempVector)
    tempVector.setLen(0)
    bytes.TLDecode(addr self.hash)
