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

import std/macrocache
import std/macros
import std/strformat
import std/strutils

const generatedFunctions = CacheSeq"generatedFunctions"
const generatedToJsonTypes = CacheTable"generatedTypes"
const generatedFromJsonTypesRoot = CacheTable"generatedTypesFromJsonRoot"
const generatedFromJsonTypes = CacheSeq"generatedTypesTypesFromJson"

macro NimgramFunctionDecoder*(prc: untyped) =
    var generatedCode = """try:
        if not json.contains("@type") or json["@type"].kind != JString:
            raise newException(KeyError, "Invalid @type parameter")
        case json["@type"].getStr():
"""

    for fun in generatedFunctions:
        generatedCode.add($fun & "\n")
    

    generatedCode.add("""        else:
            return nimgramApiJson(Error(code: 400, message: "Unable to find a valid function"))
except RPCError as err:
    return nimgramApiJson(Error(code: int32(err.errorCode), message: err.errorMessage))
except CatchableError as err:
    return nimgramApiJson(Error(code: 600, message: err.msg))
""")

    result = prc

    result[6] = parseStmt(generatedCode)

    

macro NimgramJsonDecoder*(prc: untyped) =
    
    var generatedCode = """if json.kind != JObject or not json.contains("@type"):
    raise newException(KeyError, "Invalid @type parameter")
case json["@type"].getStr():
of "Ok":
    when T is Ok:
        return Ok()
    else:
        raise newException(ValueError, "nimgramApiFromJson: Invalid type")
"""
    for typ in generatedFromJsonTypes:
        if typ.kind != nnkStmtList:
            generatedCode.add($typ)
        else:
            var extraChecks = ""
            var extraParams = ""
            if generatedFromJsonTypesRoot.contains($typ[0]):
                extraChecks = $generatedFromJsonTypesRoot[$typ[0]][0]
                extraParams = $generatedFromJsonTypesRoot[$typ[0]][1]
                
            generatedCode.add(&"""of "{typ[1]}":
    when T is {typ[0]}:
{extraChecks}
{typ[2]}

        return {typ[1]}({typ[3]}{extraParams})
    else:
        raise newException(ValueError, "nimgramApiFromJson: Invalid type")
""")

    generatedCode.add("""else:
    raise newException(ValueError, "nimgramApiFromJson: Unable to find a valid type")""")
    
    result = prc

    result[6] = parseStmt(generatedCode)

    

macro NimgramJsonEncoder*(prc: untyped) =
    var generatedCode = """when T is Ok:
    result = newJObject()
    result["@type"] = %*"Ok"
"""
    for key, typ in generatedToJsonTypes:
        if key.startsWith("@"):
            continue
        if typ.kind == nnkStmtList:
            generatedCode.add($generatedToJsonTypes["@" & key])
            for stmts in typ:
                generatedCode.add($stmts)
            generatedCode.add(&"""        else:
            result["@type"] = %*"{key}"
""")
        else:
            generatedCode.add($typ)
    
    generatedCode.add(&"""else:

        raise newException(ValueError, "nimgramApiJson: Unable to find a valid type")
""")

    result = prc

    result[6] = parseStmt(generatedCode)

