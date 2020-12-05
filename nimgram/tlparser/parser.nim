import json
import strformat
import strutils
import tables

# TL ("Type Language") parser module. Generates nim code based on a jsonified version of
# the TL schema, also produced by nimgram

type Parser = ref object
    interfaces: seq[string]
    interfaceCode: string
    constCode: string
    genericCodeEncode: Table[string, seq[string]]
    getBytesCode: string
    fromBytesCode: string
    useStint: bool
    useOption: bool
    typeCode: string


proc convertType(tparser: Parser, sstr: string, enableFlagsParse: bool = true, enableTrueToBool: bool = true): string =
    # Converts a TL type into a nim object representation

    result = sstr
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

    var pmr = result.replace(".", "_").replace("vector<", "").replace(">", "").replace("%", "")
    if not tparser.interfaces.contains(toLower(pmr)) and not result.startsWith("flags") and not result.startsWith("Vector") and not (toLower(result) in @["string", "bool", "true", "int", "long", "double", "float", "bytes", "#", "int128", "object", "int256"]):
        tparser.interfaces = tparser.interfaces & toLower(pmr)
        tparser.interfaceCode = tparser.interfaceCode & &"    {pmr}I* = ref object of TLObject\n\n"
    if tparser.interfaces.contains(toLower(pmr)): 
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
        tparser.useStint = true
        result = "Int128"
    if result == "int256":
        stint = true
        tparser.useStint = true
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
        result = replace(result, "object", "TLObject")

    if isVector:
        result = tempFlags & "seq[" & result & "]"
    if useOption and result != "true":
        result = tempFlags & "Option[" & result & "]"


proc parseToBytesCode(tparser: Parser, tlObject: JsonNode, procName: string = "TLEncodeType", nameOfObject: string = "predicate"): string =
    # Create procedures to convert tl objects into bytes

    var name = tlObject[nameOfObject].getStr().replace(".", "_")
    var id = tlObject["id"].getInt()
    var useFlags = false
    var flagsCode = ""
    for param in tlObject["params"]:
         
        var typeOf = tparser.convertType(param["typeof"].getStr(), false, false)
        var namp = param["name"].getStr()
        if namp == "{X":
            continue
        if namp == "out":
            namp = "isout"
        if namp == "type":
            namp = "typeof"
        if namp == "static":
            namp = "isstatic"

        var splitName = typeOf.split("?", 1)
        var splitNamee = splitName[splitName.high]

        if typeOf.startsWith("flags"):
            useFlags = true
            var index = typeOf.split("flags.", 1)[1]
            index = index.split("?", 1)[0]
            if splitNamee == "true":
                flagsCode = flagsCode & &"\n    if obj.{namp}:\n        obj.flags = obj.flags or 1 shl {index}\n"
            else:
                flagsCode = flagsCode & &"\n    if obj.{namp}.isSome():\n        obj.flags = obj.flags or 1 shl {index}\n"
        if splitNamee != "true":
            if splitName.len() > 1:
                result = result & &"\n    if obj.{namp}.isSome():\n        result = result & TLEncode(obj.{namp}.get())\n"
            else:
                result = result & &"\n    result = result & TLEncode(obj.{namp})\n"
            
    result =  &"proc {procName}*(obj: {name}): seq[uint8] = \n    result = result & TLEncode(int32({id}))" & flagsCode & result
    result = result & "\n\n"

