
## Nimgram
## Copyright (C) 2020-2021 Daniele Cortesi <https://github.com/dadadani>
## This file is part of Nimgram, under the MIT License
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY
## OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
## SOFTWARE.

## TL Parser Module

import system
import sam
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
    getTypeNameBlock: string
    typesBlock: string
    interfaces: seq[string]

import strformat

const typeUtilsFile = staticRead("static/typeutils.nim")
const encodeFile = staticRead("static/encoding.nim")
const decodingFile = staticRead("static/decoding.nim")
const LOCKS = "{.locks: \"unknown\".}"
let license = &"## Nimgram\n## Copyright (C) 2020-2021 Daniele Cortesi <https://github.com/dadadani>\n## This file is part of Nimgram, under the MIT License\n##\n## THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY\n## OF ANY KIND, EXPRESS OR\n## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n## SOFTWARE.\n\n## This file was generated automatically by the TL Parser (built at {now()})\n"
proc getPmr(unpmr: string): string =
    if unpmr.split(".").len == 1:
        result = unpmr
        result[0] = result.toUpper()[0]
        return result
    var after= unpmr.split(".")[1]
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

proc convertType(typee: string, genericTypesBlock: var string, interfaces: var seq[string], enableFlagsParse: bool = true, enableTrueToBool: bool = true): string =
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
        result = result.replace("vector<", "Vector<").split("Vector<", 1)[1].split(">", 1)[0]
    var pmr = getPmr(result)
    #var pmr = result.replace(".", "_").replace("vector<", "").replace(">", "").replace("%", "")
    if not interfaces.contains(toLower(pmr)) and not result.startsWith("flags") and not result.startsWith("Vector") and not (toLower(result) in @["string", "bool", "true", "int", "long", "double", "float", "bytes", "#", "int128", "object", "int256"]):
        interfaces = interfaces & toLower(pmr)
        genericTypesBlock.add(&"    {pmr}I* = ref object of TLObject\n\n")
    if interfaces.contains(toLower(pmr)): 
        if isVector:
            if useOption:
                return tempFlags & "Option[seq[" & pmr & "I]]"
            return  tempFlags & "seq[" & pmr & "I]"
        else:
            if useOption:
               return  tempFlags & "Option[" & pmr & "I]"
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


proc parseParameters(params: JsonNode, genericTypesBlock: var string, interfaces: var seq[string]): string =
    # Parses TL objects constructor parameters

    for tlParam in params:
        var typeOriginal = tlParam["typeof"].toStr()
        if typeOriginal == "Type}":
            continue
        
        var name = tlParam["name"].toStr()

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