macro NimgramType*(typ: untyped) = 
    if typ.kind != nnkTypeDef:
        error("Type definiton required")
    if typ[0][0].kind != nnkPostfix:
        error("Type must be public")
    
    let name = $typ[0][0][1]

    var generateCodeToJson = ""
    var fromJsonCallCon = ""
    var fromJsonChecks = ""
    var extraSpace = ""
    var extraConversion = ""
    var rootObj = false
    var sub = false
    var rootType = ""

    let objectTy = (if typ[2].kind == nnkRefTy: typ[2][0] else: typ[2])

    if objectTy[1].kind == nnkOfInherit:
        rootType = $objectTy[1][0]
        if $objectTy[1][0] == "RootObj":
            rootObj = true
            generateCodeToJson.add(&"""elif T is {name}:
        result = newJObject()
""")
        else:
            sub = true
            let rootType = $objectTy[1][0]
            var ifCondition = "if"
            extraConversion = &".{name}"
            extraSpace = "    "
            if generatedToJsonTypes.contains(rootType):
                ifCondition = "elif"
            generateCodeToJson.add(&"""        {ifCondition} obj of {name}:
            result["@type"] = %*"{name}"
""")
    else:
        generateCodeToJson.add(&"""elif T is {name}:
        result = newJObject()
        result["@type"] = %*"{name}"
""")
    
    for field in objectTy[2]:
        if field.kind == nnkIdentDefs:
            if field[0].kind != nnkPostfix:
                continue
            let fieldName = $field[0][1]
            let fieldType = $field[1]
            if fieldType in ["int", "int64", "int32", "int16", "int8", "uint", "uint64", "uint32", "uint16", "uint8"]:
                fromJsonChecks.add(&"""        json.expectParameter("{fieldName}", JInt)
""")
            elif fieldType in ["float", "float32", "float64"]:
                fromJsonChecks.add(&"""        json.expectParameter("{fieldName}", JFloat)
""")
            elif fieldType == "bool":
                fromJsonChecks.add(&"""        json.expectParameter("{fieldName}", JBool)
""")
            elif fieldType == "string":
                fromJsonChecks.add(&"""        json.expectParameter("{fieldName}", JString)
""")
            else:
                fromJsonChecks.add(&"""        json.expectParameter("{fieldName}", JObject)
""")

            case fieldType:
            of "int64":
                fromJsonCallCon.add(&"""{fieldName}: int64(json["{fieldName}"].getBiggestInt()), """)
            of "int32":
                fromJsonCallCon.add(&"""{fieldName}: int32(json["{fieldName}"].getInt()), """)
            of "int16":
                fromJsonCallCon.add(&"""{fieldName}: int16(json["{fieldName}"].getInt()), """)
            of "int8":
                fromJsonCallCon.add(&"""{fieldName}: int8(json["{fieldName}"].getInt()), """)
            of "uint64":
                fromJsonCallCon.add(&"""{fieldName}: uint64(json["{fieldName}"].getBiggestInt()), """)
            of "uint32":
                fromJsonCallCon.add(&"""{fieldName}: uint32(json["{fieldName}"].getInt()), """)
            of "uint16":
                fromJsonCallCon.add(&"""{fieldName}: uint16(json["{fieldName}"].getInt()), """)
            of "uint8":
                fromJsonCallCon.add(&"""{fieldName}: uint8(json["{fieldName}"].getInt()), """)
            of "float32":
                fromJsonCallCon.add(&"""{fieldName}: float32(json["{fieldName}"].getFloat()), """)
            of "float64":
                fromJsonCallCon.add(&"""{fieldName}: float64(json["{fieldName}"].getFloat()), """)
            of "bool":
                fromJsonCallCon.add(&"""{fieldName}: json["{fieldName}"].getBool(), """)
            of "string":
                fromJsonCallCon.add(&"""{fieldName}: json["{fieldName}"].getStr(), """)
            else:
                fromJsonCallCon.add(&"""{fieldName}: nimgramApiFromJson[{fieldType}](json["{fieldName}"]), """)

            if fieldType in ["int", "int64", "int32", "int16", "int8", "uint", "uint64", "uint32", "uint16", "uint8", "float", "float32", "float64", "bool", "string"]:
                generateCodeToJson.add(&"""{extraSpace}        result["{fieldName}"] = %*obj{extraConversion}.{fieldName}
""")
            else:
                generateCodeToJson.add(&"""{extraSpace}        result["{fieldName}"] = nimgramApiJson(obj{extraConversion}.{fieldName})
""")
    
    if rootObj:
        generatedToJsonTypes["@" & name] = newLit(generateCodeToJson)
        generatedFromJsonTypesRoot[name] = newStmtList(newLit(fromJsonChecks), newLit(fromJsonCallCon))
        generatedFromJsonTypes.add(newLit(&"""of "{name}":
    when $result.typedesc == "{name}":
""" &
            
            fromJsonChecks & "\n" & &"""        return {name}({fromJsonCallCon})
    else:
        raise newException(ValueError, "nimgramApiFromJson: invalid type")
"""))
        
    elif sub:
        if not generatedToJsonTypes.contains(rootType) or generatedToJsonTypes[rootType].kind != nnkStmtList:
            generatedToJsonTypes[rootType] = newStmtList()
        generatedToJsonTypes[rootType].add(newLit(generateCodeToJson))
        generatedFromJsonTypes.add(newStmtList(newLit(rootType), newLit(name), newLit(fromJsonChecks), newLit(fromJsonCallCon)))
    else:
        generatedToJsonTypes[name] = newLit(generateCodeToJson)
        generatedFromJsonTypes.add(newLit(&"""of "{name}":
    when T is {name}:
""" &
            
            fromJsonChecks & "\n" & &"""        return {name}({fromJsonCallCon})
    else:
        raise newException(ValueError, "nimgramApiFromJson: invalid type")
"""))
    
    result = typ

