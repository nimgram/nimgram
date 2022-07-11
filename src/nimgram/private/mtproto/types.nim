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

import network/transports
import std/[asyncdispatch, options, times, math, sysrand, tables]
import pkg/tltypes, pkg/tltypes/[decode, encode]
import crypto/ige
import ../utils/[exceptions]
import pkg/nimcrypto/[sha, sha2]


type Salt* = object
        validUntil*: uint64
        salt*: seq[uint8]


type ConnectionInfo* = ref object
  apiID*: uint32
  deviceModel*: string
  systemVersion*: string
  appVersion*: string
  systemLangCode*: string
  langPack*: string
  langCode*: string
  proxy*: Option[(string, uint32)]
  connectionType*: ConnectionType
  ipv6*: bool

