
# Nimgram
# Copyright (C) 2020-2021 Daniele Cortesi <https://github.com/dadadani>
# This file is part of Nimgram, under the MIT License
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY
# OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

## TL Parser Module

import system
import json
import strutils
import os
import strformat
import times
import tables
type GenResult* = ref object
    constructorsResult: Table[string, string]
    functionsResult: Table[string, string]

type Block = ref object
    encodeBlock: string
    decodeBlock: string
    typesBlock: string
    interfaces: seq[string]

import strformat

const typeUtilsFile = staticRead("static/typeutils.nim")
const encodeFile = staticRead("static/encoding.nim")
const decodingFile = staticRead("static/decoding.nim")
let license = &"## Nimgram\n## Copyright (C) 2020-2021 Daniele Cortesi <https://github.com/dadadani>\n## This file is part of Nimgram, under the MIT License\n##\n## THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY\n## OF ANY KIND, EXPRESS OR\n## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n## SOFTWARE.\n\n## This file was generated automatically by the TL Parser (built at {now()})\n"
proc getPmr(unpmr: string): string =
    if unpmr.split(".").len == 1:
        result = unpmr
        result[0] = result.toUpper()[0]
        return result
    var after = unpmr.split(".")[1]
    after[0] = after.toUpper()[0]
    var before = unpmr.split(".")[0]
    before[0] = before.toUpper()[0]
    return before & after

proc getRealType(tlType: string): string =
    result = toLower(tlType)
    var stint = false
    if result == "int128":
        stint = true
        result = "Int128"
    if result == "int256":
        stint = true
        result = "Int256"
    if not stint:
        result = replace(result, "vector t", "seq")
        result = replace(result, "int", "int32")
        result = replace(result, "long", "int64")
        result = replace(result, "float", "float32")
        result = replace(result, "double", "float64")
        result = replace(result, "bytes", "seq[uint8]")
        result = replace(result, "#", "int32")
        result = replace(result, "object", "TL")

proc convertType(typee: string, genericTypesBlock: var string,
        interfaces: var seq[string], enableFlagsParse: bool = true,
        enableTrueToBool: bool = true): string =
    result = typee
    var tempFlags = ""
    var isVector = false
    var useOption = false
    if result.startsWith("flags"):
        if not enableFlagsParse:
            tempFlags = result.split("?", 1)[0] & "?"
        result = result.split("?", 1)[1]
        if result != "true":
            useOption = true
    if result.replace("vector<", "Vector<").startsWith("Vector<"):
        isVector = true
        result = result.replace("vector<", "Vector<").split("Vector<", 1)[
                1].split(">", 1)[0]
    var pmr = getPmr(result)
    if not interfaces.contains(toLower(pmr)) and not result.startsWith(
            "flags") and not result.startsWith("Vector") and not (toLower(
            result) in @["string", "bool", "true", "int", "long", "double",
            "float", "bytes", "#", "int128", "object", "int256"]):
        interfaces = interfaces & toLower(pmr)
        genericTypesBlock.add(&"    {pmr}I* = ref object of TLObject\n\n")
    if interfaces.contains(toLower(pmr)):
        if isVector:
            if useOption:
                return tempFlags & "Option[seq[" & pmr & "I]]"
            return tempFlags & "seq[" & pmr & "I]"
        else:
            if useOption:
                return tempFlags & "Option[" & pmr & "I]"
            return tempFlags & pmr & "I"


    result = toLower(result)
    var stint = false
    if result == "int128":
        stint = true
        result = "Int128"
    if result == "int256":
        stint = true
        result = "Int256"
    if not stint:
        result = replace(result, "vector t", "seq")
        result = replace(result, "int", "int32")
        if enableTrueToBool:
            result = replace(result, "true", "bool")
        result = replace(result, "long", "int64")
        result = replace(result, "float", "float32")
        result = replace(result, "double", "float64")
        result = replace(result, "bytes", "seq[uint8]")
        result = replace(result, "#", "int32")
        result = replace(result, "object", "TL")

    if isVector:
        result = tempFlags & "seq[" & result & "]"
    if useOption and result != "true":
        result = tempFlags & "Option[" & result & "]"


