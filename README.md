
<p align="center"><a  href="https://github.com/nimgram/nimgram"><img  src="https://i.lorena.best/nimgram.png"  alt="Nimgram - MTProto client written in Nim"></a></p>

  

# Introduction

Nimgram is a client implementation of the [MTProto protocol](https://core.telegram.org/mtproto) purely written in [Nim](https://github.com/nim-lang/nim).

  

# Project status

**It works!** the client is able to connect, login, handle updates and send messages correctly. We are also already wrapping high-level types so you can easily use the client.

Of course we are are just at the beginning and many things are not implemented yet, but work is in progress!

  

# Examples

You can find examples below to use Nimgram:

  

-  [Nimble test](https://github.com/nimgram/nimgram/blob/master/tests/test.nim)

  # Installing
  You can install Nimgram using Nimble:
  

    nimble install nimgram

If you just want to git-clone the repository, remember to generate the rpc directory by executing the following command on the source tree:

    nimble forcegen


# Build requirements

- The [Nim compiler](https://github.com/nim-lang/nim) (>1.2.0)

-  [GMP](https://gmplib.org/) (NOT REQUIRED: You can build Nimgram without GMP by passing `-d:disablegmp` as a compilation parameter)

  

# Support/Contributing

Feel free to open issues/pull requests if you are encountering problems, you can also join the official [Telegram group](https://t.me/nimgramchat) if you want.

  

# License

Nimgram is licensed under the [MIT license](https://github.com/nimgram/nimgram/blob/master/LICENSE).