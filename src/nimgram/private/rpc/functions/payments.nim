type
    PaymentsGetPaymentForm* = ref object of TLFunction
        msg_id*: int32
    PaymentsGetPaymentReceipt* = ref object of TLFunction
        msg_id*: int32
    PaymentsValidateRequestedInfo* = ref object of TLFunction
        flags: int32
        save*: bool
        msg_id*: int32
        info*: PaymentRequestedInfoI
    PaymentsSendPaymentForm* = ref object of TLFunction
        flags: int32
        msg_id*: int32
        requested_info_id*: Option[string]
        shipping_option_id*: Option[string]
        credentials*: InputPaymentCredentialsI
    PaymentsGetSavedInfo* = ref object of TLFunction
    PaymentsClearSavedInfo* = ref object of TLFunction
        flags: int32
        credentials*: bool
        info*: bool
    PaymentsGetBankCardData* = ref object of TLFunction
        number*: string
method getTypeName*(self: PaymentsGetPaymentForm): string = "PaymentsGetPaymentForm"
method getTypeName*(self: PaymentsGetPaymentReceipt): string = "PaymentsGetPaymentReceipt"
method getTypeName*(self: PaymentsValidateRequestedInfo): string = "PaymentsValidateRequestedInfo"
method getTypeName*(self: PaymentsSendPaymentForm): string = "PaymentsSendPaymentForm"
method getTypeName*(self: PaymentsGetSavedInfo): string = "PaymentsGetSavedInfo"
method getTypeName*(self: PaymentsClearSavedInfo): string = "PaymentsClearSavedInfo"
method getTypeName*(self: PaymentsGetBankCardData): string = "PaymentsGetBankCardData"

method TLEncode*(self: PaymentsGetPaymentForm): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x99f09745))
    result = result & TLEncode(self.msg_id)
method TLDecode*(self: PaymentsGetPaymentForm, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.msg_id)
method TLEncode*(self: PaymentsGetPaymentReceipt): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xa092a980))
    result = result & TLEncode(self.msg_id)
method TLDecode*(self: PaymentsGetPaymentReceipt, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.msg_id)
method TLEncode*(self: PaymentsValidateRequestedInfo): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x770a8e74))
    if self.save:
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.msg_id)
    result = result & TLEncode(self.info)
method TLDecode*(self: PaymentsValidateRequestedInfo, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.save = true
    bytes.TLDecode(addr self.msg_id)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.info = cast[PaymentRequestedInfoI](tempObj)
method TLEncode*(self: PaymentsSendPaymentForm): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x2b8879b3))
    if self.requested_info_id.isSome():
        self.flags = self.flags or 1 shl 0
    if self.shipping_option_id.isSome():
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.msg_id)
    if self.requested_info_id.isSome():
        result = result & TLEncode(self.requested_info_id.get())
    if self.shipping_option_id.isSome():
        result = result & TLEncode(self.shipping_option_id.get())
    result = result & TLEncode(self.credentials)
method TLDecode*(self: PaymentsSendPaymentForm, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    bytes.TLDecode(addr self.msg_id)
    if (self.flags and (1 shl 0)) != 0:
        self.requested_info_id = some(cast[string](bytes.TLDecode()))
    if (self.flags and (1 shl 1)) != 0:
        self.shipping_option_id = some(cast[string](bytes.TLDecode()))
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.credentials = cast[InputPaymentCredentialsI](tempObj)
method TLEncode*(self: PaymentsGetSavedInfo): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x227d824b))
method TLDecode*(self: PaymentsGetSavedInfo, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    discard
method TLEncode*(self: PaymentsClearSavedInfo): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xd83d70c1))
    if self.credentials:
        self.flags = self.flags or 1 shl 0
    if self.info:
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
method TLDecode*(self: PaymentsClearSavedInfo, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.credentials = true
    if (self.flags and (1 shl 1)) != 0:
        self.info = true
method TLEncode*(self: PaymentsGetBankCardData): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x2e79d779))
    result = result & TLEncode(self.number)
method TLDecode*(self: PaymentsGetBankCardData, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.number = cast[string](bytes.TLDecode())