proc parseFromBytesCode(tparser: Parser, tlObject: JsonNode): string =
    # Create procedures to convert bytes into tl objects

    var name = tlObject["predicate"].getStr().replace(".", "_")
    var useFlags = false
    var varTypeCheck = newSeq[string]()
    var ok = false

    var flagsCode = ""
    for param in tlObject["params"]:
        var typeOf = tparser.convertType(param["typeof"].getStr(), false, false)
        var namp = param["name"].getStr()
        if namp == "out":
            namp = "isout"
        if namp == "type":
            namp = "typeof"
        if namp == "static":
            namp = "isstatic"

        var splitName = typeOf.split("?", 1)
        var splitNamee = splitName[splitName.high]

        if typeOf.startsWith("flags"):
            useFlags = true
            var index = typeOf.split("flags.", 1)[1]
            index = index.split("?", 1)[0]
            if splitNamee == "true":
                ok = true
                result = result & &"\n    if (obj.flags and (1 shl {index})) != 0:\n        obj.{namp} = true\n"
            else:  
                var a = splitNamee.split("?", 1)
                splitNamee = a[a.high()]
                
                if splitNamee.replace("Option[", "").replace("]", "") in @["int64", "int32", "float64", "float32"]:
                    result = result & &"\n    if (obj.flags and (1 shl {index})) != 0:\n"
                    ok = true
                    var tempName = splitNamee.replace("Option[", "").replace(".", "_").replace("]", "").replace("vector<", "seq[").replace(">", "]").replace("Option[", "")
                    var tempTempName = splitNamee.replace("Option[", "").replace("]", "").replace("]", "").replace(".", "_").replace("vector<", "v").replace(">", "")

                    if not varTypeCheck.contains(splitNamee):
                        result = result & &"\n        var temp{tempTempName}: {tempName} = 0"
                    result = result & &"\n        self.TLDecode(addr temp{tempTempName})\n        obj.{namp} = some(temp{tempTempName})\n"
                    continue
            
                if splitNamee == "seq[seq[uint8]]]":
                    result = result & &"\n    if (obj.flags and (1 shl {index})) != 0:\n"
                    ok = true
                    result = result & &"\n        obj.{namp} = some(self.TLDecodeSeq())\n"
                    continue

                if splitNamee == "Option[string]":
                    result = result & &"\n    if (obj.flags and (1 shl {index})) != 0:\n"
                    ok = true
                    result = result & &"\n        obj.{namp} = some(cast[string](self.TLDecode()))\n"
                    continue

                if splitNamee == "Option[seq[uint8]]":
                    result = result & &"\n    if (obj.flags and (1 shl {index})) != 0:\n"
                    ok = true
                    result = result & &"\n        obj.{namp} = some(self.TLDecode())\n"
                    continue


                result = result & &"\n    if (obj.flags and (1 shl {index})) != 0:\n"
                ok = true

                var tempName = splitNamee.replace("Option[", "").replace("]]", "]").replace(".", "_").replace("vector<", "[").replace(">", "]")
                var tempTempName = splitNamee.replace(".", "_").replace("vector<", "v").replace(">", "").replace("vector<vector", "vv").replace(">>", "").replace("Option[", "").replace("]", "").replace("seq[", "").replace("]", "")
                
                if not tempName.startsWith("Option") and not tempName.startsWith("seq"):
                    tempName = tempName.replace("]", "")

                if not varTypeCheck.contains(splitNamee):
                    result = result & &"\n        var temp{tempTempName}: {tempName}"
                result = result & &"\n        self.TLDecode(temp{tempTempName})\n        obj.{namp} = some(temp{tempTempName})\n"
                continue     
                    
                
        if splitNamee != "true":
            if splitName.len() > 1:
                discard
            else:
                if typeOf == "seq[uint8]":
                    ok = true
                    result = result & &"\n    obj.{namp} = self.TLDecode()"
                    continue

                if typeOf == "string":
                    ok = true
                    result = result & &"\n    obj.{namp} = cast[string](self.TLDecode())"
                    continue
                if typeOf == "seq[string]":
                    ok = true
                    result = result & &"\n    obj.{namp} = cast[seq[string]](self.TLDecodeSeq())"
                    continue
                if typeOf == "seq[seq[uint8]]":
                    ok = true
                    result = result & &"\n    obj.{namp} = self.TLDecodeSeq()"
                    continue
                if typeOf in @["int64", "int32", "float64", "float32", "Int128", "Int256"]:
                    ok = true
                    result = result & &"\n    self.TLDecode(addr obj.{namp})"
                    continue
                ok = true
                result = result & &"\n    self.TLDecode(obj.{namp})"
                continue    
              

    if not ok:
        result = result & "discard"         
                
    result =  &"proc TLDecode*(self: var ScalingSeq[uint8], obj: {name}) = \n    obj.originalName = \"{name}\"\n" & flagsCode & result
    result = result & "\n\n"


proc parseParameters(tparser: Parser, params: JsonNode): string =
    # Parses TL objects constructor parameters

    for tlParam in params:
        var typeOriginal = tlParam["typeof"].getStr()
        if typeOriginal == "Type}":
            continue
        
        var name = tlParam["name"].getStr()

        if typeOriginal == "!X":
            result = result & &"        {name}*: TLFunction\n"
            continue

        let paramType = convertType(tparser, typeOriginal, true, true)
        if name == "out":
            name = "isout"
        if name == "type":
            name = "typeof"
        if name == "static":
            name = "isstatic"
        result = result & &"        {name}*: {paramType}\n"


