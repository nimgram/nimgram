# Package description
version = "0.2.0"
author = "dadadani"
description = "MTProto client written in Nim"
license = "MIT"
srcDir = "src"

# Dependencies
requires "nim >= 1.6.0"
requires "https://github.com/nimgram/tl-parser"
requires "https://github.com/nimgram/tl-types"
requires "crc32 >= 0.5.0"
requires "stint"
requires "https://github.com/dadadani/bigints#master"
requires "nimcrypto#a5742a9"

task test, "Runs the test suite":
  selfExec("r -d:release --gc:orc tests/auth_key.nim")
  selfExec("r tests/message_id.nim")