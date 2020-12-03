



import asyncnet
import ../rpc/encoding
import ../rpc/decoding
import asyncdispatch
import endians
import stew/endians2

type TcpNetworkTypes* = enum
    Abridged
    Intermediate

type TcpNetwork* = ref object
    connectionMode: TcpNetworkTypes
    socket: AsyncSocket

proc toBytes(x: uint32) : array[0..3, uint8] =
    if cpuEndian != littleEndian:
        var tempResult = cast[array[0..3, uint8]](x) 
        swapEndian32(addr result, addr tempResult[0])
    result = cast[array[0..3, uint8]](x)


proc newConnection*(address: string, port: uint16, netType: TcpNetworkTypes): Future[TcpNetwork] {.async.} =
    result = new(TcpNetwork)
    case netType
    #Abridged mode
    of Abridged:
        result.socket = await asyncnet.dial(address, cast[Port](port))
        var initialBuffer = uint8(0xEF)
        await result.socket.send(addr initialBuffer, 1)
    of Intermediate:
        result.socket = await asyncnet.dial(address, cast[Port](port))
        var initialBuffer = [uint8(238), 238, 238, 238]
        await result.socket.send(addr initialBuffer[0], 4)
    result.connectionMode = netType

proc close*(self: TcpNetwork) = self.socket.close() 

proc isClosed*(self: TcpNetwork): bool = self.socket.isClosed()
 
proc receive*(self: TcpNetwork):  Future[seq[uint8]]  {.async.} =
    case self.connectionMode
    #Abridged mode
    of Abridged:
        var lenght = cast[seq[uint8]](await self.socket.recv(1))
        var realLenght = 0
        if lenght[0] == 0x7F:
            lenght = cast[seq[uint8]](await self.socket.recv(3))
        copyMem(addr realLenght, addr lenght[0], len(lenght))
        result = cast[seq[uint8]](await self.socket.recv(realLenght * 4 ))
    of Intermediate:
        var lenght: uint32
        var lenghtBytes = cast[seq[uint8]](await self.socket.recv(4))
        var scalingg = newScalingSeq(lenghtBytes)
        scalingg.TLDecode(addr lenght)
        result = cast[seq[uint8]](await self.socket.recv(int32(lenght)))


proc write*(self: TcpNetwork, data: seq[uint8]) {.async.} =
    case self.connectionMode
    #Abridged mode
    of Abridged:
        var lenght = uint32(len(data)/4)
        if lenght >= 127:
            var finalbuffer = @[uint8(0x7F)] & toBytes(lenght)[0..2] & data
            await self.socket.send(addr finalbuffer[0], len(finalbuffer))
        else:
            var finalbuffer = @[uint8(lenght)] & data
            await self.socket.send(addr finalbuffer[0], len(finalbuffer))
    of Intermediate:
        var finalbuffer = TLEncode(uint32(len(data))) & data
        await self.socket.send(addr finalbuffer[0], len(finalbuffer))