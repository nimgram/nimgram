import tl2json
import os
import parser
import parseOpt
import openssl
import ../shared
import strformat

proc main(filename: string, debug: bool, output: string) =
    echo &"Nimgram {NIMGRAM_VERSION} TL Parser\n"
    if debug:
        echo "Main (debug): Parsing TL schema"
    if debug:
        echo "- Converting to json"
    var jsonified = TL2Json(filename, debug)
    let result = parseTL(jsonified, debug)
    if result == "":
        echo &"Main (error): Parsing of '{filename}' has failed"
    else:
        try:
            writeFile(output, result)
        except IOError as error:
            echo &"Main (error): An error has occurred while attempting to dump parsing output to '{output}' -> {error.msg}"
            quit()
        echo &"Main (info): Parsing complete, result has been dumped to '{output}'"


when isMainModule:
    var optParser = initOptParser(commandLineParams())
    var schemaFile: string = ""
    var outputFile: string = ""
    var debug: bool = false
    if paramCount() > 0:
        if paramCount() notin 1..<4:
            echo "Usage: ./main <schema.tl> <output.nim> [--debug]"
            quit()
    else:
        echo "Usage: ./main <schema.tl> <output.nim> [--debug]"
        quit()
    for kind, key, value in optParser.getopt():
        case kind:
            of cmdArgument:
                if schemaFile == "":
                    schemaFile = key
                else:
                    outputFile = key
            of cmdLongOption:
                if key == "debug":
                    debug = true
                else:
                    echo &"Error -> Unkown option '{key}'"
                    quit()
            else:
                echo "Usage: ./main <schema.tl> <output.nim> [--debug]"
                quit()
    if outputFile == "":
        echo "Usage: ./main <schema.tl> <output.nim> [--debug]"
        quit()
    main(schemaFile, debug, outputFile)