proc generateConstFromId(tparser: Parser, tlObject: JsonNode): string =
    result = "const FromID* = {1: \"default\""
    for param in tlObject:
        result = result & &",\n"
        var name = param["predicate"].getStr().replace(".", "_")
        var id = param["id"]
        result = result & &"{id}: \"{name}\""
    result = result & "}"
    

proc generateGenericBytesHeaders(tParser: Parser): string =
    for name, objs in tParser.genericCodeEncode:
        for _, obj in objs:
            result = result & &"\nproc TLDecode*(self: var ScalingSeq[uint8], obj: {obj})\n"
            result = result & &"\nproc TLEncodeType*(obj: {obj}): seq[uint8]\n"

proc generateGenericFunction(functionsName: seq[string]): string =
    result = "\n\nproc TLEncodeApiGeneric*(obj: TLFunction): seq[uint8] = \n"
    for _, objs in functionsName:
            result = result & &"    if obj of {objs}:\n        return cast[{objs}](obj).TLEncodeFunction()\n"

proc generateGenericToBytes(tParser: Parser): string = 
    var separe = ""
    var superGeneric = "\n\nproc TLEncodeApi*(obj: TLObject): seq[uint8] = \n"
    var superGenericVector = "\n\nproc TLEncodeApi*(obj: seq[TLObject]): seq[uint8] =\n    result = TLEncode(int32(481674261))\n    result = result & TLEncode(int32(len(obj)))\n    for objs in obj:"

    for name, dependentTypes in tParser.genericCodeEncode:
        superGeneric = superGeneric & &"    if obj of {name}:\n        return cast[{name}](obj).TLEncode()\n"
        superGenericVector = superGenericVector & &"\n        if objs of {name}:\n            result = result & cast[{name}](objs).TLEncode()"

        separe = separe & &"\n\nproc TLEncode*(obj: seq[{name}]): seq[uint8] =\n    result = TLEncode(int32(481674261))\n    result = result & TLEncode(int32(len(obj)))\n    for objs in obj:"
        result = result & &"\nproc TLEncode*(obj: {name}): seq[uint8] = \n"
        for typee in dependentTypes:
            separe = separe & &"\n        if objs of {typee}:\n            result = result & cast[{typee}](objs).TLEncode()"
            result = result & &"    if obj of {typee}:\n        return cast[{typee}](obj).TLEncodeType()\n"
    result = result & separe & superGeneric & superGenericVector


proc generateGenericFromBytes(tParser: Parser): string = 
    var separe = ""
    var superGenericVector = "\n\nproc TLDecodeApi*(self: var ScalingSeq[uint8], obj: var seq[TLObject]) =\n    var id: int32\n    self.TLDecode(addr id)\n    if id != 481674261:\n        raise newException(Exception, \"Type is not Vector\")\n    var lenght: int32\n    self.TLDecode(addr lenght)\n    for i in countup(1, lenght):\n        var id: int32\n        self.TLDecode(addr id)"
    var superGeneric = "\nproc TLDecodeApi*(self: var ScalingSeq[uint8], obj: var TLObject) =  \n        var id: int32\n        self.TLDecode(addr id)\n        case FromID.toTable[id]"

    for name, dependentTypes in tParser.genericCodeEncode:
        separe = separe & &"\n\nproc TLDecode*(self: var ScalingSeq[uint8], obj: var seq[{name}]) =\n    var id: int32\n    self.TLDecode(addr id)\n    if id != 481674261:\n        raise newException(Exception, \"Type is not Vector\")\n    var lenght: int32\n    self.TLDecode(addr lenght)\n    for i in countup(1, lenght):\n        var id: int32\n        self.TLDecode(addr id)"
        result = result & &"\nproc TLDecode*(self: var ScalingSeq[uint8], obj: var {name}) =  \n        var id: int32\n        self.TLDecode(addr id)\n        case FromID.toTable[id]"
        for typee in dependentTypes:
            superGenericVector = superGenericVector & &"\n        if FromID.toTable[id] == \"{typee}\":\n            var tempObject = new({typee})\n            self.TlDecode(tempObject)\n            tempObject.originalName = \"{typee}\"\n            obj.add(tempObject)"
            superGeneric = superGeneric &     &"\n        of \"{typee}\":\n            var tempObject = new({typee})\n            self.TlDecode(tempObject)\n            obj = tempObject\n            obj.originalName = \"{typee}\"\n            return"
            separe = separe & &"\n        if FromID.toTable[id] == \"{typee}\":\n            var tempObject = new({typee})\n            self.TlDecode(tempObject)\n            tempObject.originalName = \"{typee}\"\n            obj.add(tempObject)"
            result = result & &"\n        of \"{typee}\":\n            var tempObject = new({typee})\n            self.TlDecode(tempObject)\n            obj = tempObject\n            obj.originalName = \"{typee}\"\n            return"
    
    result = result & separe & superGeneric & superGenericVector