proc generateDecode(predicate: string, params: JsonNode): string =
    result = &"method TLDecode*(self: {predicate}, bytes: var ScalingSeq[uint8]) {LOCKS} = \n"
    var ok = false    
    #var flagsCode = ""
    #var decodeBlock = ""
    var useVectorVar = false
    var useObjVar = false
    for param in params:
        var realType = param["typeof"].toStr()
        var paramName = param["name"].toStr()
        if paramName == "{X":
            continue
        if paramName == "out":
            paramName = "isout"
        if paramName == "type":
            paramName = "typeof"
        if paramName == "static":
            paramName = "isstatic"

        if param["typeof"].toStr().startsWith("flags"):
            var flagsNumber = param["typeof"].toStr().split("?")[0].split(".")[1]
            realType = param["typeof"].toStr().split("?")[1]
            ok = true
            if realType == "Vector<bytes>":
                result.add(&"    if (self.flags and (1 shl {flagsNumber})) != 0:\n")
                result.add(&"        self.{paramName} = some(bytes.TLDecodeSeq())\n")
            elif realType == "string":
                result.add(&"    if (self.flags and (1 shl {flagsNumber})) != 0:\n")
                result.add(&"        self.{paramName} = some(cast[string](bytes.TLDecode()))\n")
            elif realType == "Vector<string>":
                result.add(&"    if (self.flags and (1 shl {flagsNumber})) != 0:\n")
                result.add(&"        self.{paramName} = some(cast[seq[string]](bytes.TLDecodeSeq()))\n")
            elif realType == "bytes":
                result.add(&"    if (self.flags and (1 shl {flagsNumber})) != 0:\n")
                result.add(&"        self.{paramName} = some(bytes.TLDecode())\n")
            elif realType in @["int", "long", "float", "double", "#", "Int128", "Int256"]:
                var tempType = getRealType(realType)
                result.add(&"    if (self.flags and (1 shl {flagsNumber})) != 0:\n")
                result.add(&"        var tempVal: {tempType} = 0\n")
                result.add(&"        bytes.TLDecode(addr tempVal)\n        self.{paramName} = some(tempVal)\n")
            elif realType in @["Bool"]:
                var tempType = getRealType(realType)
                result.add(&"    if (self.flags and (1 shl {flagsNumber})) != 0:\n")
                result.add(&"        var tempVal: {tempType}\n")
                result.add(&"        bytes.TLDecode(tempVal)\n        self.{paramName} = some(tempVal)\n")
            elif realType.replace("Vector<", "").replace(">", "") in @["int", "long", "float", "double", "#", "Int128", "Int256"]:
                var tempType = getRealType(realType.replace("Vector<", "").replace(">", "") )
                result.add(&"    if (self.flags and (1 shl {flagsNumber})) != 0:\n")
                result.add(&"        var tempVal = newSeq[{tempType}]()\n")
                result.add(&"        bytes.TLDecode(tempVal)\n        self.{paramName} = some(tempVal)\n")
            elif realType == "true":
                #echo paramName
                result.add(&"    if (self.flags and (1 shl {flagsNumber})) != 0:\n        self.{paramName} = true\n")
            elif realType.startsWith("Vector<"):

                result.add(&"    if (self.flags and (1 shl {flagsNumber})) != 0:\n")
                var pmr = getPmr(realType.replace("Vector<", "").replace(">", ""))
                result.add(&"        var tempVal = newSeq[TL]()\n")
                result.add(&"        tempVal.TLDecode(bytes)\n        self.{paramName} = some(cast[seq[{pmr}I]](tempVal))\n")
            else:
                result.add(&"    if (self.flags and (1 shl {flagsNumber})) != 0:\n")
                var pmr = getPmr(realType)
                result.add(&"        var tempVal = new TL\n")
                result.add(&"        tempVal.TLDecode(bytes)\n        self.{paramName} = some(tempVal.{pmr}I)\n")
            continue
        if realType == "!X":
            ok = true
            result.add(&"    self.{paramName}.TLDecode(bytes)\n")
        elif realType == "Object":
            ok = true
            result.add(&"    self.{paramName}.TLDecode(bytes)\n")
        elif realType in @["int", "long", "float", "double", "#", "int128", "int256"]:
            ok = true
            result.add(&"    bytes.TLDecode(addr self.{paramName})\n")
        elif realType == "Vector<bytes>":
            ok = true
            result.add(&"    self.{paramName} = bytes.TLDecodeSeq()\n")
        elif realType == "bytes":
            ok = true
            result.add(&"    self.{paramName} = bytes.TLDecode()\n")
        elif realType == "string":
            ok = true
            result.add(&"    self.{paramName} = cast[string](bytes.TLDecode())\n")
        elif realType == "Vector<string>":
            ok = true
            result.add(&"    self.{paramName} = cast[seq[string]](bytes.TLDecodeSeq())\n")
        elif realType in @["Bool"]:
            ok = true
            result.add(&"    bytes.TLDecode(self.{paramName})\n")
        elif realType.replace("Vector<", "").replace(">", "") in @["int", "long", "float", "double", "#", "Int128", "Int256"]:
            ok = true
            result.add(&"    bytes.TLDecode(self.{paramName})\n")
        elif realType.startsWith("Vector<"):
            ok = true
            if not useVectorVar:
                useVectorVar = true
                result.add("    var tempVector = newSeq[TL]()\n")
            var pmr = getPmr(realType.replace("Vector<", "").replace(">", ""))
            result.add(&"    tempVector.TLDecode(bytes)\n    self.{paramName} = cast[seq[{pmr}I]](tempVector)\n    tempVector.setLen(0)\n")
        else:
            ok = true
            if not useObjVar:
                useObjVar = true
                result.add("    var tempObj = new TL\n")
            var pmr = getPmr(realType)
            result.add(&"    tempObj.TLDecode(bytes)\n    self.{paramName} = cast[{pmr}I](tempObj)\n")


        
    if not ok:
        result.add("    discard\n")


proc getSomething(something: string): string = 
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
proc generateRawFile*(mtprotoJson, apiJson: JsonNode) =
    echo "generating raw file"
    var copv = "        var id: uint32\n        bytes.TLDecode(addr id)\n        case id:\n"
    for methods in mtprotoJson["methods"]:
        var id = methods["id"].toStr()
        var something = getSomething(methods["methodname"].toStr())
        copv.add(&"        of uint32(0x{id}):\n            var tmp = new {something}\n            tmp.TLDecode(bytes)\n            self = tmp\n            return\n")
    for methods in mtprotoJson["constructors"]:
        var id = methods["id"].toStr()
        var something = getSomething(methods["predicate"].toStr())
        copv.add(&"        of uint32(0x{id}):\n            var tmp = new {something}\n            tmp.TLDecode(bytes)\n            self = tmp\n            return\n")
    for methods in apiJson["methods"]:
        var id = methods["id"].toStr()
        var something = getSomething(methods["methodname"].toStr())
        copv.add(&"        of uint32(0x{id}):\n            var tmp = new {something}\n            tmp.TLDecode(bytes)\n            self = tmp\n            return\n")
    for methods in apiJson["constructors"]:
        var id = methods["id"].toStr()
        var something = getSomething(methods["predicate"].toStr())
        copv.add(&"        of uint32(0x{id}):\n            var tmp = new {something}\n            tmp.TLDecode(bytes)\n            self = tmp\n            return\n")
    copv.add(&"        of uint32(812830625):\n            var tmp = new GZipPacked\n            tmp.TLDecode(bytes)\n            self = tmp\n            return\n")
    copv.add(&"        of uint32(1945237724):\n            var tmp = new MessageContainer\n            tmp.TLDecode(bytes)\n            self = tmp\n            return\n")
    copv.add(&"        of uint32(2924480661):\n            var tmp = new FutureSalts\n            tmp.TLDecode(bytes)\n            self = tmp\n            return\n")
    copv.add(&"        of uint32(155834844):\n            var tmp = new FutureSalt\n            tmp.TLDecode(bytes)\n            self = tmp\n            return\n")
    echo "generated types"
    copv = "\nproc TLDecode*(self: var TL, bytes: var ScalingSeq[uint8]) = \n" & copv & "\n        else:\n            raise newException(CatchableError, &\"Key {id} was not found\")"
    var layerversion = apiJson["layer"].toInt()
    writeFile("rpc/raw.nim", typeUtilsFile & &"const LAYER_VERSION* = {layerversion}\n" & copv)



