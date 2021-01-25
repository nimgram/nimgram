import json
import random
import src/nimgram
import asyncdispatch
import typetraits

var mtprotoClient: NimgramClient

proc handleMessage(message: UpdateNewMessage): Future[void] {.async.} =
    if message.message of Message:
        var textMessage = message.message.Message
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
    mtprotoClient = await initNimgram("nimgram-session.bin", NimgramConfig(
        testMode: false, 
        transportMode: NetTcpAbridged,
        apiID: 0,
        apiHash: "0",
        deviceModel: "Nimphone",
        systemVersion: "Nimos 1.0",
        appVersion: "dev",
        systemLangCode: "en",
        langPack: "",
        langCode: "en",
        useIpv6: false,
        disableCache: false
    ), StorageRam)
    await mtprotoClient.botLogin("0:0")
    discard await mtprotoClient.send(UpdatesGetState())
    mtprotoClient.onUpdateNewMessage(handleMessage)
    echo "Client started"



when isMainModule:
    
    asyncCheck runClient()
    runForever()