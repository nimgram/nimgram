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

## Module implementing a low-level client object

import std/options
import types

import network/transports


type MTProtoClient* = ref object
  connectionInfo: ConnectionInfo


proc createClient*(apiID: int, apiHash, deviceModel, systemVersion, appVersion, langCode, systemLangCode: string, useIpv6 = false, connectionType: ConnectionType = TCPAbridged): MTProtoClient = 
  return MTProtoClient(
    connectionInfo: ConnectionInfo(
      apiID: uint32(apiID),
      apiHash: apiHash,
      deviceModel: deviceModel,
      systemVersion: systemVersion,
      appVersion: appVersion,
      systemLangCode: systemLangCode,
      langPack: "",
      langCode: langCode,
      connectionType: connectionType,
      ipv6: useIpv6
    )
  )