proc generateEncode(predicate: string, id: string, params: JsonNode): string =
    result = &"method TLEncode*(self: {predicate}): seq[uint8] {LOCKS} =\n"
    result.add(&"    result = TLEncode(uint32(0x{id}))\n")    
    var flagsCode = ""
    var encodeBlock = ""
    for param in params:
        var realType = param["typeof"].toStr()
        var paramName = param["name"].toStr()
        if paramName == "{X":
            continue
        if paramName == "out":
            paramName = "isout"
        if paramName == "type":
            paramName = "typeof"
        if paramName == "static":
            paramName = "isstatic"

        if param["typeof"].toStr().startsWith("flags"):
            var flagsNumber = param["typeof"].toStr().split("?")[0].split(".")[1]
            realType = param["typeof"].toStr().split("?")[1]
            if realType == "true":
                flagsCode.add(&"    if self.{paramName}:\n        self.flags = self.flags or 1 shl {flagsNumber}\n")
            else:
                flagsCode.add(&"    if self.{paramName}.isSome():\n        self.flags = self.flags or 1 shl {flagsNumber}\n")

        if realType != "true":
            if param["typeof"].toStr().contains("?"):
                if param["typeof"].toStr().contains("Vector"):
                    encodeBlock.add(&"    if self.{paramName}.isSome():\n        result = result & TLEncode(cast[seq[TL]](self.{paramName}.get()))\n")
                else:
                    encodeBlock.add(&"    if self.{paramName}.isSome():\n        result = result & TLEncode(self.{paramName}.get())\n")
            else:
                if param["typeof"].toStr().startsWith("Vector"):
                    var typ = param["typeof"].toStr()

                    if typ.replace("Vector<", "").replace(">", "") in @["int", "long", "int128", "int256", "double", "float", "#"]:
                        encodeBlock.add(&"    result = result & TLEncode(self.{paramName})\n")
                    else:
                        encodeBlock.add(&"    result = result & TLEncode(cast[seq[TL]](self.{paramName}))\n")
                else:
                    encodeBlock.add(&"    result = result & TLEncode(self.{paramName})\n")
    result.add(flagsCode)
    result.add(encodeBlock)

proc tlParse*(jsonData: JsonNode, generateTypes: bool, useCore: bool, genericTypesBlock: var string, interfaces: var seq[string])  =
    var code: Table[string, Block]
    var predicategetter = "methodname"
    if generateTypes:
        predicategetter = "predicate"
    for obj in jsonData:
        var id = obj["id"].toStr()
        var sub = "base"
        var predicate = obj[predicategetter].toStr()
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
            var pmr = getPmr(obj["typeof"].toStr())
            if not interfaces.contains(pmr.toLower()):
                genericTypesBlock = genericTypesBlock & &"    {pmr}I* = ref object of TLObject\n\n"
                interfaces.add(pmr.toLower())
        if generateTypes:
            var pmr = getPmr(obj["typeof"].toStr())
            code[sub].typesBlock.add(&"    {predicate}* = ref object of {pmr}I\n" & parseParameters(obj["params"], genericTypesBlock, interfaces) )
        else:
            code[sub].typesBlock.add(&"    {predicate}* = ref object of TLFunction\n" & parseParameters(obj["params"], genericTypesBlock, interfaces))

        code[sub].getTypeNameBlock.add(&"method getTypeName*(self: {predicate}): string = \"{predicate}\"\n")
        code[sub].encodeBlock.add(generateEncode(predicate, id, obj["params"]))
        code[sub].encodeBlock.add(generateDecode(predicate, obj["params"]))
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
                writeFile(&"rpc/{dirname}/{sub}.nim", license & imports & "\ntype\n" & genericTypesBlock & sectionimport & "\ntype\n" & blok.typesBlock & "\n" & blok.getTypeNameBlock & "\n" & blok.encodeBlock)
            else:
                writeFile(&"rpc/{dirname}/{sub}.nim", license & imports & sectionimport & "\ntype\n" & blok.typesBlock & blok.getTypeNameBlock & "\n" & blok.encodeBlock)
        else:
            writeFile(&"rpc/{dirname}/{sub}.nim", license & imports & "type\n" & blok.typesBlock & blok.getTypeNameBlock & "\n" & blok.encodeBlock)
        
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