proc parseConstructors(constructors: JsonNode, debug: bool): string =
    # Parses TL object constructor methods

    let tparser = new(Parser)
    tparser.interfaces = newSeq[string]()
    for tlObject in constructors:
        let paramType = tparser.convertType(tlObject["typeof"].getStr())
        var name = tlObject["predicate"].getStr().replace(".", "_")
        if debug:
            echo &"Parsing {name}"

        if paramType in @["bool", "seq", "float64", "float32", "seq[uint8]"]:
            tparser.typeCode = tparser.typeCode & &"    {name}* = {paramType}\n\n"
        var pmr = tlObject["typeof"].getStr().replace(".", "_").replace("vector<", "").replace(">", "")
        if not tparser.interfaces.contains(toLower(pmr)):
            tparser.interfaceCode = tparser.interfaceCode & &"    {pmr}I* = ref object of RootObj\n\n"
            tparser.interfaces = tparser.interfaces & toLower(pmr)
        if not tparser.genericCodeEncode.contains((pmr&"I")):
            tparser.genericCodeEncode[(pmr&"I")] = @[]
        tparser.genericCodeEncode[(pmr&"I")] = tparser.genericCodeEncode[(pmr&"I")] & name
        tparser.typeCode = tparser.typeCode & &"    {name}* = ref object of {pmr}I\n" & tparser.parseParameters(tlObject["params"]) & "\n"
        tparser.getBytesCode = tparser.getBytesCode & tparser.parseToBytesCode(tlObject)
        tparser.fromBytesCode = tparser.fromBytesCode & tparser.parseFromBytesCode(tlObject)
    
    tparser.constCode = tparser.generateConstFromId(constructors)
    result = "import tables\nimport bitops\nimport strutils\nimport options\nimport nimgram/client/rpc/decoding\nimport nimgram/client/rpc/encoding\n#This file was automatically generated by the tl scheme using Nimgram\ntype\n    TL* = ref object of RootObj\n    TLObject* = ref object of TL\n        originalName*: string\n\n" & tparser.interfaceCode & tparser.typeCode & "\n\n" & tparser.generateGenericBytesHeaders() & "\n\n" & tParser.generateGenericToBytes() & "\n\n" & "\n\n" & tparser.getBytesCode & tparser.constCode & "\n\n" & tParser.generateGenericFromBytes() & "\n\n" & tParser.fromBytesCode
    if tparser.useStint:
        result = "import stint\n" & result

proc parseFunctions(constructors: JsonNode, debug: bool): string =
    # Parses TL object constructor methods
    var functionsName = newSeq[string]()
    let tparser = new(Parser)
    tparser.interfaces = newSeq[string]()
    for tlObject in constructors:
        let paramType = tparser.convertType(tlObject["returnType"].getStr())
        var name = tlObject["methodname"].getStr().replace(".", "_")
        if debug:
            echo &"Parsing {name}"
        functionsName.add(name)
        tparser.typeCode = tparser.typeCode & &"    {name}* = ref object of TLFunction\n" & tparser.parseParameters(tlObject["params"]) & "\n"
        tparser.getBytesCode = tparser.getBytesCode & tparser.parseToBytesCode(tlObject, "TLEncodeFunction", "methodname")

    result = "\ntype\n    TLFunction* = ref object of TL\n\n" & tparser.typeCode & "\n\nproc TLEncodeApiGeneric*(obj: TLFunction): seq[uint8]\n\n" & tparser.getBytesCode & generateGenericFunction(functionsName)





proc parseTL*(jsonData: JsonNode, debug: bool): string =
    # Parses a jsonified TL schema

    try:
        if debug:
            echo "- Parsing types"
        result = parseConstructors(jsonData["constructors"], debug)           
        if debug:
            echo "- Parsing functions"
        result = result & parseFunctions(jsonData["methods"], debug)           
 

    except JsonParsingError as jsonError:
        echo &"TLParser (error): An error occurred while parsing -> {jsonError.msg}"
        result = ""