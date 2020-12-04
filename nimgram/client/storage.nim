import nimcrypto
import os
import network/transports
import utils/auth_key
import asyncfile, asyncdispatch


type BinData* = object 
    authKey*: seq[uint8]
    connectionOpened*: bool
    connection*: TcpNetwork
    salt*: seq[uint8]



proc loadBin(filename: string): Future[BinData] {.async.} = 
    try:
        var file = openAsync(filename)
        var data = cast[seq[uint8]](await file.readAll())
        #load hash
        var hash = data[0..31]
        var realdata = data[32..(data.len-1)]
        if sha256.digest(realdata).data[0..31] != hash:
            raise newException(Exception, "integrity check failed")
        file.close()
        return BinData(salt: realdata[0..7], authKey: realdata[8..(realdata.len-1)], connectionOpened: false)
    except:
        raise
        #raise newException(Exception, "failed opening client data binary")



proc createBin*(authKey: seq[uint8], salt: seq[uint8], filename: string) {.async.} = 
    try:
        if salt.len != 8 and authKey.len != 256:
            raise newException(Exception, "incorrect sizes")
        var data = salt & authKey
        data = sha256.digest(data).data[0..31] & data
        var files = openAsync(filename, FileMode.fmWrite)
        await files.write(cast[string](data))
        files.close()
    except:
        raise newException(Exception, "failed creating client data binary")
    


proc authSalt*(filename: string): Future[BinData] {.async.} =
    if fileExists(filename):
        return await loadBin(filename)
    else:
        #TODO: Load from configuration
        var connection = await newConnection("149.154.167.40", 443, Abridged) 
        var data = await generateAuthKey(connection)
        await createBin(data[0], data[1], filename)
        connection.close()
        return BinData(authKey: data[0], salt: data[1], connectionOpened: false)
