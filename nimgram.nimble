# Package

version       = "0.1.0"
author        = "dadadani"
description   = "MTProto client written in Nim"
license       = "MIT"
srcDir        = "src"

# Dependencies

requires "nim >= 1.2.0"
requires "zippy >= 0.3.13"
requires "nimcrypto >= 0.5.4"
requires "stint >= 0.0.1" 
requires "gmp >= 0.2.5"
requires "https://github.com/dadadani/nim-random#master"


proc codegen =
    selfExec("c --run -d:danger --opt:speed --hints:off tl/build.nim")
    if dirExists("src/nimgram/private/rpc"):
        rmDir("src/nimgram/private/rpc")
    mvDir("rpc", "src/nimgram/private/rpc")
    rmFile("tl/build")

before install:
    codegen()

task forcegen, "Force generation of the rpc directory":
    codegen()