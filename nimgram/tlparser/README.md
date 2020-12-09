# TL Parser
Since MTProto calls are just a stream of bytes, a way of easily serializing and deserializing types of the protocol might be important, so the TL Parser comes in place: its role is of generating valid Nim code from the TL scheme (mtproto.tl and api.tl).

# Generating parsed scheme
First, build the parser:
> nim c parsermain.nim

Once the program is built, you can parse the TL scheme:

> ./parsermain parse <mtprotoschema> <apischema> [--layer=<layer>] [--onlyjson]

The parser tries automatically to obtain the layer version of the scheme, but you can specify it using the parameter --layer.
You can also only generate the a jsonified version of the scheme using --onlyjson
