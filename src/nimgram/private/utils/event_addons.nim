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

import std/asyncdispatch

type AsyncEventSet* = ref object
    event: AsyncEvent
    isSet: bool

proc waitEvent*(ev: AsyncEvent): Future[void] =
    var fut = newFuture[void]("waitEvent")
    proc cb(fd: AsyncFD): bool = fut.complete(); return true
    addEvent(ev, cb)
    return fut

proc waitEvent*(ev: AsyncEventSet): Future[void] =
    if ev.isSet: return

    var fut = newFuture[void]("waitEvent")
    proc cb(fd: AsyncFD): bool = fut.complete(); return true
    addEvent(ev.event, cb)
    return fut

proc clear*(ev: AsyncEventSet) =
    ev.isSet = false

proc isSet*(ev: AsyncEventSet): bool =
    return ev.isSet

proc set*(ev: AsyncEventSet) =
    if ev.isSet: return
    ev.event.trigger()
    ev.isSet = true

proc newAsyncEventSet*(): AsyncEventSet =
    return AsyncEventSet(isSet: false, event: newAsyncEvent())