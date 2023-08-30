import std/json
import ../src/nimgram/private/api/api, ../src/nimgram/private/api/json/jsonapi 
import ../src/nimgram/private/utils/exceptions
import ../src/nimgram/private/api/macros

# remove
import  ../src/nimgram/private/api/texample
import std/logging, std/asyncdispatch

template expectParameter(node: JsonNode, parameter: string, kind: JsonNodeKind, optional = false) =
    if not node.contains(parameter) and kind != JBool and not optional:
        raise newException(KeyError, "Invalid parameter " & parameter) 
    if kind == JString and node[parameter].getStr().len == 0:
        raise newException(ValueError, "Invalid value of parameter " & parameter)


proc nimgramApiJson[T](obj: T): JsonNode {.NimgramJsonEncoder.}

echo nimgramApiJson(AuthorizationStateClosing().AuthorizationState)

echo nimgramApiJson(AuthorizationStateLoggingOut().AuthorizationState)

echo nimgramApiJson(UpdateAuthorizationState(authorizationState: AuthorizationStateReady().AuthorizationState).Update)

echo nimgramApiJson(Ok())

proc nimgramApiFromJson[T](json: JsonNode): T {.NimgramJsonDecoder.} 

echo nimgramApiFromJson[Update](parseJson("""{"@type": "UpdateAuthorizationState", "authorizationState": {"@type": "AuthorizationStateClosing"}}"""))

proc decodeFunction(client: NimgramClient, json: sink JsonNode): Future[JsonNode] {.NimgramFunctionDecoder, async.}

when isMainModule:
    addHandler(newConsoleLogger())

    let c = NimgramClient()
    echo waitFor decodeFunction(c, parseJson("""{"@type": "testFunction", "a": {"@type": "BaseTestTypeVariant", "vari": "nimgramhello", "hi": "nimgramhi", "lovem": 4}}"""))
