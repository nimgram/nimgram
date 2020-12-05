import json
import  nimgram/client/rpc/decoding
import nimgram/client/rpc/api
import nimgram/client/rpc/mtproto
import random
import nimgram/client/network/transports
import nimgram/mtproto as mainclient
import asyncdispatch
import typetraits

var mtprotoClient: NimgramClient

proc handleUpdate(updts: UpdatesI): Future[void] {.async.} =
    if updts of api.updates:
        var updatess = updts.updates
        for udpd in updatess.updates:
            if udpd of updateNewMessage:
                var unm = udpd.updateNewMessage
                if unm.message of api.message:
                    var textMessage = unm.message.message
                    var chatID: InputPeerI

                    if textMessage.peer_id of peerUser:
                        chatID = inputPeerUser(user_id: textMessage.peer_id.peerUser.user_id, access_hash: 0)

                    if textMessage.peer_id of peerChat:
                        chatID = inputPeerChat(chat_id: textMessage.peer_id.peerChat.chat_id)    

                    if textMessage.peer_id of peerChannel:
                        chatID = inputPeerChannel(channel_id: textMessage.peer_id.peerChannel.channel_id, access_hash: 0)    
                    randomize()
                    discard await mtprotoClient.send(messages_sendMessage(
                            no_webpage: true,
                            silent: false,
                            background: false,
                            clear_draft: false,
                            peer: chatID,
                            message: $(%*textMessage),
                            random_id: int64(rand(2147483646))
                        ))



proc runClient*(): Future[void] {.async.} =
    
    mtprotoClient  =await initNimgram("session.bin", NimgramConfig(
    testMode: false, 
    transportMode: Abridged,
    apiID: 0,
    apiHash: "0",
    deviceModel: "Nimphone",
    systemVersion: "Nimos 1.0",
    appVersion: "dev",
    systemLangCode: "en",
    langPack: "",
    langCode: "en"))

    try:
        discard await mtprotoClient.send(help_getUserInfo(user_id: inputUserSelf()))
    except:
        echo "logging in..."
        discard await mtprotoClient.send(auth_importBotAuthorization(
              api_id: 0,
            api_hash: "0",
            bot_auth_token: "0:0"
        ))
    
    echo %*await mtprotoClient.send(updates_getState())
    
    mtprotoClient.setCallback(handleUpdate)



when isMainModule:

    asyncCheck runClient()
    runForever()