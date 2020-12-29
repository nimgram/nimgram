import json
import random
import src/nimgram
import asyncdispatch
import typetraits

var mtprotoClient: NimgramClient

proc handleUpdate(updts: UpdatesI): Future[void] {.async.} =
    if updts of Updates:
        var updatess = updts.Updates
        for udpd in updatess.updates:
            if udpd of UpdateNewMessage:
                var unm = udpd.UpdateNewMessage
                if unm.message of Message:
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
    ## Threads are required to be enabled using --threads:on
    ## Or use StorageRam
    mtprotoClient = await initNimgram("nimgram.db", NimgramConfig(
        testMode: false, 
        transportMode: NetTcpAbridged,
        apiID: 0,
        apiHash: "yours",
        deviceModel: "Nimphone",
        systemVersion: "Nimos 1.0",
        appVersion: "dev",
        systemLangCode: "en",
        langPack: "",
        langCode: "en",
        useIpv6: false,
        disableCache: false
    ), StorageSqlite)

    await mtprotoClient.botLogin("0:0")
    discard await mtprotoClient.send(UpdatesGetState())
    echo "Listening for updates"
    mtprotoClient.setCallback(handleUpdate)



when isMainModule:
    
    runClient().waitFor
    runForever()