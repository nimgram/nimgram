import rpc/raw
import asyncdispatch
import options 
type UpdatesCallback* = ref object
    callback: Option[proc(updates: UpdatesI): Future[void] {.async.}]
    eventUpdateNewMessage: Option[proc(updateNewMessage: UpdateNewMessage): Future[void] {.async.}]

proc processUpdates*(self: UpdatesCallback, updates: UpdatesI): Future[void] {.async.} =
    ## Process updates

    if self.callback.isSome():
        asyncCheck self.callback.get()(updates)

    if updates of Updates:
        var updatesType = updates.Updates
        for update in updatesType.updates:
            if update of UpdateNewMessage:
                if self.eventUpdateNewMessage.isSome():
                    asyncCheck self.eventUpdateNewMessage.get()(update.UpdateNewMessage)

    if updates of UpdateShort:
        var updateShort = updates.UpdateShort
        if updateShort.update of UpdateNewMessage:
            if self.eventUpdateNewMessage.isSome():
                asyncCheck self.eventUpdateNewMessage.get()(updateShort.update.UpdateNewMessage)

    if updates of UpdatesCombined:
        var updatesCombined = updates.UpdatesCombined
        for update in updatesCombined.updates:
            if update of UpdateNewMessage:
                if self.eventUpdateNewMessage.isSome():
                    asyncCheck self.eventUpdateNewMessage.get()(update.UpdateNewMessage)
            


proc onUpdateNewMessage*(self: UpdatesCallback, procedure: proc(updateNewMessage: UpdateNewMessage): Future[void] {.async.}) =
    ## Call the specified procedure when UpdateNewMessage is received
    
    self.eventUpdateNewMessage = some(procedure)
    
proc onUpdates*(self: UpdatesCallback, procedure: proc(updates: UpdatesI): Future[void] {.async.}) =
    ## Call the specified procedure when UpdatesI is received.
    ## You should use this if you want to handle low level updates
    self.callback = some(procedure)

