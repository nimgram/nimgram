import json
import  nimgram/client/rpc/decoding
import nimgram/client/rpc/raw
import random
import nimgram/client/network/transports
import nimgram/mtproto as mainclient
import asyncdispatch
import typetraits

var mtprotoClient: NimgramClient

proc handleUpdate(updts: UpdatesI): Future[void] {.async.} =
    if updts of raw.Updates:
        var updatess = updts.Updates
        for udpd in updatess.updates:
            if udpd of UpdateNewMessage:
                var unm = udpd.UpdateNewMessage
                if unm.message of raw.Message:
                    var textMessage = unm.message.Message
                    var chatID: InputPeerI

                    if textMessage.peer_id of PeerUser:
                        chatID = InputPeerUser(user_id: textMessage.peer_id.PeerUser.user_id, access_hash: 0)

                    if textMessage.peer_id of PeerChat:
                        chatID = InputPeerChat(chat_id: textMessage.peer_id.PeerChat.chat_id)    

                    if textMessage.peer_id of PeerChannel:
                        chatID = InputPeerChannel(channel_id: textMessage.peer_id.PeerChannel.channel_id, access_hash: 0)    
                    randomize()
                    discard await mtprotoClient.send(MessagesSendMessage(
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
        discard await mtprotoClient.send(UsersGetFullUser(id: InputUserSelf()))
    except:
        echo getCurrentExceptionMsg()
        echo "logging in..."
        discard await mtprotoClient.send(AuthImportBotAuthorization(
              api_id: 0,
            api_hash: "0",
            bot_auth_token: "0:0"
        ))
    
    echo %*await mtprotoClient.send(UpdatesGetState())
    
    mtprotoClient.setCallback(handleUpdate)



when isMainModule:

    asyncCheck runClient()
    runForever()