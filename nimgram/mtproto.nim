import client/rpc/api
import client/storage
import client/network/transports
import asyncdispatch
import client/rpc/static
import client/session

type NimgramClient = ref object 
    mainSession: Session

proc initNimgram*(databinFile: string): Future[NimgramClient] {.async.} = 
    result = new NimgramClient
    var autsalt = await authSalt(databinFile)
    if autsalt.connectionOpened:
        result.mainSession = initSession(autsalt.connection, 2, autsalt.authKey, autsalt.salt, databinFile)
    else:
        var connection = await newConnection("149.154.167.40", 443, Intermediate) 
        result.mainSession = initSession(connection, 2, autsalt.authKey, autsalt.salt, databinFile)

proc send*(self: NimgramClient, function: TLFunction): Future[CoreMessage] {.async.} =
    result = await self.mainSession.send(function)