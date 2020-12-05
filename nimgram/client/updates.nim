import rpc/mtproto
import rpc/api
import asyncdispatch

type UpdatesCallback* = ref object
    callback: proc(updates: UpdatesI): Future[void] {.async.}

proc processUpdates*(self: UpdatesCallback, updates: UpdatesI): Future[void] {.async.} =
    await self.callback(updates)

proc setCallback*(self: UpdatesCallback, callback: proc(updates: UpdatesI): Future[void] {.async.}) =
    self.callback = callback