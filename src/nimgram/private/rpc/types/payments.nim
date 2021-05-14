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
    PaymentsPaymentForm* = ref object of PaymentsPaymentFormI
        flags: int32
        can_save_credentials*: bool
        password_missing*: bool
        bot_id*: int32
        invoice*: InvoiceI
        provider_id*: int32
        url*: string
        native_provider*: Option[string]
        native_params*: Option[DataJSONI]
        saved_info*: Option[PaymentRequestedInfoI]
        saved_credentials*: Option[PaymentSavedCredentialsI]
        users*: seq[UserI]
    PaymentsValidatedRequestedInfo* = ref object of PaymentsValidatedRequestedInfoI
        flags: int32
        id*: Option[string]
        shipping_options*: Option[seq[ShippingOptionI]]
    PaymentsPaymentResult* = ref object of PaymentsPaymentResultI
        updates*: UpdatesI
    PaymentsPaymentVerificationNeeded* = ref object of PaymentsPaymentResultI
        url*: string
    PaymentsPaymentReceipt* = ref object of PaymentsPaymentReceiptI
        flags: int32
        date*: int32
        bot_id*: int32
        invoice*: InvoiceI
        provider_id*: int32
        info*: Option[PaymentRequestedInfoI]
        shipping*: Option[ShippingOptionI]
        currency*: string
        total_amount*: int64
        credentials_title*: string
        users*: seq[UserI]
    PaymentsSavedInfo* = ref object of PaymentsSavedInfoI
        flags: int32
        has_saved_credentials*: bool
        saved_info*: Option[PaymentRequestedInfoI]
    PaymentsBankCardData* = ref object of PaymentsBankCardDataI
        title*: string
        open_urls*: seq[BankCardOpenUrlI]
method getTypeName*(self: PaymentsPaymentForm): string = "PaymentsPaymentForm"
method getTypeName*(self: PaymentsValidatedRequestedInfo): string = "PaymentsValidatedRequestedInfo"
method getTypeName*(self: PaymentsPaymentResult): string = "PaymentsPaymentResult"
method getTypeName*(self: PaymentsPaymentVerificationNeeded): string = "PaymentsPaymentVerificationNeeded"
method getTypeName*(self: PaymentsPaymentReceipt): string = "PaymentsPaymentReceipt"
method getTypeName*(self: PaymentsSavedInfo): string = "PaymentsSavedInfo"
method getTypeName*(self: PaymentsBankCardData): string = "PaymentsBankCardData"

method TLEncode*(self: PaymentsPaymentForm): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x3f56aea3))
    if self.can_save_credentials:
        self.flags = self.flags or 1 shl 2
    if self.password_missing:
        self.flags = self.flags or 1 shl 3
    if self.native_provider.isSome():
        self.flags = self.flags or 1 shl 4
    if self.native_params.isSome():
        self.flags = self.flags or 1 shl 4
    if self.saved_info.isSome():
        self.flags = self.flags or 1 shl 0
    if self.saved_credentials.isSome():
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.bot_id)
    result = result & TLEncode(self.invoice)
    result = result & TLEncode(self.provider_id)
    result = result & TLEncode(self.url)
    if self.native_provider.isSome():
        result = result & TLEncode(self.native_provider.get())
    if self.native_params.isSome():
        result = result & TLEncode(self.native_params.get())
    if self.saved_info.isSome():
        result = result & TLEncode(self.saved_info.get())
    if self.saved_credentials.isSome():
        result = result & TLEncode(self.saved_credentials.get())
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: PaymentsPaymentForm, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 2)) != 0:
        self.can_save_credentials = true
    if (self.flags and (1 shl 3)) != 0:
        self.password_missing = true
    bytes.TLDecode(addr self.bot_id)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.invoice = cast[InvoiceI](tempObj)
    bytes.TLDecode(addr self.provider_id)
    self.url = cast[string](bytes.TLDecode())
    if (self.flags and (1 shl 4)) != 0:
        self.native_provider = some(cast[string](bytes.TLDecode()))
    if (self.flags and (1 shl 4)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.native_params = some(tempVal.DataJSONI)
    if (self.flags and (1 shl 0)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.saved_info = some(tempVal.PaymentRequestedInfoI)
    if (self.flags and (1 shl 1)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.saved_credentials = some(tempVal.PaymentSavedCredentialsI)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: PaymentsValidatedRequestedInfo): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xd1451883))
    if self.id.isSome():
        self.flags = self.flags or 1 shl 0
    if self.shipping_options.isSome():
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    if self.id.isSome():
        result = result & TLEncode(self.id.get())
    if self.shipping_options.isSome():
        result = result & TLEncode(cast[seq[TL]](self.shipping_options.get()))
