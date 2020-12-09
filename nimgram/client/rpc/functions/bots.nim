type
    BotsSendCustomRequest* = ref object of TLFunction
        custom_method*: string
        params*: DataJSONI
    BotsAnswerWebhookJSONQuery* = ref object of TLFunction
        query_id*: int64
        data*: DataJSONI
    BotsSetBotCommands* = ref object of TLFunction
        commands*: seq[BotCommandI]
method getTypeName*(self: BotsSendCustomRequest): string = "BotsSendCustomRequest"
method getTypeName*(self: BotsAnswerWebhookJSONQuery): string = "BotsAnswerWebhookJSONQuery"
method getTypeName*(self: BotsSetBotCommands): string = "BotsSetBotCommands"

method TLEncode*(self: BotsSendCustomRequest): seq[uint8] =
    result = TLEncode(uint32(2854709741))
    result = result & TLEncode(self.custom_method)
    result = result & TLEncode(self.params)
method TLDecode*(self: BotsSendCustomRequest, bytes: var ScalingSeq[uint8]) = 
    self.custom_method = cast[string](bytes.TLDecode())
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.params = cast[DataJSONI](tempObj)
method TLEncode*(self: BotsAnswerWebhookJSONQuery): seq[uint8] =
    result = TLEncode(uint32(3860938573))
    result = result & TLEncode(self.query_id)
    result = result & TLEncode(self.data)
method TLDecode*(self: BotsAnswerWebhookJSONQuery, bytes: var ScalingSeq[uint8]) = 
    bytes.TLDecode(addr self.query_id)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.data = cast[DataJSONI](tempObj)
method TLEncode*(self: BotsSetBotCommands): seq[uint8] =
    result = TLEncode(uint32(2153596662))
    result = result & TLEncode(cast[seq[TL]](self.commands))
method TLDecode*(self: BotsSetBotCommands, bytes: var ScalingSeq[uint8]) = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.commands = cast[seq[BotCommandI]](tempVector)
    tempVector.setLen(0)
