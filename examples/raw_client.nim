# Nimgram
# Copyright (C) 2020-2022 Daniele Cortesi <https://github.com/dadadani>
# This file is part of Nimgram, under the MIT License
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

## An example using the raw MTProto client

# Tip: to get faster authkey generation time, use compilation flag -d:release or -d:danger

import std/asyncdispatch, std/logging, std/strutils, std/times
import ../src/nimgram/private/[mtproto/client, utils/exceptions]
import pkg/tltypes

const
    API_ID = 94575 # for real world usage, please replace the api id and hash with your own
    API_HASH = "a3406de8d171bb422bb6ddf3bbd800e2"
    BOT_TOKEN = "id:token"
    USER_ID = 397112340
    TEST_MODE = false

proc main() {.async.} =
    addHandler(newConsoleLogger())

    # Start client
    let mtprotoClient = newClient(API_ID, API_HASH, "Nim Device", "Example OS",
            "Nimgram devel", "en", "en", useTestMode = TEST_MODE)
    await mtprotoClient.startClient()

    try:
        # Check if we are authenticated
        discard await mtprotoClient.send(UsersGetFullUser(id: InputUserSelf().setConstructorID).setConstructorID)
    except exceptions.RPCError:
        try:
            # Try to authenticate as a bot, switch datacenter if necessary
            discard await mtprotoClient.send(AuthImportBotAuthorization(
                    api_id: API_ID, api_hash: API_HASH,
                    bot_auth_token: BOT_TOKEN).setConstructorID)
        except exceptions.RPCError as ex:
            if ex.errorMessage.startsWith("USER_MIGRATE_"):
                let migrateDC = parseInt(ex.errorMessage.split("_")[2])
                await mtprotoClient.switchDc(migrateDC)
                discard await mtprotoClient.send(AuthImportBotAuthorization(
                        api_id: API_ID, api_hash: API_HASH,
                        bot_auth_token: BOT_TOKEN).setConstructorID)
            else:
                raise ex

    # Send a simple message
    discard await mtprotoClient.send(MessagesSendMessage(peer: InputPeerUser(
            user_id: USER_ID).setConstructorID, message: "Hello from Nimgram",
            random_id: uint64(now().toTime().toUnix())).setConstructorID)

when isMainModule:
    main().waitFor()
