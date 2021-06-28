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
    PoolType* = ref object ## BotApi: If `quiz` is passed, the user will be allowed to create only polls in the quiz mode. If `regular` is passed, only regular polls will be allowed. Otherwise, the user will be allowed to create a poll of any type.
    # This means that (block: isQuiz = `type` == "quiz"), however it's a BotApi
    # abstraction, so we only need to specify if pool is a quiz or not using a boolean
        isQuiz: bool

    LoginUrl* = ref object
        # https://core.telegram.org/bots/api#loginurl
        url: string
        text: string
        forwardText: Option[string]
        buttonId: int32

    Button* = ref object of RootObj

    InlineKeyboardButton* = ref object of Button
        client: NimgramClient
        text*: string
        url*: Option[string]
        loginUrl*: Option[LoginUrl]
        callbackData*: Option[seq[uint8]]
        switchInlineQuery*: Option[string]
        switchInlineQueryCurrentChat*: Option[string]
        requiresPassword*: bool
        game*: Option[string]
        pay*: Option[string]

    
    ReplyKeyboardButton* = ref object of Button
        text*: string
        requestContact*: bool
        requestLocation*: bool
        requestPoll*: Option[PoolType]


proc parse*(button: raw.KeyboardButtonI, client: NimgramClient): Button =
    if button of raw.KeyboardButton or button of raw.KeyboardButtonRequestPhone or button of raw.KeyboardButtonRequestGeoLocation:
        # Reply Buttons
        let tmpResult = new ReplyKeyboardButton
        tmpResult.requestContact = button of raw.KeyboardButtonRequestPhone
        tmpResult.requestLocation = button of raw.KeyboardButtonRequestGeoLocation

        if button of raw.KeyboardButtonRequestPhone:
            tmpResult.text = button.KeyboardButtonRequestPhone.text
        if button of raw.KeyboardButtonRequestGeoLocation:
            tmpResult.text = button.KeyboardButtonRequestGeoLocation.text
        if button of raw.KeyboardButtonRequestPoll:
            let pool = new PoolType
            pool.isQuiz = button.KeyboardButtonRequestPoll.quiz.get()
            tmpResult.requestPoll = some(pool)
        result = tmpResult
    else:
        # Inline Buttons
        let tmpResult = new InlineKeyboardButton
        tmpResult.client = client
        if button of raw.KeyboardButtonUrl:
            tmpResult.url = some(button.KeyboardButtonUrl.url)
        if button of raw.KeyboardButtonCallback:
            tmpResult.callbackData = some(button.KeyboardButtonCallback.data)
        if button of raw.KeyboardButtonSwitchInline:
            let query: Option[string] = some(button.KeyboardButtonSwitchInline.query)
            if button.KeyboardButtonSwitchInline.same_peer:
                tmpResult.switchInlineQueryCurrentChat = query
            else:
                tmpResult.switchInlineQuery = query
        if button of raw.KeyboardButtonUrlAuth:
            var loginUrl = new nimgram.LoginUrl

            loginUrl.url = button.KeyboardButtonUrlAuth.url
            loginUrl.text = button.KeyboardButtonUrlAuth.text
            loginUrl.forwardText = button.KeyboardButtonUrlAuth.fwd_text
            loginUrl.buttonId = button.KeyboardButtonUrlAuth.button_id
            tmpResult.loginUrl = some(loginUrl)
        result = tmpResult
    #[
        Missing:
        KeyboardButtonGame
        KeyboardButtonBuy

        Check out `keyboard_markup.nim`
    ]#


proc parse*(button: Button): raw.KeyboardButtonI =
    if button of InlineKeyboardButton:
        #[
        InlineKeyboardButton* = ref object of Button
            client: NimgramClient
            text*: string
            url*: Option[string]
            loginUrl*: Option[LoginUrl]
            callbackData*: Option[seq[uint8]]
            switchInlineQuery*: Option[string]
            switchInlineQueryCurrentChat*: Option[string]
            requiresPassword*: bool
            game*: bool
            pay*: bool
        ]#
        if button.InlineKeyboardButton.url.isSome():
            let tmpButton = new raw.KeyboardButtonUrl
            tmpButton.text = button.InlineKeyboardButton.text
            tmpButton.url = button.InlineKeyboardButton.url.get()
            return tmpButton
        elif button.InlineKeyboardButton.callbackData.isSome():
            let tmpButton = new raw.KeyboardButtonCallback
            tmpButton.text = button.InlineKeyboardButton.text
            tmpButton.data = button.InlineKeyboardButton.callbackData.get()
            return tmpButton
        elif button.InlineKeyboardButton.switchInlineQuery.isSome() or button.InlineKeyboardButton.switchInlineQueryCurrentChat.isSome():
            let tmpButton = new raw.KeyboardButtonSwitchInline
            tmpButton.text = button.InlineKeyboardButton.text
            if button.InlineKeyboardButton.switchInlineQuery.isSome():
                tmpButton.same_peer = false
                tmpButton.query = button.InlineKeyboardButton.switchInlineQuery.get()
            else:
                tmpButton.same_peer = true
                tmpButton.query = button.InlineKeyboardButton.switchInlineQueryCurrentChat.get()
            return tmpButton
        elif button.InlineKeyboardButton.loginUrl.isSome():
            let tmpButton = new raw.KeyboardButtonUrlAuth
            tmpButton.text = button.InlineKeyboardButton.text
            let loginUrl: LoginUrl = button.InlineKeyboardButton.loginUrl.get()

            tmpButton.url = loginUrl.url
            tmpButton.text = loginUrl.text
            tmpButton.fwd_text = loginUrl.forwardText
            tmpButton.button_id = loginUrl.buttonId
            return tmpButton
    elif button of ReplyKeyboardButton:
        #[
        ReplyKeyboardButton* = ref object of Button
            text*: string
            requestContact*: bool
            requestLocation*: bool
            requestPoll*: Option[PoolType]
        ]#
        if button.ReplyKeyboardButton.requestContact:
            let tmpButton = new raw.KeyboardButtonRequestPhone
            tmpButton.text = button.ReplyKeyboardButton.text
            return tmpButton
        elif button.ReplyKeyboardButton.requestLocation:
            let tmpButton = new raw.KeyboardButtonRequestGeoLocation
            tmpButton.text = button.ReplyKeyboardButton.text
            return tmpButton
        elif button.ReplyKeyboardButton.requestPoll.isSome():
            let tmpButton = new raw.KeyboardButtonRequestPoll
            tmpButton.text = button.ReplyKeyboardButton.text
            tmpButton.quiz = some(button.ReplyKeyboardButton.requestPoll.get().isQuiz)
            return tmpButton
        else:
            let tmpButton = new raw.KeyboardButton
            tmpButton.text = button.ReplyKeyboardButton.text
            return tmpButton
    #[
        Missing:
        KeyboardButtonGame
        KeyboardButtonBuy

        Check out `keyboard_markup.nim`
    ]#
