
import asyncdispatch
import asyncnet
import ../transports
import ../../rpc/decoding
import ../../rpc/encoding
#[
Intermediate
In case 4-byte data alignment is needed, an intermediate version of the original protocol may be used.

Overhead: small
Minimum envelope length: 4 bytes
Maximum envelope length: 4 bytes
Payload structure:

+----+----...----+
+len.+  payload  +
+----+----...----+
]#

type TcpIntermediate* = ref object of MTProtoNetwork
    socket: AsyncSocket
    address: string
    port: uint16

method connect*(self: TcpIntermediate, address: string, port: uint16) {.async.} =
    self.socket = await asyncnet.dial(address, cast[Port](port))
    var initialBuffer = [uint8(238), 238, 238, 238]
    await self.socket.send(addr initialBuffer[0], 4)
    self.address = address
    self.port = port
    
method write*(self: TcpIntermediate, data: seq[uint8]) {.async.} = 
    var finalbuffer = TLEncode(uint32(len(data))) & data
    await self.socket.send(addr finalbuffer[0], len(finalbuffer))

method receive*(self: TcpIntermediate): Future[seq[uint8]] {.async.} = 
    var lenght: uint32
    var lenghtBytes = cast[seq[uint8]](await self.socket.recv(4))
    var scalingg = newScalingSeq(lenghtBytes)
    scalingg.TLDecode(addr lenght)
    result = cast[seq[uint8]](await self.socket.recv(int32(lenght)))

method isClosed*(self: TcpIntermediate): bool = self.socket.isClosed()

method close*(self: TcpIntermediate) = self.socket.close()


method reopen*(self: TcpIntermediate) {.async.} = 
    self.socket = await asyncnet.dial(self.address, self.port.Port)
    var initialBuffer = [uint8(238), 238, 238, 238]
    await self.socket.send(addr initialBuffer[0], 4)