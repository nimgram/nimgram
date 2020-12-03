import json
import  nimgram/client/rpc/decoding
import nimgram/client/rpc/api
import nimgram/client/rpc/mtproto
import nimgram/client/rpc/static
import nimgram/mtproto as mainclient
import asyncdispatch
        
when isMainModule:


    var client =  initNimgram("session.bin").waitFor
    var resultf = client.send(ping(ping_id: 8585)).waitFor
    
    #Currently is not possible to go any longer (Except initConnection) because the server will reply with bad_msg_notification with error 33 (this should never happen)