proc parseParameters(params: JsonNode, genericTypesBlock: var string,
        interfaces: var seq[string]): string =
    # Parses TL objects constructor parameters

    for tlParam in params:
        var typeOriginal = tlParam["typeof"].getStr()
        if typeOriginal == "Type}":
            continue

        var name = tlParam["name"].getStr()

        if typeOriginal == "!X":
            result = result & &"        {name}*: TL\n"
            continue

        let paramType = convertType(typeOriginal, genericTypesBlock, interfaces)
        if name == "out":
            name = "isout"
        if name == "type":
            name = "typeof"
        if name == "static":
            name = "isstatic"
        if name == "flags":
            result = result & &"        {name}: {paramType}\n"
        else:
            result = result & &"        {name}*: {paramType}\n"

proc generateDecode(predicate: string, id: string, params: JsonNode): string =
    result = &"    if self of {predicate}: \n        var tempResult = new {predicate}\n"
    var ok = false
    var useVectorVar = false
    var useObjVar = false
    for param in params:
        var realType = param["typeof"].getStr()
        var paramName = param["name"].getStr()
        if paramName == "{X":
            continue
        if paramName == "out":
            paramName = "isout"
        if paramName == "type":
            paramName = "typeof"
        if paramName == "static":
            paramName = "isstatic"

        if param["typeof"].getStr().startsWith("flags"):
            var flagsNumber = param["typeof"].getStr().split("?")[0].split(".")[1]
            realType = param["typeof"].getStr().split("?")[1]
            ok = true
            if realType == "Vector<bytes>":
                result.add(&"        if (tempResult.flags and (1 shl {flagsNumber})) != 0:\n")
                result.add(&"            tempResult.{paramName} = some(bytes.TLDecodeSeq())\n")
            elif realType == "string":
                result.add(&"        if (tempResult.flags and (1 shl {flagsNumber})) != 0:\n")
                result.add(&"            tempResult.{paramName} = some(cast[string](bytes.TLDecode()))\n")
            elif realType == "Vector<string>":
                result.add(&"        if (tempResult.flags and (1 shl {flagsNumber})) != 0:\n")
                result.add(&"            tempResult.{paramName} = some(cast[seq[string]](bytes.TLDecodeSeq()))\n")
            elif realType == "bytes":
                result.add(&"        if (tempResult.flags and (1 shl {flagsNumber})) != 0:\n")
                result.add(&"            tempResult.{paramName} = some(bytes.TLDecode())\n")
            elif realType in @["int", "long", "float", "double", "#", "Int128", "Int256"]:
                var tempType = getRealType(realType)
                result.add(&"        if (tempResult.flags and (1 shl {flagsNumber})) != 0:\n")
                result.add(&"            var tempVal: {tempType} = 0\n")
                result.add(&"            bytes.TLDecode(addr tempVal)\n            tempResult.{paramName} = some(tempVal)\n")
            elif realType in @["Bool"]:
                var tempType = getRealType(realType)
                result.add(&"        if (tempResult.flags and (1 shl {flagsNumber})) != 0:\n")
                result.add(&"            var tempVal: {tempType}\n")
                result.add(&"            bytes.TLDecode(tempVal)\n            tempResult.{paramName} = some(tempVal)\n")
            elif realType.replace("Vector<", "").replace(">", "") in @["int",
                    "long", "float", "double", "#", "Int128", "Int256"]:
                var tempType = getRealType(realType.replace("Vector<",
                        "").replace(">", ""))
                result.add(&"        if (tempResult.flags and (1 shl {flagsNumber})) != 0:\n")
                result.add(&"            var tempVal = newSeq[{tempType}]()\n")
                result.add(&"            bytes.TLDecode(tempVal)\n            tempResult.{paramName} = some(tempVal)\n")
            elif realType == "true":
                result.add(&"        if (tempResult.flags and (1 shl {flagsNumber})) != 0:\n            tempResult.{paramName} = true\n")
            elif realType.startsWith("Vector<"):

                result.add(&"        if (tempResult.flags and (1 shl {flagsNumber})) != 0:\n")
                var pmr = getPmr(realType.replace("Vector<", "").replace(">", ""))
                result.add(&"            var tempVal = newSeq[TL]()\n")
                result.add(&"            tempVal.TLDecode(bytes)\n            tempResult.{paramName} = some(cast[seq[{pmr}I]](tempVal))\n")
            else:
                result.add(&"        if (tempResult.flags and (1 shl {flagsNumber})) != 0:\n")
                var pmr = getPmr(realType)
                result.add(&"            var tempVal = new TL\n")
                result.add(&"            tempVal.TLDecode(bytes)\n            tempResult.{paramName} = some(tempVal.{pmr}I)\n")
            continue
        if realType == "!X":
            ok = true
            result.add(&"        tempResult.{paramName}.TLDecode(bytes)\n")
        elif realType == "Object":
            ok = true
            result.add(&"        tempResult.{paramName}.TLDecode(bytes)\n")
        elif realType in @["int", "long", "float", "double", "#", "int128", "int256"]:
            ok = true
            result.add(&"        bytes.TLDecode(addr tempResult.{paramName})\n")
        elif realType == "Vector<bytes>":
            ok = true
            result.add(&"        tempResult.{paramName} = bytes.TLDecodeSeq()\n")
        elif realType == "bytes":
            ok = true
            result.add(&"        tempResult.{paramName} = bytes.TLDecode()\n")
        elif realType == "string":
            ok = true
            result.add(&"        tempResult.{paramName} = cast[string](bytes.TLDecode())\n")
        elif realType == "Vector<string>":
            ok = true
            result.add(&"        tempResult.{paramName} = cast[seq[string]](bytes.TLDecodeSeq())\n")
        elif realType in @["Bool"]:
            ok = true
            result.add(&"        bytes.TLDecode(tempResult.{paramName})\n")
        elif realType.replace("Vector<", "").replace(">", "") in @["int",
                "long", "float", "double", "#", "Int128", "Int256"]:
            ok = true
            result.add(&"        bytes.TLDecode(tempResult.{paramName})\n")
        elif realType.startsWith("Vector<"):
            ok = true
            if not useVectorVar:
                useVectorVar = true
                result.add("        var tempVector = newSeq[TL]()\n")
            var pmr = getPmr(realType.replace("Vector<", "").replace(">", ""))
            result.add(&"        tempVector.TLDecode(bytes)\n        tempResult.{paramName} = cast[seq[{pmr}I]](tempVector)\n        tempVector.setLen(0)\n")
        else:
            ok = true
            if not useObjVar:
                useObjVar = true
                result.add("        var tempObj = new TL\n")
            var pmr = getPmr(realType)
            result.add(&"\n        tempObj = new TL\n        tempObj.TLDecode(bytes)\n        tempResult.{paramName} = cast[{pmr}I](tempObj)\n")


    result.add("        self = tempResult.TL\n        return\n")
    if not ok:
        result = &"    if self of {predicate}: \n        return\n"


