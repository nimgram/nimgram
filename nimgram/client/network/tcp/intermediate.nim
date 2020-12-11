
import asyncdispatch
import asyncnet
import ../transports
import ../../rpc/decoding
import ../../rpc/encoding

type TcpIntermediate* = ref object of MTProtoNetwork
    socket: AsyncSocket

method connect*(self: TcpIntermediate, address: string, port: uint16) {.async.} =
    self.socket = await asyncnet.dial(address, cast[Port](port))
    var initialBuffer = [uint8(238), 238, 238, 238]
    await self.socket.send(addr initialBuffer[0], 4)

method write*(self: TcpIntermediate, data: seq[uint8]) {.async.} = 
    var finalbuffer = TLEncode(uint32(len(data))) & data
    await self.socket.send(addr finalbuffer[0], len(finalbuffer))

method receive*(self: TcpIntermediate):  Future[seq[uint8]] {.async.} = 
    var lenght: uint32
    var lenghtBytes = cast[seq[uint8]](await self.socket.recv(4))
    var scalingg = newScalingSeq(lenghtBytes)
    scalingg.TLDecode(addr lenght)
    result = cast[seq[uint8]](await self.socket.recv(int32(lenght)))

method isClosed*(self: TcpIntermediate): bool = self.socket.isClosed()

method close*(self: TcpIntermediate)  = self.socket.close()
