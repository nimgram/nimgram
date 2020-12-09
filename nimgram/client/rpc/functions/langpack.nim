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

method TLEncode*(self: LangpackGetLangPack): seq[uint8] =
    result = TLEncode(uint32(4075959050))
    result = result & TLEncode(self.lang_pack)
    result = result & TLEncode(self.lang_code)
method TLDecode*(self: LangpackGetLangPack, bytes: var ScalingSeq[uint8]) = 
    self.lang_pack = cast[string](bytes.TLDecode())
    self.lang_code = cast[string](bytes.TLDecode())
method TLEncode*(self: LangpackGetStrings): seq[uint8] =
    result = TLEncode(uint32(4025104387))
    result = result & TLEncode(self.lang_pack)
    result = result & TLEncode(self.lang_code)
    result = result & TLEncode(cast[seq[TL]](self.keys))
method TLDecode*(self: LangpackGetStrings, bytes: var ScalingSeq[uint8]) = 
    self.lang_pack = cast[string](bytes.TLDecode())
    self.lang_code = cast[string](bytes.TLDecode())
    self.keys = cast[seq[string]](bytes.TLDecodeSeq())
method TLEncode*(self: LangpackGetDifference): seq[uint8] =
    result = TLEncode(uint32(3449309861))
    result = result & TLEncode(self.lang_pack)
    result = result & TLEncode(self.lang_code)
    result = result & TLEncode(self.from_version)
method TLDecode*(self: LangpackGetDifference, bytes: var ScalingSeq[uint8]) = 
    self.lang_pack = cast[string](bytes.TLDecode())
    self.lang_code = cast[string](bytes.TLDecode())
    bytes.TLDecode(addr self.from_version)
method TLEncode*(self: LangpackGetLanguages): seq[uint8] =
    result = TLEncode(uint32(1120311183))
    result = result & TLEncode(self.lang_pack)
method TLDecode*(self: LangpackGetLanguages, bytes: var ScalingSeq[uint8]) = 
    self.lang_pack = cast[string](bytes.TLDecode())
method TLEncode*(self: LangpackGetLanguage): seq[uint8] =
    result = TLEncode(uint32(1784243458))
    result = result & TLEncode(self.lang_pack)
    result = result & TLEncode(self.lang_code)
method TLDecode*(self: LangpackGetLanguage, bytes: var ScalingSeq[uint8]) = 
    self.lang_pack = cast[string](bytes.TLDecode())
    self.lang_code = cast[string](bytes.TLDecode())
