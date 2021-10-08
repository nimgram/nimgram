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

import asyncfile, asyncdispatch
import ../rpc/decoding
import nimcrypto
import endians
import tables
import os

## This is an alternative way instead of sqlite to manage MTProto sessions by saving auth_keys/salt on a binary file

## Bin Structure:
## - sha256 checksum of all bytes (STATIC)
## - Bin version (uint16) (STATIC)
## - Array lenght (uint16)
## - DC options (see below)

## DC Options structure:
## - DC Number (uint16)
## - Is authorized bool (uint8, if > 0: true)
## - Is main bool (uint8, if > 0: true)
## - bytes len (uin16) + Auth_key
## - bytes len (uin16) + Salt


## Note: The client rewrites the entire binary file everytime data is updated, so it is not recommended to use a single file on multiple session at the same time

#Current bin version
const BIN_VERSION = uint16(1)

type DcOption* = object
    number*: uint16
    isAuthorized*: bool
    isMain*: bool
    authKey*: seq[uint8]
    salt*: seq[uint8]

proc TLDecode(self: var ScalingSeq[uint8], integer: ptr uint16,
        endiannes: Endianness = littleEndian) =
    var buf = self.readN(2)
    if cpuEndian != endiannes:
        var temp: array[0..1, uint8]
        swapEndian32(addr temp, addr buf[0])
        copyMem(integer, addr temp[0], 2)
    else:
        copyMem(integer, addr buf[0], 2)

proc getBytes*(x: uint16, endiannes: Endianness = littleEndian): seq[uint8] =
    result = cast[array[0..1, uint8]](x)[0..1]
    if endiannes != cpuEndian:
        var tempBytes: array[0..1, uint8]
        swapEndian32(addr tempBytes, addr result[0])
        result = tempBytes[0..1]


proc loadDcOption(data: var ScalingSeq[uint8]): DcOption =
    # Dc number
    data.TLDecode(addr result.number)
    # Is authorized?
    if data.readN(1)[0] > 0:
        result.isAuthorized = true
    # Is main?
    if data.readN(1)[0] > 0:
        result.isMain = true
    var lenght: uint16
    data.TLDecode(addr lenght)
    result.authKey = data.readN(int(lenght))
    data.TLDecode(addr lenght)
    result.salt = data.readN(int(lenght))
proc loadBin*(filename: string): Future[Table[int, DcOption]] {.async.} =
    if not fileExists(filename):
        return
    var file = openAsync(filename)
    var data = cast[seq[uint8]](await file.readAll())
    file.close()
    # Check if data is valid before reading everything
    var checksum = data[0..31]
    doAssert sha256.digest(data[32..(data.len-1)]).data[0..31] == checksum, "Integrity check failed, are you using the correct session file?"
    # Data is valid, continue
    var realdata = newScalingSeq(data[32..(data.len-1)])
    var fileBinVersion: uint16
    realdata.TLDecode(addr fileBinVersion)
    # Currently migrating bin version is not planned until minimum stability is reached
    doAssert fileBinVersion == BIN_VERSION, "Cannot use different bin version, please recreate the session"
    var lenght: uint16
    realdata.TLDecode(addr lenght)
    for i in countup(1, int(lenght)):
        var res = loadDcOption(realdata)
        result[int(res.number)] = res

proc writeDcOption(options: DcOption): seq[uint8] =
    result.add(options.number.getBytes())
    if options.isAuthorized:
        result.add(uint8(1))
    else:
        result.add(uint8(0))
    if options.isMain:
        result.add(uint8(1))
    else:
        result.add(uint8(0))
    result.add(uint16(len(options.authKey)).getBytes())
    result.add(options.authKey)
    result.add(uint16(len(options.salt)).getBytes())
    result.add(options.salt)

proc writeBin*(filename: string, options: Table[int, DcOption]) {.async.} =
    var data = newSeq[uint8]()
    data.add(getBytes(BIN_VERSION))
    data.add(getBytes(uint16(len(options))))
    for _, option in options:
        data.add(writeDcOption(option))

    data = sha256.digest(data).data[0..31] & data
    var files = openAsync(filename, FileMode.fmWrite)
    await files.write(cast[string](data))
    files.close()


proc writeBin*(filename: string, options: seq[DcOption]) {.async.} =
    var data = newSeq[uint8]()
    data.add(getBytes(BIN_VERSION))
    data.add(getBytes(uint16(len(options))))
    for option in options:
        data.add(writeDcOption(option))

    data = sha256.digest(data).data[0..31] & data
    var files = openAsync(filename, FileMode.fmWrite)
    await files.write(cast[string](data))
    files.close()
