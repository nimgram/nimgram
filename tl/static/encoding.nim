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

import stint
import endians
import math

proc TLEncode*(x: uint32, endiannes: Endianness = littleEndian): seq[uint8] =
    result = cast[array[0..3, uint8]](x)[0..3]
    if endiannes != cpuEndian:
        var tempBytes: array[0..3, uint8]
        swapEndian32(addr tempBytes, addr result[0])
        result = tempBytes[0..3]


proc TLEncode*(x: int32, endiannes: Endianness = littleEndian): seq[uint8] =
    result = cast[array[0..3, uint8]](x)[0..3]
    if endiannes != cpuEndian:
        var tempBytes: array[0..3, uint8]
        swapEndian32(addr tempBytes, addr result[0])
        result = tempBytes[0..3]

    
proc TLEncode*(x: int64, endiannes: Endianness = littleEndian): seq[uint8] =
    result = cast[array[0..7, uint8]](x)[0..7]
    if endiannes != cpuEndian:
        var tempBytes: array[0..7, uint8]
        swapEndian64(addr tempBytes, addr result[0])
        result = tempBytes[0..7]

proc TLEncode*(x: uint64, endiannes: Endianness = littleEndian): seq[uint8] =
    result = cast[array[0..7, uint8]](x)[0..7]
    if endiannes != cpuEndian:
        var tempBytes: array[0..7, uint8]
        swapEndian64(addr tempBytes, addr result[0])
        result = tempBytes[0..7]


proc TLEncode*(x: float64, endiannes: Endianness = littleEndian): seq[uint8] =
    result = cast[array[0..7, uint8]](x)[0..7]
    if endiannes != cpuEndian:
        var tempBytes: array[0..7, uint8]
        swapEndian64(addr tempBytes, addr result[0])
        result = tempBytes[0..7]

proc TLEncode*(stint: Int128, endiannes: Endianness = littleEndian): seq[uint8] =
    result = cast[array[0..15, uint8]](stint)[0..15]
    if endiannes != cpuEndian:
        var tempBytes: array[0..15, uint8]
        swapEndian64(addr tempBytes, addr result[0])
        result = tempBytes[0..15]


proc TLEncode*(stint: Int256, endiannes: Endianness = littleEndian): seq[uint8] =
    result = cast[array[0..31, uint8]](stint)[0..31]
    if endiannes != cpuEndian:
        var tempBytes: array[0..31, uint8]
        swapEndian64(addr tempBytes, addr result[0])
        result = tempBytes[0..31]
proc TLEncode*(x: bool): seq[uint8] =
    if x:
        return TLEncode(int32(-1720552011))
    return TLEncode(int32(-1132882121))

proc TLEncode*(x: seq[int32], endiannes: Endianness = littleEndian): seq[uint8] =
    result = TLEncode(int32(481674261))
    result = result & TLEncode(int32(len(x)))
    for objs in x:
        result = result & TLEncode(objs, endiannes)


proc TLEncode*(x: seq[int64], endiannes: Endianness = littleEndian): seq[uint8] =
    result = TLEncode(int32(481674261))
    result = result & TLEncode(int32(len(x)))
    for objs in x:
        result = result & TLEncode(objs, endiannes)
        
proc TLEncode*(data: seq[uint8], debug: bool = false): seq[uint8] =
   
   var lenght = len(data)

   if lenght <= 253:
       result = result & uint8(lenght)
       result = result & data
       while float32(len(result)) mod float32(4) != float32(0):
           result.add(uint8(0))
   else:
       result = result & uint8(254)
       result = result & TLEncode(int32(lenght))[0..2]
       result = result & data
       while float32(len(result)) mod float32(4) != float32(0):
           result.add(uint8(0))


proc TLEncode*(x: seq[seq[uint8]]): seq[uint8] =
    result = TLEncode(int32(481674261))
    result = result & TLEncode(int32(len(x)))
    for objs in x:
        result = result & TLEncode(objs)

proc TLEncode*(data: string): seq[uint8] =
    return TLEncode(cast[seq[uint8]](data))

proc TLEncode*(x: seq[string]): seq[uint8] =
    return TLEncode(cast[seq[seq[uint8]]](x))