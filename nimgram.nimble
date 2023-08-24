# Package description
version = "0.2.0"
author = "dadadani"
description = "MTProto client written in Nim"
license = "MIT"
srcDir = "src"

# Dependencies
requires "nim >= 2.0.0"
requires "https://github.com/nimgram/tl-types#master"
requires "stint#d1acb42"
requires "nimcrypto#a5742a9"
requires "https://github.com/dadadani/nim-tommath"
requires "db_connector"

proc buildJson = 
  echo "Generating json encoder/decoder..."
  echo "NOTE: if the compilations fails, make sure to have tlparser-api installed"
  selfExec("r bindings/builder/builder.nim")

proc buildInterface(libName: string, args: string) =
  selfExec("c " & args & " -d:strip --threads:on -d:release --gc:orc --out:" & libName & " --outdir:bindings/lib bindings/interface.nim")
#[
proc buildDll =
  buildJson()
  echo "Building Nimgram..."
  mkDir("bindings/lib")
  when defined(windows):
    buildInterface "nimgram.dll", "--app:lib"

  elif defined(macosx):
    buildInterface "libnimgram.dylib.arm", "--app:lib --cpu:arm64 -l:'-target arm64-apple-macos11' -t:'-target arm64-apple-macos11'"
    buildInterface "libnimgram.dylib.x64", "--app:lib --cpu:amd64 -l:'-target x86_64-apple-macos10.12' -t:'-target x86_64-apple-macos10.12'"
    exec "lipo bindings/lib/libnimgram.dylib.arm bindings/lib/libnimgram.dylib.x64 -output bindings/lib/libnimgram.dylib -create"

  else:
    buildInterface "libnimgram.so", "--app:lib" 

task buildDll, "Build Nimgram as a dynamic library":
  buildDll()
]#
task test, "Test Nimgram":
  echo "Running auth_key generation test"
  selfExec("r -d:release --gc:orc tests/auth_key.nim")
  echo "Running message id test"
  selfExec("r tests/message_id.nim")
  echo "Running storage test"
  selfExec("r tests/storage.nim")

task checkExamples, "Check examples":
  echo "Checking examples"
  for example in listFiles("examples"):
    if example.endsWith(".nim"):
      exec "nim check --hints:off " & example

