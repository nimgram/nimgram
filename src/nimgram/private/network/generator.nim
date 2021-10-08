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

import transports
import tcp/[abridged, intermediate]
import asyncdispatch

proc connect*(self: MTProtoNetwork, networkType: NetworkTypes, address: string, port: uint16) {.async.} =
    case networkType:
    of NetTcpAbridged:
        self.write = abridged.write
        self.receive = abridged.receive
        self.isClosed = abridged.isClosed
        self.close = abridged.close
        self.reopen = abridged.reopen
        await abridged.connect(self, address, port)
        return
    of NetTcpIntermediate: 
        self.write = intermediate.write
        self.receive = intermediate.receive
        self.isClosed = intermediate.isClosed
        self.close = intermediate.close
        self.reopen = intermediate.reopen
        await intermediate.connect(self, address, port)
        return