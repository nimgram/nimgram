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

import math
import tables 
import stint
import endians
type ScalingSeq*[T] = ref object
    s: seq[T]
    pos: int

proc newScalingSeq*[T](data: seq[T]): ScalingSeq[T] =
    var temp = new(ScalingSeq[T])
    temp.pos = 0
    temp.s = data
    return temp

proc readAll*[T](self: var ScalingSeq[T]): seq[T] =
    result = self.s[self.pos..(self.s.len-1)]
    self.pos += (self.s.len)

proc readN*[T](self: var ScalingSeq[T], offset: int = 1): seq[T] =
    result = self.s[self.pos..(self.pos+offset-1)]
    self.pos += offset

proc goBack*[T](self: var ScalingSeq[T], offset: int = 1) =
    self.pos -= offset

proc TLDecode*(self: var ScalingSeq[uint8], integer: ptr int32, endiannes: Endianness = littleEndian) =
    var buf = self.readN(4)
    if cpuEndian != endiannes:
        var temp: array[0..3, uint8]
        swapEndian32(addr temp, addr buf[0])
        copyMem(integer, addr temp[0], 4)
    else: 
        copyMem(integer, addr buf[0], 4)

proc TLDecode*(self: var ScalingSeq[uint8], integer: ptr Int128, endiannes: Endianness = littleEndian) =
    var buf = self.readN(16)
    if cpuEndian != endiannes:
        var temp: array[0..15, uint8]
        swapEndian32(addr temp, addr buf[0])
        copyMem(integer, addr temp[0], 16)
    else: 
        copyMem(integer, addr buf[0], 16)

proc TLDecode*(self: var ScalingSeq[uint8], integer: ptr Int256, endiannes: Endianness = littleEndian) =
    var buf = self.readN(32)
    if cpuEndian != endiannes:
        var temp: array[0..31, uint8]
        swapEndian32(addr temp, addr buf[0])
        copyMem(integer, addr temp[0], 32)
    else: 
        copyMem(integer, addr buf[0], 32)

proc TLDecode*(self: var ScalingSeq[uint8], obj: var bool) =
    var id: int32
    self.TLDecode(addr id)
    if id == -1720552011:
        obj = true
    obj = false

proc TLDecode*(self: var ScalingSeq[uint8], integer: ptr uint32, endiannes: Endianness = littleEndian) =
    var buf = self.readN(4)
    if cpuEndian != endiannes:
        var temp: array[0..3, uint8]
        swapEndian32(addr temp, addr buf[0])
        copyMem(integer, addr temp[0], 4)
    else: 
        copyMem(integer, addr buf[0], 4)


proc TLDecode*(self: var ScalingSeq[uint8], integer: ptr int64, endiannes: Endianness = littleEndian) =
    var buf = self.readN(8)
    if cpuEndian != endiannes:
        var temp: array[0..7, uint8]
        swapEndian32(addr temp, addr buf[0])
        copyMem(integer, addr temp[0], 8)
    else: 
        copyMem(integer, addr buf[0], 8)


proc TLDecode*(self: var ScalingSeq[uint8], integer: ptr uint64, endiannes: Endianness = littleEndian) =
    var buf = self.readN(8)
    if cpuEndian != endiannes:
        var temp: array[0..7, uint8]
        swapEndian32(addr temp, addr buf[0])
        copyMem(integer, addr temp[0], 8)
    else: 
        copyMem(integer, addr buf[0], 8)

proc TLDecode*(self: var ScalingSeq[uint8], integer: ptr float64, endiannes: Endianness = littleEndian) =
    var buf = self.readN(8)
    if cpuEndian != endiannes:
        var temp: array[0..7, uint8]
        swapEndian32(addr temp, addr buf[0])
        copyMem(integer, addr temp[0], 8)
    else: 
        copyMem(integer, addr buf[0], 8)



proc TLDecode*(self: var ScalingSeq[uint8]): seq[uint8] =
    ## See https://core.telegram.org/type/string
    ## String is UTF-8 encoded equivalent of bytes

    var len = self.readN(1)
    
    if len[0] <= 253:
        result = self.readN(int(len[0]))
        var tempLen = float32(len[0])
        while (tempLen+1) mod float32(4) != float32(0):
            var paddingByte = self.readN(1)
            tempLen += 1
            if paddingByte[0] != uint8(0):
                raise newException(CatchableError, "Deserialization error: Unexpected end of padding")
    else:
        var fullLenghtBytes = newScalingSeq(self.readN(3) & 0)
        var fullLenght: int32
        fullLenghtBytes.TLDecode(addr fullLenght)
        result = self.readN(fullLenght)
        var tempLen = float32(fullLenght)
        while tempLen mod float32(4) != float32(0):
            tempLen += 1
            var paddingByte = self.readN(1)
            if paddingByte[0] != uint8(0):
                raise newException(CatchableError, "Deserialization error: Unexpected end of padding")

proc TLDecodeSeq*(self: var ScalingSeq[uint8]): seq[seq[uint8]] =
    var id: int32
    self.TLDecode(addr id)
    if id != 481674261:
        raise newException(CatchableError, "Type is not Vector")
    #get lenght of array
    var lenght: int32
    self.TLDecode(addr lenght)
    for i in countup(1, lenght):
        result = result & self.TLDecode()


proc TLDecode*(self: var ScalingSeq[uint8], obj: var seq[int32], enableIdDecode: bool = true) =
    #get lenght of array
    var lenght: int32
    var tempInt: int32
    if enableIdDecode:
        self.TLDecode(addr lenght)
        if lenght != 481674261:
            raise newException(CatchableError, "Type is not Vector")
    self.TLDecode(addr lenght)
    for i in countup(1, lenght):
        self.TLDecode(addr tempInt)
        obj.add(tempInt)


proc TLDecode*(self: var ScalingSeq[uint8], obj: var seq[int64], enableIdDecode: bool = true) =
    #get lenght of array
    var lenght: int32
    var tempInt: int64
    if enableIdDecode:
        self.TLDecode(addr lenght)
        if lenght != 481674261:
            raise newException(CatchableError, "Type is not Vector: " & $lenght)

    self.TLDecode(addr lenght)
    for i in countup(1, lenght):
        self.TLDecode(addr tempInt)
        obj.add(tempInt)


