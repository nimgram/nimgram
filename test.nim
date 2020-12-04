import json
import  nimgram/client/rpc/decoding
import nimgram/client/rpc/api
import nimgram/client/rpc/mtproto
import random
import nimgram/client/rpc/static
import nimgram/mtproto as mainclient
import asyncdispatch
import typetraits
    
proc runClient*(): Future[void] {.async.} =
    var client =await initNimgram("session.bin")
    var resultf = await client.send(ping(ping_id: 8585))
    if resultf of pong:
        echo "Pong! ID: ", resultf.pong.ping_id
    resultf = await client.send(invokeWithLayer(layer: 120, query: initConnection(
        api_id: 0,
        device_model: "Client",
        system_version: "Nim OS",
        app_version: "0.1",
        system_lang_code: "en",
        lang_pack: "",
        lang_code: "en",
        query: help_getConfig())))
    
    if resultf of config:
        echo %*resultf.config
    
when isMainModule:

    runClient().waitFor()
    