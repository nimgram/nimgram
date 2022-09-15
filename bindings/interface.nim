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

# Base module integrating procedures to be exported to other languages


import std/asyncdispatch, std/json
import std/strutils
import std/threadpool, std/asyncstreams
import std/random, std/tables, std/logging
import ../src/nimgram/private/api/[updates, client]

import tp, functions, types


var threads: Table[int, ptr ThreadInfo]


proc uselessSleep() {.async.} =
  #TODO: Nim throws an exception on read when there are no async functions running, fix and remove this loop
  while true:
    await sleepAsync(1000)


proc runner(info: ptr ThreadInfo) {.thread.} =

  proc updateReceiver(client: NimgramClient, update: Update) {.async.} =
    let ujson = $(%*update)
    await info.answers.write(ujson)
  
  info.client.setUpdateCallback(updateReceiver)

  proc queue() {.async.} =
    {.cast(gcsafe).}:
      asyncCheck uselessSleep()

      while true:
        discard
        let request = await info.requests.read()
        if not request[0]:
          break
        let jsonRequest = parseJson(request[1])
        asyncCheck readFunction(info, jsonRequest)

  asyncCheck queue()
  runForever()

proc newRunner(): cint {.exportc: "newRunner", dynlib.} =
    result = cint(rand(9999999)) 
    let threadInfo = createShared(ThreadInfo)
    threadInfo.requests = newFutureStream[string]()
    asyncCheck uselessSleep()
    threadInfo.answers = newFutureStream[string]()
    threadInfo.client = new NimgramClient
    threads[result] = threadInfo
    createThread(threadInfo.thread, runner, threadInfo)
    
proc send(threadId: cint, request: cstring) {.exportc: "send", dynlib.} = 
    asyncCheck threads[threadId].requests.write($request)

proc close(threadId: cint) {.exportc: "close", dynlib.} =
  if threads.contains(threadId):
    threads[threadId].requests.complete()
    threads[threadId].answers.complete()
    joinThread(threads[threadId].thread)
    deallocShared(threads[threadId])
    threads.del(threadId)

proc receive(threadId: cint): cstring {.exportc: "receive", dynlib.} =
    let response = waitFor threads[threadId].answers.read()
    return cstring(response[1])
