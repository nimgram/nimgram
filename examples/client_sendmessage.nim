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

import ../src/nimgram
import std/logging, std/asyncdispatch
import pkg/tltypes, std/times

const
    API_ID = 94575 # for real world usage, please replace the api id and hash with your own
    API_HASH = "a3406de8d171bb422bb6ddf3bbd800e2"
    BOT_TOKEN = "id:bot"
    USER_ID = 397112340
    TEST_MODE = false

proc main {.async.} = 
    addHandler(newConsoleLogger())
    # Start client
    let client = await startNimgram(API_ID, API_HASH, TEST_MODE)
    
    # Authenticate if necessary
    if (await client.getAuthorizationState()) of AuthorizationStateWaitAuthentication:
        info("Logging in...")
        await client.botLogin(BOT_TOKEN)

    # Send a simple message
    discard await client.send(MessagesSendMessage(peer: InputPeerUser(
            user_id: USER_ID).setConstructorID, message: "Hello from Nimgram",
            random_id: uint64(now().toTime().toUnix())).setConstructorID)
            
    # Close the client
    await client.close()
when isMainModule:
    waitFor main()