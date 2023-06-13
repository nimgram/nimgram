# Nimgram
# Copyright (C) 2020-2023 Daniele Cortesi <https://github.com/dadadani>
# This file is part of Nimgram, under the MIT License
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

const COPYRIGHT_CODE = """# Nimgram
# Copyright (C) 2020-2023 Daniele Cortesi <https://github.com/dadadani>
# This file is part of Nimgram, under the MIT License
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

"""

import pkg/tlparser_api
import std/strutils, std/strformat, std/tables

proc replaceType(`type`: string): string =
    return `type`.multiReplace(("Bool", "bool"), ("int53", "int64"), ("double", "float64"), ("bytes", "seq[uint8]"))

proc parseParameters(parameters: seq[TLApiParameter], decodeGeneric = false): string = 
    for parameter in parameters:
        var splitName = parameter.name.split("_")
        var name = splitName[0]
        var callName = ""
        if parameter.`type`.multiReplace(("vector<", ""), (">", "")) in ["Bool","int53", "string", "bytes", "double", "int64", "int32"]:
            if parameter.`type`.startsWith("vector<"):
                var strip = parameter.`type`
                strip.removePrefix("vector<")
                strip.removeSuffix(">")
                strip = strip.multiReplace(("vector<", "seq["), (">", "]"))
                callName = &".decodeJsonVector[:{replaceType(strip)}]()"
            else:
                callName = &".decodeJson[:{replaceType(parameter.`type`)}]()"
        else:
            if parameter.`type`.startsWith("vector<"):
                var strip = parameter.`type`
                strip.removePrefix("vector<")
                strip.removeSuffix(">")
                strip = strip.multiReplace(("vector<", "seq["), (">", "]"))
                callName = &".decodeJsonGenericVector[:{strip}]()"
            else:
                callName = &".decodeJsonGeneric[:{parameter.`type`}]()"
        if splitName.len > 1:
            for namePart in splitName[1..splitName.high]:
                var namePart = namePart
                namePart[0] = toUpperAscii(namePart[0])
                name.add(namePart)
        var eq = " = "
        if decodeGeneric:
            eq = ": "
        result.add(&"{name}{eq}body[\"{parameter.name}\"]{callName}, ")



proc genTypesToJson(api: TLApi, file: File) =
    file.write(COPYRIGHT_CODE & """import std/json
import ../src/nimgram/private/api/api
import ../src/nimgram/private/api/json/jsonapi

import tp

""")

    var codeBlocks: Table[string, string]

    for class in api.classes:
        var nameCode = class.name
        nameCode[0] = toUpperAscii(nameCode[0])
        
        var ifcode = "elif"

        if not codeBlocks.contains(class.rootObject):
            ifcode = "if"
            codeBlocks[class.rootObject] = &"proc `%*`*(obj: {class.rootObject}): JsonNode = \n"

        codeBlocks[class.rootObject].add(&"""
    {ifcode} obj of {nameCode}:
        result = newJObject()
""")
        if class.parameters.len > 0:
            codeBlocks[class.rootObject].add(&"        let originalObject = obj.{nameCode}\n")
        for parameter in class.parameters:
            var splitName = parameter.name.split("_")

            var name = splitName[0]

            if splitName.len > 1:
                for namePart in splitName[1..splitName.high]:
                    var namePart = namePart
                    namePart[0] = toUpperAscii(namePart[0])
                    name.add(namePart)

            codeBlocks[class.rootObject].add(&"        result[\"{parameter.name}\"] = %*originalObject.{name}\n")    

        codeBlocks[class.rootObject].add(&"""
        result["@type"] = %*"{class.name}" 
""")



    for _, v in codeBlocks:
        file.write(v)

proc genFunctions(api: TLApi, file: File) =
    
    file.write(COPYRIGHT_CODE & """import std/json, std/asyncdispatch, std/asyncstreams

import ../src/nimgram/private/api/api
import ../src/nimgram/private/api/json/jsonapi
import ../src/nimgram/private/utils/exceptions

import tp, types

proc readFunction*(infoThread: ptr ThreadInfo, body: JsonNode) {.async.}  =
    var result: JsonNode 
    try:
        case body["@type"].getStr("none"):
""")
    for function in api.functions:
        if function.rootObject == "Ok":
            file.write(&"        of \"{function.name}\":\n            await infoThread.client.{function.name}({parseParameters(function.parameters)})\n            result = %*Ok()\n            result[\"@type\"] = %*\"ok\"\n")
        else:
            var replyObject = function.rootObject
            replyObject[0] = toUpperAscii(replyObject[0])
            file.write(&"        of \"{function.name}\":\n            result = %*(await infoThread.client.{function.name}({parseParameters(function.parameters)}))\n")

    file.write("""
        else:
            raise newException(FieldDefect, "Cannot find type name")
    except exceptions.RPCError as ex:
        result = %*Error(code: int32(ex.errorCode), message: ex.errorMessage)
    except Exception as ex:
        result = %*Error(code: 600, message: ex.msg) 

    if body.contains("@extra"):
        result["@extra"] = body["@extra"]
    
    await infoThread.answers.write($result)""")
    file.close()

proc genTypesFromJson(api: TLApi, file: File) =

    var codeBlocks: Table[string, string]

    file.write("""
proc decodeJsonGeneric*[T](body: JsonNode): T

proc decodeJsonGenericVector*[T](body: JsonNode): seq[T] = 
    when T is seq:
        for elem in body:
            result.add(decodeJsonGenericVector[T](elem))
    else:
        for elem in body:
            result.add(decodeJsonGeneric[T](elem))

proc decodeJsonGeneric*[T](body: JsonNode): T =
    
""")
    for class in api.classes:
        var nameCode = class.name
        nameCode[0] = toUpperAscii(nameCode[0])
        
        var ifcode = "elif"

        if not codeBlocks.contains(class.rootObject):
            ifcode = "if"
            codeBlocks[class.rootObject] = &"T is {class.rootObject}:\n"
        
        codeBlocks[class.rootObject].add(&"        {ifcode} body[\"@type\"].getStr() == \"{class.name}\":\n            return {nameCode}({parseParameters(class.parameters, true)})\n")
        
    var whenCode = "when"
    for _, v in codeBlocks:
        file.write(&"    {whenCode} {v}")
        whenCode = "elif"



when isMainModule:
    let api = parseFile("bindings/builder/nimgram_api.tl")
    var file = open("bindings/types.nim", fmWrite)

    genTypesToJson(api, file)
    genTypesFromJson(api, file)
    file.close()
    file = open("bindings/functions.nim", fmWrite)
    genFunctions(api, file)

