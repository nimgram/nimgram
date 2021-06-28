import json
import strformat
import strutils


# Module for converting the TL schema into a json structure

type TlParameter = object
    name: string
    typeof: string

type TlConstructor* = object
     id: string
     predicate: string
     params: seq[TlParameter]
     typeof: string

type TLMethod* = object
     id: string
     methodname: string
     params: seq[TlParameter]
     returnType: string

type TlSchema* = object
     layer: int64
     constructors: seq[TlConstructor]
     methods: seq[TLMethod]
proc getID(line: string): string =
    var Splitt = split(line, "#", 1)
    if len(Splitt) <= 1:
        raise newException(Exception, "failed splitting")
    var Split = Splitt[Splitt.high]

    Split = split(Split, " ", 1)[0]
    return Split


proc getName(line: string): string =
    result = split(line, "#", 1)[0]

proc getParameters(line: string): seq[TlParameter] =
    var Split = split(line, " ", 1)[1]
    var params = split(Split, " =", 1)
    params = params[..(params.high() - 1)]
    if params.len() < 1:
        return
    var paramss = split(params[0], " ")
    for param in paramss:
        var newParam = TlParameter()
        newParam.name = split(param, ":")[0]
        newParam.typeof = split(param, ":")[1]
        result = result & newParam


proc getReturnType(line: string): string =
    var Splitt = split(line, "= ", 1)[1]
    result = split(Splitt, ";", 1)[0]



proc parseTL(lines: seq[string], debug: bool, layerVersion: int64): JsonNode  =
    var methodMode = false
    var schema = TlSchema()
    schema.layer = layerVersion
    for line in lines:
        if line.startsWith("// LAYER") and schema.layer == -1:
            schema.layer = line.replace("// LAYER", "").replace(" ", "").parseBiggestInt()
            echo "Using layer version ", schema.layer

        if line.isEmptyOrWhitespace() or ($line[0] == "/" and $line[1] == "/"):
            continue
        if line == "---types---":
            methodMode = false
            continue
        if line == "---functions---":
            methodMode = true
            continue
        if not methodMode:
            var constructor = TlConstructor()
            constructor.id = getID(line)
            constructor.predicate = getName(line)
            constructor.params = getParameters(line)
            constructor.typeof = getReturnType(line)
            schema.constructors = schema.constructors & constructor
        else:
            var meth = TLMethod()
            meth.id = getID(line)
            meth.methodname = getName(line)
            meth.params = getParameters(line)
            meth.returnType = getReturnType(line)
            schema.methods = schema.methods & meth
            
    result = %* schema


proc TL2Json*(filename: string, debug: bool, findLayer: bool, layerVersion: int64 = -1): JsonNode =
    # Parses a jsonified TL schema

    try:
        let TLData = split(readFile(filename), "\n")
        result = parseTL(TLData, debug, layerVersion)
        if result["layer"].getInt() == -1 and findLayer:
            result = nil
            echo "Failed to get the layer version, please specify it using --layer=<layer>"
    except IOError as ioError:
        echo &"An error occurred while attempting to read '{filename}' -> {ioError.msg}"