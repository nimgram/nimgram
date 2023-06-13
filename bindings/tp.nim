# Nimgram
# Copyright (C) 2020-2023 Daniele Cortesi <https://github.com/dadadani>
# This file is part of Nimgram, under the MIT License
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


import std/asyncdispatch, std/json
import std/strutils
import std/threadpool, std/asyncstreams
import std/random, std/tables

import ../src/nimgram/private/api/client
import std/base64


type ThreadInfo* = object
    requests*: FutureStream[string]
    thread*: Thread[ptr ThreadInfo]
    answers*: FutureStream[string]
    client*: NimgramClient

proc `%*`*(bytes: seq[uint8]): JsonNode = 
    return %*encode(bytes)

proc `%*`*[T](obj: seq[T]): JsonNode = 
    result = newJArray()
    for elem in obj:
        result.add(%*elem)


proc decodeJson*[T: int32|int64|float64|bool|seq[uint8]|string](self: JsonNode): T =    
    when T is int64:
        return self.getBiggestInt()
    elif T is int32:
        return int32(self.getInt())
    elif T is float64:
        return self.getFloat()
    elif T is bool:
        return self.getBool()
    elif T is seq[uint8]:
        return cast[seq[uint8]](decode(self.getStr()))
    elif T is string:
        return self.getStr()


proc decodeJsonVector*[T](self: JsonNode): seq[T] =
    if not T is seq[uint8] and T is seq:
        for elem in self:
            result.add(decodeJsonVector[T](elem))
    else:
        for elem in self:
            result.add(decodeJson[T](elem))