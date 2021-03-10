
  

# Nimgram

  

Nimgram is a pure-nim implementation of the Telegram MTProto communication standard. Its built-in TL parser generates human readable and idiomatic nim source code from the RPC API schema.

  

**Telegram Channel:** https://t.me/nimgram

**Telegram Chat:** https://t.me/joinchat/F6t0FEuL56Y7TI-JWWJz-w

  
  

# Status

  

The client is able to connect successfully and exchange auth keys and sending messages, there is also a way to handle raw updates (see test.nim)

  

# Dependencies

  
Nimgram uses mostly native libraries, so there's no need to load any external C library.

By default GMP is used to do modular exponentation since is faster than stint's builtin powmod, but if you don't want to use this library, you can pass `-d:disablegmp` as a compilation parameter (you should do that only if you can't use GMP, it is really slow)

  

# Know issues

  
- ~~Slow auth_key generation (This is due to the slow powmod procedure, tooking about 2 minutes in debug and 5 seconds in -d:release)~~ GMP is now used instead by default instead of stint's powmod, but it is an external library (see Dependencies)


# License


Nimgram is distributed and licensed under the MIT License. (See LICENSE)

