import ../src/nimgram/private/storage/[sqlite, storage_interfaces]
import std/logging, std/asyncdispatch, std/options

proc main =
    var consoleLog = newConsoleLogger()
    addHandler(consoleLog)  
    let storage = newSqliteStorage("nimgram-session.db").NimgramStorage

    waitFor storage.addOrEditSession(4, true, true, @[200'u8], @[0'u8, 0,0,0,5,0,0,0], true)
    doAssert (waitFor storage.getSession(4, true, true)) == (@[200'u8], @[0'u8, 0,0,0,5,0,0,0])
    waitFor storage.addOrEditSession(4, true, true, @[255'u8], @[0'u8, 0,0,1,5,0,0,0], true)
    doAssert (waitFor storage.getDefaultSession()) == (4, true, true, @[255'u8], @[0'u8, 0,0,1,5,0,0,0])
    waitFor storage.addOrEditSession(4, false, false, @[100'u8, 100], @[7'u8, 78,0,0,5,0,0,0], false)
    doAssert (waitFor storage.getSession(4, false, false)) == (@[100'u8, 100], @[7'u8, 78,0,0,5,0,0,0])

    waitFor storage.addOrEditPeer(397112340, 46585)
    doAssert (waitFor storage.getPeer(397112340)) == (46585'i64, none(string))
    waitFor storage.addOrEditPeer(397112340, 44444)
    doAssert (waitFor storage.getPeer(397112340)) == (44444'i64, none(string))
    waitFor storage.addOrEditPeer(397112340, 33333, "cagatemi")
    doAssert (waitFor storage.getPeer(397112340)) == (33333'i64, some("cagatemi"))
    waitFor storage.addOrEditPeer(-1001670814413, 2563, "anewchannel34")
    doAssert (waitFor storage.getPeer("anewchannel34")) == (-1001670814413'i64, 2563'i64)

when isMainModule:
    main()