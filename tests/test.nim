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

import json
import random

# `nimble test` sets the $PWD to the project directory
import src/nimgram
import src/raw
import asyncdispatch
import typetraits
import strutils
import parsecfg

# That variable holds the client instance
var mtprotoClient: NimgramClient

# Message handler. Called every time the client updates
proc handleMessage(message: UpdateNewMessage): Future[void] {.async.} =
  let contents = message.message
  # Reacts only if the message is the actually message
  if contents of raw.Message:
    let textMessage = cast[raw.Message](contents)

    # The test program waits for the message "fff"
    if textMessage.message == "fff":
      quit 0

    var chatID: InputPeerI

    var inputPeer = await mtprotoClient.resolveInputPeer(textMessage.peer_id)
    # Preparing to throw the dice...
    randomize()

    # Send the message
    discard await mtprotoClient.send(MessagesSendMessage(
      no_webpage: true,
      silent: false,
      background: false,
      clear_draft: false,
      peer: inputPeer,
      message: $(%*textMessage),
      random_id: int64(rand(2147483646))
    ))



proc handleMessageHigh(message: nimgram.Message): Future[void] {.async.} =
  echo %*message


proc handleChannelMessage(message: UpdateNewChannelMessage): Future[void] {.async.} =
  let contents = message.message
  # Reacts only if the message is the actually message
  if contents of raw.Message:
    let textMessage = cast[raw.Message](contents)
    if textMessage.isout:
      return
    # The test program waits for the message "fff"
    if textMessage.message == "fff":
      quit 0

    var chatID: InputPeerI

    var inputPeer = await mtprotoClient.resolveInputPeer(textMessage.peer_id)
    echo %*inputPeer
    # Preparing to throw the dice...
    randomize()

    # Send the message
    discard await mtprotoClient.send(MessagesSendMessage(
      no_webpage: true,
      silent: false,
      background: false,
      clear_draft: false,
      peer: inputPeer,
      message: $(%*textMessage),
      random_id: int64(rand(2147483646))
    ))

# Reconnection handler
proc onReconnection() {.async.} =
  echo "Reconnected!"
  discard await mtprotoClient.send(UpdatesGetState())

# Proc to launch the client instance
proc runClient*(config: NimgramConfig, botToken: string): Future[void] {.async.} =
  # Create the instance, all the data is inside of RAM
  mtprotoClient = await initNimgram("nimgram-session.bin",
    config, StorageRam)
  # Take the control over the bot
  await mtprotoClient.botLogin(botToken)
  # Set the reconnection handler
  mtprotoClient.onReconnection(onReconnection)
  # Tell the server we're ready
  discard await mtprotoClient.send(UpdatesGetState())
  # Set the update handler
  mtprotoClient.onUpdateNewMessage(handleMessage)
  mtprotoClient.onUpdateNewChannelMessage(handleChannelMessage)
  mtprotoClient.onMessage(handleMessageHigh)

  # Write text to console, now send `fff` to have the test succseeded
  echo "Client started, send `fff` to the bot"



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
