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


type
    KeyboardMarkup* = ref object of RootObj

    InlineKeyboardMarkup* = ref object of KeyboardMarkup
        rows*: seq[seq[InlineKeyboardButton]]

    ReplyKeyboardMarkup* = ref object of KeyboardMarkup
        rows*: seq[seq[ReplyKeyboardButton]]
        resize*: bool
        singleUse*: bool
        selective*: bool
        placeHolder*: Option[string]

    ReplyKeyboardHide* = ref object of KeyboardMarkup
        selective*: bool

    ReplyKeyboardForceReply* = ref object of KeyboardMarkup
        selective*: bool
        singleUse*: bool
        placeHolder*: Option[string]


proc parse*(keyboard: KeyboardMarkup): raw.ReplyMarkupI =
    if keyboard of InlineKeyboardMarkup:
        let tmpResult = new raw.ReplyInlineMarkup
        #[
        InlineKeyboardButton* = ref object of Button
            client: NimgramClient
            text*: string
            url*: Option[string]
            loginUrl*: Option[LoginUrl]
            callbackData*: Option[CallbackData]
            switchInlineQuery*: Option[string]
            switchInlineQueryCurrentChat*: Option[string]
            requiresPassword*: bool
            game*: bool
            pay*: bool
        ]#
        tmpResult.rows = newSeq[KeyboardButtonRowI]()
        for row in keyboard.InlineKeyboardMarkup.rows:
            let tmpRow = new KeyboardButtonRow
            tmpRow.buttons = newSeq[KeyboardButtonI]()
            for button in row:
                if button.callbackData.isSome:
                    let rawButton = new raw.KeyboardButtonCallback
                    rawButton.text = button.text
                    rawButton.data = button.callbackData.get()
                    rawButton.requires_password = button.requiresPassword
                    tmpRow.buttons.add(rawButton)
                elif button.url.isSome:
                    let rawButton = new raw.KeyboardButtonUrl
                    rawButton.text = button.text
                    rawButton.url = button.url.get()
                    tmpRow.buttons.add(rawButton)
                elif button.loginUrl.isSome:
                    #[
                    LoginUrl* = ref object
                        # https://core.telegram.org/bots/api#loginurl
                        url: string
                        text: string
                        forwardText: Option[string]
                        buttonId: int32
                    ]#
                    let rawButton = new raw.KeyboardButtonUrlAuth
                    let loginUrl: LoginUrl = button.loginUrl.get()
                    rawButton.text = button.text
                    if loginUrl.forwardText.isSome:
                        rawButton.fwd_text = loginUrl.forwardText
                    rawButton.url = loginUrl.url
                    rawButton.button_id = loginUrl.buttonId
                    tmpRow.buttons.add(rawButton)
                elif button.switchInlineQuery.isSome or
                        button.switchInlineQueryCurrentChat.isSome:
                    let rawButton = new raw.KeyboardButtonSwitchInline
                    rawButton.same_peer = button.switchInlineQueryCurrentChat.isSome
                    rawButton.text = button.text
                    rawButton.query =
                        if button.switchInlineQuery.isSome:
                            button.switchInlineQuery.get()
                        else:
                            button.switchInlineQueryCurrentChat.get()
                    tmpRow.buttons.add(rawButton)
            tmpResult.rows.add(tmpRow)
        return tmpResult

    if keyboard of ReplyKeyboardMarkup:
        let tmpResult = new raw.ReplyKeyboardMarkup
        tmpResult.resize = keyboard.ReplyKeyboardMarkup.resize
        tmpResult.selective = keyboard.ReplyKeyboardMarkup.selective
        tmpResult.placeholder = keyboard.ReplyKeyboardForceReply.placeHolder
        tmpResult.single_use = keyboard.ReplyKeyboardMarkup.singleUse
        tmpResult.rows = newSeq[KeyboardButtonRowI]()

        for row in keyboard.ReplyKeyboardMarkup.rows:
            let tmpRow = new KeyboardButtonRow
            tmpRow.buttons = newSeq[KeyboardButtonI]()
            #[
            ReplyKeyboardButton* = ref object of Button
                text*: string
                requestContact*: bool
                requestLocation*: bool
                requestPoll*: Option[PoolType]
            ]#
            for button in row:
                if button.requestContact:
                    let rawButton = new raw.KeyboardButtonRequestPhone
                    rawButton.text = button.text
                    tmpRow.buttons.add(rawButton)
                elif button.requestLocation:
                    let rawButton = new raw.KeyboardButtonRequestGeoLocation
                    rawButton.text = button.text
                    tmpRow.buttons.add(rawButton)
                elif button.requestPoll.isSome:
                    let rawButton = new raw.KeyboardButtonRequestPoll
                    rawButton.text = button.text
                    rawButton.quiz = some(button.requestPoll.get().isQuiz)
                    tmpRow.buttons.add(rawButton)
                else:
                    let rawButton = new raw.KeyboardButton
                    rawButton.text = button.text
                    tmpRow.buttons.add(rawButton)
                #[
                    Missing:
                    KeyboardButtonGame
                    KeyboardButtonBuy

                    Check out `keyboard_button.nim`
                ]#
            tmpResult.rows.add(tmpRow)
        return tmpResult

    if keyboard of ReplyKeyboardHide:
        let tmpResult = new raw.ReplyKeyboardHide
        tmpResult.selective = keyboard.ReplyKeyboardHide.selective
        return tmpResult

    if keyboard of ReplyKeyboardForceReply:
        let tmpResult = new raw.ReplyKeyboardForceReply
        tmpResult.single_use = keyboard.ReplyKeyboardForceReply.singleUse
        tmpResult.selective = keyboard.ReplyKeyboardForceReply.selective
        tmpResult.placeholder = keyboard.ReplyKeyboardForceReply.placeHolder
        return tmpResult


