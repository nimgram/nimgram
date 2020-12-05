# Nimgram 
Nimgram is a pure-nim implementation of the Telegram MTProto communication standard. Its
built-in TL parser generates human readable and idiomatic nim source code from the RPC API
schema.

# Status
The client is able to connect successfully and exchange auth keys and sending messages, there is also a way to handle raw updates (see test.nim)

# Know issues
- Slow auth_key generation (This is due to the slow powmod procedure, tooking about 2 minutes in debug and 5 seconds in -d:release)
- Problems at compiling using --gc:refc (Works using --gc:orc)