proc fixTLType(something: string): string =
    var sub = "base"
    var predicate = something
    if predicate.contains("."):
        sub = predicate.split(".")[0]
        predicate = predicate.split(".")[1]

    var subUpper = sub
    subUpper[0] = sub.toUpper()[0]
    predicate[0] = predicate.toUpper()[0]
    if sub != "base":
        predicate = subUpper & predicate
    return predicate



proc generateEncode(predicate: string, id: string, params: JsonNode): string =
    result.add(&"    if self of {predicate}:\n")
    if params.len > 0:
        result.add(&"        var convertedObj = self.{predicate}\n")

    result.add(&"        result = TLEncode(uint32(0x{id}))\n")
    var flagsCode = ""
    var encodeBlock = ""
    for param in params:
        var realType = param["typeof"].getStr()
        var paramName = param["name"].getStr()
        if paramName == "{X":
            continue
        if paramName == "out":
            paramName = "isout"
        if paramName == "type":
            paramName = "typeof"
        if paramName == "static":
            paramName = "isstatic"

        if param["typeof"].getStr().startsWith("flags"):
            var flagsNumber = param["typeof"].getStr().split("?")[0].split(".")[1]
            realType = param["typeof"].getStr().split("?")[1]
            if realType == "true":
                flagsCode.add(&"        if convertedObj.{paramName}:\n                convertedObj.flags = convertedObj.flags or 1 shl {flagsNumber}\n")
            else:
                flagsCode.add(&"        if convertedObj.{paramName}.isSome():\n                convertedObj.flags = convertedObj.flags or 1 shl {flagsNumber}\n")

        if realType != "true":
            if param["typeof"].getStr().contains("?"):
                if param["typeof"].getStr().contains("Vector"):
                    encodeBlock.add(&"        if convertedObj.{paramName}.isSome():\n            result = result & TLEncode(cast[seq[TL]](convertedObj.{paramName}.get()))\n")
                else:
                    encodeBlock.add(&"        if convertedObj.{paramName}.isSome():\n            result = result & TLEncode(convertedObj.{paramName}.get())\n")
            else:
                if param["typeof"].getStr().startsWith("Vector"):
                    var typ = param["typeof"].getStr()

                    if typ.replace("Vector<", "").replace(">", "") in @["int",
                            "long", "int128", "int256", "double", "float", "#"]:
                        encodeBlock.add(&"        result = result & TLEncode(convertedObj.{paramName})\n")
                    else:
                        encodeBlock.add(&"        result = result & TLEncode(cast[seq[TL]](convertedObj.{paramName}))\n")
                else:
                    encodeBlock.add(&"        result = result & TLEncode(convertedObj.{paramName})\n")
    result.add(flagsCode)
    result.add(encodeBlock)