macro NimgramFunction*(prc: untyped) =
    if prc.kind != nnkProcDef:
        error("Expected a proc definition")
    let procname = if prc[0].kind == nnkIdent: $prc[0]
                   elif prc[0].kind == nnkPostFix: $prc[0][1]
                   else: ""
    var nimgramClientParamName = ""
    var generatePre = &"""        of "{procname}":
"""
    var isAsync = false
    if prc[4].kind == nnkPragma:
        for node in prc[4]:
            if $node == "async":
                isAsync = true
                break
    let returnType = (if prc[3].kind == nnkFormalParams and prc[3][0].kind != nnkEmpty: (if isAsync: (if prc[3][0][1].kind == nnkIdent and $prc[3][0][1] != "void": $prc[3][0][1] else: "") else: $prc[3][0]) else: "")
    
    var generateCall = "            " & (if returnType.len > 0: "let callres = " else: "") & (if isAsync: "await " else: "") & &"""{procname}("""
    
    
    for node in prc:
        if node.kind == nnkFormalParams:
            for param in node:
                if param.kind == nnkIdentDefs:
                    if param[1].eqIdent("NimgramClient"):
                        if nimgramClientParamName != "":
                            error("A function may only have one NimgramClient parameter")
                        nimgramClientParamName = param[0].toStrLit.strVal()
                        generateCall.add("client,")
                    elif param[1].eqIdent("int"):
                        generatePre.add(&"""            json.expectParameter("{param[0].toStrLit.strVal()}", JInt)
""")
                        generateCall.add(&"""json["{param[0].toStrLit.strVal()}"].getInt(),""")
                    elif param[1].eqIdent("string"):
                        generatePre.add(&"""            json.expectParameter("{param[0].toStrLit.strVal()}", JString)
""")
                        generateCall.add(&"""json["{param[0].toStrLit.strVal()}"].getStr(),""")

                    elif param[1].eqIdent("bool") or param[2].eqIdent("false") or param[2].eqIdent("true"):
                        generatePre.add(&"""            json.expectParameter("{param[0].toStrLit.strVal()}", JBool)
""")                    
                        generateCall.add(&"""json["{param[0].toStrLit.strVal()}"].getBool(),""")
                    else:
                        generatePre.add(&"""            json.expectParameter("{param[0].toStrLit.strVal()}", JObject)
""")
                        generateCall.add(&"""nimgramApiFromJson[{param[1]}](json["{param[0].toStrLit.strVal()}"]),""")
                
               
            if nimgramClientParamName == "":
                error("Expected a NimgramClient parameter")
    generateCall.add(")")

    let generateReturn = (if returnType.len > 0: &"            return nimgramApiJson(callres)" else: "            return nimgramApiJson(Ok())")


    generatedFunctions.add(newLit(generatePre & "\n" & generateCall & "\n" & generateReturn))
    result = prc