proc parse*(keyboard: raw.ReplyMarkupI, client: NimgramClient): KeyboardMarkup =
    if keyboard of raw.ReplyInlineMarkup:
        let tmpMarkup = new InlineKeyboardMarkup
        tmpMarkup.rows = newSeq[seq[nimgram.InlineKeyboardButton]]()
        for row in keyboard.ReplyInlineMarkup.rows:
            var tmpRow = newSeq[nimgram.InlineKeyboardButton]()
            for button in row.KeyboardButtonRow.buttons:
                let x = parse(button, client).InlineKeyboardButton
                tmpRow.add(x)
            tmpMarkup.rows.add(tmpRow)
        return tmpMarkup
    if keyboard of raw.ReplyKeyboardMarkup:
        let tmpMarkup = new ReplyKeyboardMarkup
        tmpMarkup.resize = raw.ReplyKeyboardMarkup(keyboard).resize
        tmpMarkup.singleUse = raw.ReplyKeyboardMarkup(keyboard).single_use
        tmpMarkup.selective = raw.ReplyKeyboardMarkup(keyboard).selective
        tmpmarkup.placeHolder = raw.ReplyKeyboardForceReply(
                keyboard).placeholder
        tmpMarkup.rows = newSeq[seq[nimgram.ReplyKeyboardButton]]()
        for row in keyboard.ReplyInlineMarkup.rows:
            var tmpRow = newSeq[nimgram.ReplyKeyboardButton]()
            for button in row.KeyboardButtonRow.buttons:
                let x = parse(button, client).ReplyKeyboardButton
                tmpRow.add(x)
            tmpMarkup.rows.add(tmpRow)
        return tmpMarkup
    if keyboard of raw.ReplyKeyboardForceReply:
        let tmpMarkup = new ReplyKeyboardForceReply
        tmpmarkup.singleUse = raw.ReplyKeyboardForceReply(keyboard).single_use
        tmpmarkup.selective = raw.ReplyKeyboardForceReply(keyboard).selective
        tmpmarkup.placeHolder = raw.ReplyKeyboardForceReply(
                keyboard).placeholder
        return tmpMarkup
    if keyboard of raw.ReplyKeyboardHide:
        let tmpMarkup = new ReplyKeyboardHide
        tmpMarkup.selective = raw.ReplyKeyboardHide(keyboard).selective
        return tmpMarkup