proc generateRawFile*(mtprotoJson, apiJson: JsonNode) =
    echo "generating raw file"
    var decodeCode = "\n"
    var getTypeNameCode = "\n\nproc getTypeName*(self: TL): string =\n"

    var encodeCode = "\n\nproc TLEncode*(self: TL): seq[uint8] =\n"
    var decodeCodeSecond = "    var id: uint32\n    bytes.TLDecode(addr id)\n    case id:\n"
    for methods in mtprotoJson["methods"]:
        var id = methods["id"].getStr()
        encodeCode.add(generateEncode(fixTLType(methods["methodname"].getStr()),
                id, methods["params"]))
    for methods in mtprotoJson["constructors"]:
        var id = methods["id"].getStr()
        encodeCode.add(generateEncode(fixTLType(methods["predicate"].getStr()),
                id, methods["params"]))
    for methods in apiJson["methods"]:
        var id = methods["id"].getStr()
        encodeCode.add(generateEncode(fixTLType(methods["methodname"].getStr()),
                id, methods["params"]))

    for methods in apiJson["constructors"]:
        var id = methods["id"].getStr()
        encodeCode.add(generateEncode(fixTLType(methods["predicate"].getStr()),
                id, methods["params"]))

    encodeCode.add("    if self of GZipPacked:\n        result = TLEncode(uint32(0x3072CFA1))\n        result.add(TLEncode(compress(self.GZipPacked.body.TLEncode())))")
    encodeCode.add("\n    if self of MessageContainer:\n        result = TLEncode(uint32(0x73F1F8DC))\n        result.add(TLEncode(uint32(len(self.MessageContainer.messages))))\n        for i in self.MessageContainer.messages:\n            result.add(TLEncode(i))")



    for methods in mtprotoJson["methods"]:
        var id = methods["id"].getStr()
        var something = fixTLType(methods["methodname"].getStr())
        decodeCode.add(generateDecode(fixTLType(methods["methodname"].getStr()),
                id, methods["params"]))

        getTypeNameCode.add("        if self of " & fixTLType(methods[
                "methodname"].getStr()) & ":\n            return \"" & fixTLType(
                methods["methodname"].getStr()) & "\"\n")

        decodeCodeSecond.add(&"        of uint32(0x{id}):\n            var tmp = TL(new {something})\n            tmp.TLDecode(bytes)\n            self = tmp\n            return\n")
    for methods in mtprotoJson["constructors"]:
        var id = methods["id"].getStr()
        var something = fixTLType(methods["predicate"].getStr())
        decodeCode.add(generateDecode(fixTLType(methods["predicate"].getStr()),
                id, methods["params"]))
        getTypeNameCode.add(&"        if self of " & fixTLType(methods[
                "predicate"].getStr()) & ":\n            return \"" & fixTLType(
                methods["predicate"].getStr()) & "\"\n")

        decodeCodeSecond.add(&"        of uint32(0x{id}):\n            var tmp = TL(new {something})\n            tmp.TLDecode(bytes)\n            self = tmp\n            return\n")
    for methods in apiJson["methods"]:
        var id = methods["id"].getStr()
        var something = fixTLType(methods["methodname"].getStr())
        decodeCode.add(generateDecode(fixTLType(methods["methodname"].getStr()),
                id, methods["params"]))
        getTypeNameCode.add(&"        if self of " & fixTLType(methods[
                "methodname"].getStr()) & ":\n            return \"" & fixTLType(
                methods["methodname"].getStr()) & "\"\n")

        decodeCodeSecond.add(&"        of uint32(0x{id}):\n            var tmp = TL(new {something})\n            tmp.TLDecode(bytes)\n            self = tmp\n            return\n")
    for methods in apiJson["constructors"]:
        var id = methods["id"].getStr()
        var something = fixTLType(methods["predicate"].getStr())
        decodeCode.add(generateDecode(fixTLType(methods["predicate"].getStr()),
                id, methods["params"]))
        getTypeNameCode.add(&"        if self of " & fixTLType(methods[
                "predicate"].getStr()) & ":\n            return \"" & fixTLType(
                methods["predicate"].getStr()) & "\"\n")

        decodeCodeSecond.add(&"        of uint32(0x{id}):\n            var tmp = TL(new {something})\n            tmp.TLDecode(bytes)\n            self = tmp\n            return\n")
    decodeCode.add("    if self of FutureSalts:\n        var futureSalts = FutureSalts()\n        bytes.TLDecode(addr futureSalts.reqMsgID)\n        bytes.TLDecode(addr futureSalts.now)\n        var lenght: int32\n        bytes.TLDecode(addr lenght)\n        for _ in countup(1, lenght):\n            var tmp = TL(new FutureSalt)\n            tmp.TLDecode(bytes)\n            futureSalts.salts.add(tmp.FutureSalt)\n        self = futureSalts.TL\n        return\n")
    decodeCode.add("    if self of FutureSalt:\n        var salt = FutureSalt()\n        bytes.TLDecode(addr salt.validSince) \n        bytes.TLDecode(addr salt.validUntil)\n        bytes.TLDecode(addr salt.salt)  \n        self = salt.TL\n        return\n")
    decodeCode.add("    if self of MessageContainer:\n        var container = MessageContainer()\n        var lenght: uint32\n        bytes.TLDecode(addr lenght)\n        for _ in countup(1, int(lenght)):\n            var tmp = new CoreMessage\n            tmp.TLDecode(bytes)\n            container.messages.add(tmp)\n        self = container.TL\n        return\n")
    decodeCode.add("    if self of GZipPacked:\n        var data = newScalingSeq(uncompress(bytes.TLDecode()))\n        var packed = GZipPacked()\n        packed.body.TLDecode(data)\n        self = TL(packed)\n        return\n")


    decodeCodeSecond.add(&"        of uint32(812830625):\n            var tmp = TL(new GZipPacked)\n            tmp.TLDecode(bytes)\n            self = tmp\n            return\n")
    decodeCodeSecond.add(&"        of uint32(1945237724):\n            var tmp = TL(new MessageContainer)\n            tmp.TLDecode(bytes)\n            self = tmp\n            return\n")
    decodeCodeSecond.add(&"        of uint32(2924480661):\n            var tmp = TL(new FutureSalts)\n            tmp.TLDecode(bytes)\n            self = tmp\n            return\n")
    decodeCodeSecond.add(&"        of uint32(155834844):\n            var tmp = TL(new FutureSalt)\n            tmp.TLDecode(bytes)\n            self = tmp\n            return\n")
    echo "generated types"
    decodeCode = "\nproc TLDecode*(self: var TL, bytes: var ScalingSeq[uint8]) = \n" &
            decodeCode & decodeCodeSecond & "        else:\n            raise newException(CatchableError, &\"Constructor {id} was not found\")"
    var layerversion = apiJson["layer"].getInt()
    writeFile("rpc/raw.nim", typeUtilsFile &
            &"const LAYER_VERSION* = {layerversion}\n" & decodeCode &
            encodeCode & getTypeNameCode)

