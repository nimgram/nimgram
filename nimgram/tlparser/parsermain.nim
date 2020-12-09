import docopt
import strformat
import tl2json
import strutils
import tables
import json
import parser
let doc = """
Nimgram TLParser

Usage:
  ./parsermain parse <mtprotoschema> <apischema> [--layer=<layer>] [--onlyjson]
  ./parsermain (-h | --help)
  ./parsermain --version

Options:
  -h --help     Show this screen.
  --version     Show version.
  --layer=<layer>  Set the layer version [default: Parsed from schema].
  --onlyjson     Only convert the schema to json.
"""


proc parse(args:Table[system.string, docopt.Value]) =
        echo args
        var mtprotoschema = args["<mtprotoschema>"]
        echo &"Parsing {mtprotoschema} to json..."     
        var mtprotojsonschema = TL2Json($mtprotoschema, false, false)
        if mtprotojsonschema == nil:
          return
        if args["--onlyjson"]:
          writeFile($mtprotoschema&".json", $mtprotojsonschema)

        var apischema = args["<apischema>"]
        echo &"Parsing {apischema} to json..."  
        var apijsonschema: JsonNode
        if args.contains("--layer") and $args["--layer"] != "Parsed from schema":
          echo "Using layer version ", $args["--layer"]
          apijsonschema = TL2Json($apischema, false, true, parseBiggestInt($args["--layer"]))
        else:
          apijsonschema = TL2Json($apischema, false, true, -1)
        if apijsonschema == nil:
          return
        if args["--onlyjson"]:
          writeFile($apischema&".json", $apijsonschema)
        if not args["--onlyjson"]:
          echo "Generating nim files..."
          echo "Generating core..."
          parser.parse(mtprotojsonschema, true)
          echo "Generating api..."

          parser.parse(apijsonschema, false)
          generateRawFile(mtprotojsonschema, apijsonschema)

when isMainModule:
    let args = docopt(doc, version = &"Nimgram TLParser (Built on {CompileDate} at {CompileTime} - {hostCPU}/{hostOS})")

    if args["parse"]:
      parse(args)