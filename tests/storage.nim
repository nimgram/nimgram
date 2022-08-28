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

import ../src/nimgram/private/storage/[sqlite, storage_interfaces]
import std/logging, std/asyncdispatch, std/options

proc main =
    echo "Checking sqlite storage..."

    var consoleLog = newConsoleLogger()
    addHandler(consoleLog)  
    let storage = newSqliteStorage("nimgram-session.db").NimgramStorage

    waitFor storage.addOrEditSession(4, true, true, @[200'u8], 444'i64, some(true))
    doAssert (waitFor storage.getSession(4, true, true)) == (@[200'u8], 444'i64)
    waitFor storage.addOrEditSession(4, true, true, @[255'u8], 445'i64, some(true))
    doAssert (waitFor storage.getDefaultSession()) == (4, true, true, @[255'u8], 445'i64)
    waitFor storage.addOrEditSession(4, false, false, @[100'u8, 100], 440'i64, some(false))
    doAssert (waitFor storage.getSession(4, false, false)) == (@[100'u8, 100], 440'i64)

    waitFor storage.addOrEditPeer(397112340, 46585)
    doAssert (waitFor storage.getPeer(397112340)) == (46585'i64, none(string))
    waitFor storage.addOrEditPeer(397112340, 44444)
    doAssert (waitFor storage.getPeer(397112340)) == (44444'i64, none(string))
    waitFor storage.addOrEditPeer(397112340, 33333, "cagatemi")
    doAssert (waitFor storage.getPeer(397112340)) == (33333'i64, some("cagatemi"))
    waitFor storage.addOrEditPeer(-1001670814413, 2563, "anewchannel34")
    doAssert (waitFor storage.getPeer("anewchannel34")) == (-1001670814413'i64, 2563'i64)
    
    echo "sqlite storage PASSED"

when isMainModule:
    main()