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
requires "norm >= 2.5.1"

task test, "Test Nimgram":
  echo "Running auth_key generation test"
  selfExec("r -d:release --gc:orc tests/auth_key.nim")
  echo "Running message id test"
  selfExec("r tests/message_id.nim")
  echo "Running storage test"
  selfExec("r -d:normDebug tests/storage.nim")

task checkExamples, "Check examples":
  echo "Checking examples"
  for example in listFiles("examples"):
    if example.endsWith(".nim"):
      exec "nim check --hints:off " & example