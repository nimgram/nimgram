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

method TLEncode*(self: BotsSendCustomRequest): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xaa2769ed))
    result = result & TLEncode(self.custom_method)
    result = result & TLEncode(self.params)
method TLDecode*(self: BotsSendCustomRequest, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    self.custom_method = cast[string](bytes.TLDecode())
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.params = cast[DataJSONI](tempObj)
method TLEncode*(self: BotsAnswerWebhookJSONQuery): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0xe6213f4d))
    result = result & TLEncode(self.query_id)
    result = result & TLEncode(self.data)
method TLDecode*(self: BotsAnswerWebhookJSONQuery, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    bytes.TLDecode(addr self.query_id)
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.data = cast[DataJSONI](tempObj)
method TLEncode*(self: BotsSetBotCommands): seq[uint8] {.locks: "unknown".} =
    result = TLEncode(uint32(0x805d46f6))
    result = result & TLEncode(cast[seq[TL]](self.commands))
method TLDecode*(self: BotsSetBotCommands, bytes: var ScalingSeq[uint8]) {.locks: "unknown".} = 
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.commands = cast[seq[BotCommandI]](tempVector)
    tempVector.setLen(0)
