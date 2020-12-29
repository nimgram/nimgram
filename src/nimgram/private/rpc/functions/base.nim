include stickers, auth, langpack, photos, bots, account, users, stats, help, messages, payments, phone, folders, contacts, updates, channels, upload
type
    InvokeAfterMsg* = ref object of TLFunction
        msg_id*: int64
        query*: TL
    InvokeAfterMsgs* = ref object of TLFunction
        msg_ids*: seq[int64]
        query*: TL
    InitConnection* = ref object of TLFunction
        flags: int32
        api_id*: int32
        device_model*: string
        system_version*: string
        app_version*: string
        system_lang_code*: string
        lang_pack*: string
        lang_code*: string
        proxy*: Option[InputClientProxyI]
        params*: Option[JSONValueI]
        query*: TL
    InvokeWithLayer* = ref object of TLFunction
        layer*: int32
        query*: TL
    InvokeWithoutUpdates* = ref object of TLFunction
        query*: TL
    InvokeWithMessagesRange* = ref object of TLFunction
        range*: MessageRangeI
        query*: TL
    InvokeWithTakeout* = ref object of TLFunction
        takeout_id*: int64
        query*: TL
method getTypeName*(self: InvokeAfterMsg): string = "InvokeAfterMsg"
method getTypeName*(self: InvokeAfterMsgs): string = "InvokeAfterMsgs"
method getTypeName*(self: InitConnection): string = "InitConnection"
method getTypeName*(self: InvokeWithLayer): string = "InvokeWithLayer"
method getTypeName*(self: InvokeWithoutUpdates): string = "InvokeWithoutUpdates"
method getTypeName*(self: InvokeWithMessagesRange): string = "InvokeWithMessagesRange"
method getTypeName*(self: InvokeWithTakeout): string = "InvokeWithTakeout"

method TLEncode*(self: InvokeAfterMsg): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xcb9f372d))
    result = result & TLEncode(self.msg_id)
    result = result & TLEncode(self.query)
method TLDecode*(self: InvokeAfterMsg, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.msg_id)
    self.query.TLDecode(bytes)
method TLEncode*(self: InvokeAfterMsgs): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x3dc4b4f0))
    result = result & TLEncode(self.msg_ids)
    result = result & TLEncode(self.query)
method TLDecode*(self: InvokeAfterMsgs, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(self.msg_ids)
    self.query.TLDecode(bytes)
method TLEncode*(self: InitConnection): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xc1cd5ea9))
    if self.proxy.isSome():
        self.flags = self.flags or 1 shl 0
    if self.params.isSome():
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.api_id)
    result = result & TLEncode(self.device_model)
    result = result & TLEncode(self.system_version)
    result = result & TLEncode(self.app_version)
    result = result & TLEncode(self.system_lang_code)
    result = result & TLEncode(self.lang_pack)
    result = result & TLEncode(self.lang_code)
    if self.proxy.isSome():
        result = result & TLEncode(self.proxy.get())
    if self.params.isSome():
        result = result & TLEncode(self.params.get())
    result = result & TLEncode(self.query)
method TLDecode*(self: InitConnection, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    bytes.TLDecode(addr self.api_id)
    self.device_model = cast[string](bytes.TLDecode())
    self.system_version = cast[string](bytes.TLDecode())
    self.app_version = cast[string](bytes.TLDecode())
    self.system_lang_code = cast[string](bytes.TLDecode())
    self.lang_pack = cast[string](bytes.TLDecode())
    self.lang_code = cast[string](bytes.TLDecode())
    if (self.flags and (1 shl 0)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.proxy = some(tempVal.InputClientProxyI)
    if (self.flags and (1 shl 1)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.params = some(tempVal.JSONValueI)
    self.query.TLDecode(bytes)
method TLEncode*(self: InvokeWithLayer): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xda9b0d0d))
    result = result & TLEncode(self.layer)
    result = result & TLEncode(self.query)
method TLDecode*(self: InvokeWithLayer, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.layer)
    self.query.TLDecode(bytes)
method TLEncode*(self: InvokeWithoutUpdates): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xbf9459b7))
    result = result & TLEncode(self.query)
method TLDecode*(self: InvokeWithoutUpdates, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.query.TLDecode(bytes)
method TLEncode*(self: InvokeWithMessagesRange): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x365275f2))
    result = result & TLEncode(self.range)
    result = result & TLEncode(self.query)
method TLDecode*(self: InvokeWithMessagesRange, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.range = cast[MessageRangeI](tempObj)
    self.query.TLDecode(bytes)
method TLEncode*(self: InvokeWithTakeout): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xaca9fd2e))
    result = result & TLEncode(self.takeout_id)
    result = result & TLEncode(self.query)
method TLDecode*(self: InvokeWithTakeout, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.takeout_id)
    self.query.TLDecode(bytes)
