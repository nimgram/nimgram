



import asyncdispatch
import endians

proc toBytes*(x: uint32) : array[0..3, uint8] =
    if cpuEndian != littleEndian:
        var tempResult = cast[array[0..3, uint8]](x) 
        swapEndian32(addr result, addr tempResult[0])
    result = cast[array[0..3, uint8]](x)


type NetworkTypes* = enum
    NetTcpAbridged
    NetTcpIntermediate


type MTProtoNetwork* = ref object of RootObj

method connect*(self: MTProtoNetwork, address: string, port: uint16) {.async, base.} = discard

method write*(self: MTProtoNetwork, data: seq[uint8]) {.async, base.} = discard

method receive*(self: MTProtoNetwork):  Future[seq[uint8]]  {.async, base.} = discard

method isClosed*(self: MTProtoNetwork): bool {.base.} = true

method close*(self: MTProtoNetwork) {.base,  locks: "unknown".} = discard

