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


# HOW TO TEST:
# First, download the whole source, then change the values in test.ini (You can get the api key from https://my.telegram.org and the bot token from https://t.me/botfather)
# Finally you can build this file by executing "nimble test" 


# `nimble test` sets the $PWD to the project directory
import ../src/nimgram
import asyncdispatch
import typetraits
import strutils
import parsecfg
import options

# That variable holds the client instance
var mtprotoClient: NimgramClient

## Update handling currently not working until types are finished

import strformat

proc messageEvent(message: nimgram.Message): Future[void] {.async.} =
  #discard
  if message.outgoing:
    return
  echo fmt"Message from {message.chatID}: {message.text}"
  echo fmt"Message has keyboard: {message.replyMarkup.isSome}"
  echo fmt"Message was edited: {message.edited}"

  var keyboard = InlineKeyboardMarkup(
    rows: @[@[InlineKeyboardButton(
      text: "Nimgram!",
      url: some("https://t.me/nimgramchat")
    )]]
  )

  discard await mtprotoClient.sendMessage(message.chatID, "🥳 Welcome to Nimgram!", keyboard)
  if message.replyMarkup.isSome:
    if message.replyMarkup.get() of InlineKeyboardMarkup:
      echo message.replyMarkup.get().InlineKeyboardMarkup.type
      echo message.replyMarkup.get().InlineKeyboardMarkup.rows.type
  elif message.text == "/quit":
    quit()


# Proc to launch the client instance
proc runClient*(config: NimgramConfig, botToken: string): Future[void] {.async.} =
  # Create the instance, all the data is inside of RAM
  mtprotoClient = await initNimgram("nimgram-session.bin",
    config, StorageRam)
  # Take the control over the bot
  await mtprotoClient.botLogin(botToken)
  # Set the update handler
  mtprotoClient.addOnMessageHandler(messageEvent)

  # Write text to console, now send `fff` to have the test succseeded
  echo "Client started, send `/quit` to the bot"



when isMainModule:
  # Load the configurations.
  # Remember, for the `nimble test` $PWD is the project directory
  let
    conf = loadConfig("tests/test.ini")
    mtpc = "mtprotoClient"

  # c prefix stands for "configuration"
  let
    cApiID = conf.getSectionValue(mtpc, "apiID")
      .parseBiggestInt().int32()
    cApiHash = conf.getSectionValue(mtpc, "apiHash")
    cBotToken = conf.getSectionValue("botLogin", "botToken")

  if cApiID == 0 or cApiHash == "0" or cBotToken == "0:0":
    raise Exception.newException("change the configurations, tests/test.ini")

  let config = NimgramConfig(
    testMode: false,
    transportMode: NetTcpAbridged,
    apiID: cApiID,
    apiHash: cApiHash,
    deviceModel: "Nimphone",
    systemVersion: "Nimos 1.0",
    appVersion: "dev",
    systemLangCode: "en",
    langPack: "",
    langCode: "en",
    useIpv6: false,
    disableCache: false
  )

  asyncCheck runClient(config, cBotToken)
  runForever()
