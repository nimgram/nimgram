import rpc/raw
import asyncdispatch
import options 
type UpdatesCallback* = ref object
    callback: Option[proc(updates: UpdatesI): Future[void] {.async.}]


proc processUpdates*(self: UpdatesCallback, updates: UpdatesI): Future[void] {.async.} =
    if self.callback.isSome():
        await self.callback.get()(updates)

proc setCallback*(self: UpdatesCallback, callback: proc(updates: UpdatesI): Future[void] {.async.}) =
    self.callback = some(callback)