method TLDecode*(self: PaymentsValidatedRequestedInfo, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 0)) != 0:
        self.id = some(cast[string](bytes.TLDecode()))
    if (self.flags and (1 shl 1)) != 0:
        var tempVal = newSeq[TL]()
        tempVal.TLDecode(bytes)
        self.shipping_options = some(cast[seq[ShippingOptionI]](tempVal))
method TLEncode*(self: PaymentsPaymentResult): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x4e5f810d))
    result = result & TLEncode(self.updates)
method TLDecode*(self: PaymentsPaymentResult, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.updates = cast[UpdatesI](tempObj)
method TLEncode*(self: PaymentsPaymentVerificationNeeded): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xd8411139))
    result = result & TLEncode(self.url)
method TLDecode*(self: PaymentsPaymentVerificationNeeded, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.url = cast[string](bytes.TLDecode())
method TLEncode*(self: PaymentsPaymentReceipt): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x500911e1))
    if self.info.isSome():
        self.flags = self.flags or 1 shl 0
    if self.shipping.isSome():
        self.flags = self.flags or 1 shl 1
    result = result & TLEncode(self.flags)
    result = result & TLEncode(self.date)
    result = result & TLEncode(self.bot_id)
    result = result & TLEncode(self.invoice)
    result = result & TLEncode(self.provider_id)
    if self.info.isSome():
        result = result & TLEncode(self.info.get())
    if self.shipping.isSome():
        result = result & TLEncode(self.shipping.get())
    result = result & TLEncode(self.currency)
    result = result & TLEncode(self.total_amount)
    result = result & TLEncode(self.credentials_title)
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: PaymentsPaymentReceipt, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    bytes.TLDecode(addr self.date)
    bytes.TLDecode(addr self.bot_id)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.invoice = cast[InvoiceI](tempObj)
    bytes.TLDecode(addr self.provider_id)
    if (self.flags and (1 shl 0)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.info = some(tempVal.PaymentRequestedInfoI)
    if (self.flags and (1 shl 1)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.shipping = some(tempVal.ShippingOptionI)
    self.currency = cast[string](bytes.TLDecode())
    bytes.TLDecode(addr self.total_amount)
    self.credentials_title = cast[string](bytes.TLDecode())
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: PaymentsSavedInfo): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xfb8fe43c))
    if self.has_saved_credentials:
        self.flags = self.flags or 1 shl 1
    if self.saved_info.isSome():
        self.flags = self.flags or 1 shl 0
    result = result & TLEncode(self.flags)
    if self.saved_info.isSome():
        result = result & TLEncode(self.saved_info.get())
method TLDecode*(self: PaymentsSavedInfo, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.flags)
    if (self.flags and (1 shl 1)) != 0:
        self.has_saved_credentials = true
    if (self.flags and (1 shl 0)) != 0:
        var tempVal = new TL
        tempVal.TLDecode(bytes)
        self.saved_info = some(tempVal.PaymentRequestedInfoI)
method TLEncode*(self: PaymentsBankCardData): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x3e24e573))
    result = result & TLEncode(self.title)
    result = result & TLEncode(cast[seq[TL]](self.open_urls))
method TLDecode*(self: PaymentsBankCardData, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.title = cast[string](bytes.TLDecode())
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.open_urls = cast[seq[BankCardOpenUrlI]](tempVector)
    tempVector.setLen(0)
