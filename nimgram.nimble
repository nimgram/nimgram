# Package description
version = "0.2.0"
author = "dadadani"
description = "MTProto client written in Nim"
license = "MIT"
srcDir = "src"

# Dependencies
requires "nim >= 1.6.0"
requires "https://github.com/nimgram/tl-parser#v0.2.0"
requires "https://github.com/nimgram/tl-types#v0.2.0"
requires "crc32#c8ccad9"
requires "stint#d1acb42"
requires "https://github.com/dadadani/bigints#646d857"
requires "nimcrypto#a5742a9"
requires "norm#2.5.2"

proc buildJson = 
  echo "Generating json encoder/decoder..."
  echo "NOTE: if the compilations fails, make sure to have tlparser-api installed"
  selfExec("r bindings/builder/builder.nim")

proc buildInterface(libName: string, args: string) =
  selfExec("c " & args & " -d:strip --threads:on -d:release --gc:orc --out:" & libName & " --outdir:bindings/lib bindings/interface.nim")

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