proc tlParse*(jsonData: JsonNode, generateTypes: bool, useCore: bool,
        genericTypesBlock: var string, interfaces: var seq[string]) =
    var code: Table[string, Block]
    var predicategetter = "methodname"
    if generateTypes:
        predicategetter = "predicate"
    for obj in jsonData:
        var sub = "base"
        var predicate = obj[predicategetter].getStr()
        if predicate.contains("."):
            sub = predicate.split(".")[0]
            predicate = predicate.split(".")[1]

        var subUpper = sub
        subUpper[0] = sub.toUpper()[0]
        predicate[0] = predicate.toUpper()[0]
        if sub != "base":
            predicate = subUpper & predicate
        if not code.contains(sub):
            code[sub] = Block()
        if generateTypes:
            var pmr = getPmr(obj["typeof"].getStr())
            if not interfaces.contains(pmr.toLower()):
                genericTypesBlock = genericTypesBlock & &"    {pmr}I* = ref object of TLObject\n\n"
                interfaces.add(pmr.toLower())
        if generateTypes:
            var pmr = getPmr(obj["typeof"].getStr())
            code[sub].typesBlock.add(&"    {predicate}* = ref object of {pmr}I\n" &
                    parseParameters(obj["params"], genericTypesBlock, interfaces))
        else:
            code[sub].typesBlock.add(&"    {predicate}* = ref object of TLFunction\n" &
                    parseParameters(obj["params"], genericTypesBlock, interfaces))
    var subs = newSeq[string]()
    for sub, _ in code:
        if sub != "base":
            subs.add(sub)

    for sub, blok in code:
        var dirname = "functions"
        var imports = ""
        var sectionimport = ""
        if subs.len > 0:
            sectionimport = "include " & join(subs, ", ")
        if generateTypes:
            dirname = "types"
        if useCore:
            dirname = &"core/{dirname}"
        if not dirExists(&"rpc/{dirname}"):
            createDir(&"rpc/{dirname}")
        if sub == "base":
            if generateTypes:
                writeFile(&"rpc/{dirname}/{sub}.nim", license & imports &
                        "\ntype\n" & genericTypesBlock & sectionimport &
                        "\ntype\n" & blok.typesBlock & "\n" & "\n")
            else:
                writeFile(&"rpc/{dirname}/{sub}.nim", license & imports &
                        sectionimport & "\ntype\n" & blok.typesBlock & "\n")
        else:
            writeFile(&"rpc/{dirname}/{sub}.nim", license & imports & "type\n" &
                    blok.typesBlock & "\n")

        writeFile("rpc/encoding.nim", encodeFile)
        writeFile("rpc/decoding.nim", decodingFile)


proc parse*(jsonData: JsonNode, useCore: bool) =
    # Parses a jsonified TL schema

        var genericTypesBlock = ""
        var interfaces = newSeq[string]()
        echo "- Parsing functions"
        tlParse(jsonData["methods"], false, useCore, genericTypesBlock, interfaces)
        echo "- Parsing types"
        tlParse(jsonData["constructors"], true, useCore, genericTypesBlock, interfaces)


