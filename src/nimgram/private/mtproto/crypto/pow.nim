# Nimgram
# Copyright (C) 2020-2023 Daniele Cortesi <https://github.com/dadadani>
# This file is part of Nimgram, under the MIT License
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

## Module implemeting the PoW (Proof of Work) algorithm used by MTProto
## Taken from Gramme.rs

import pkg/tommath

proc factorize*(pq: uint64): (uint32, uint32) =
  if pq mod 2'u64 == 0:
    return (2'u32, cast[uint32](pq))
  
  let pq = initBigInt(pq)

  proc absSub(a: BigInt, b: BigInt): BigInt =
    return max(a, b) - min(a, b)
  
  var y = pq div initBigInt(4)
  let c = initBigInt(2) * pq div initBigInt(4)
  let m = initBigInt(3) * pq div initBigInt(4)
  var g, r, q = initBigInt(1)
  var x, ys = initBigInt(0)

  let one = initBigInt(1)
  let two = initBigInt(2)
  while g == one:
    x = y
    for _ in one..r:
      y = (powmod(y, two, pq) + c) mod pq
    
    var k = 0'u64
    while initBigInt(k) < r and g == one:
      ys = y
      for _ in one..min(m, (r - initBigInt(k))):
        y = (powmod(y, two, pq) + c) mod pq
        q = (q * absSub(x, y)) mod pq
      
      g = gcd(q, pq)
      k = toInt[uint64](initBigInt(k) + m) 
    
    r = r * two

  if g == pq:
    while true:
      ys = (powmod(ys, two, pq) + c) mod pq
      g = gcd(absSub(x, ys), pq)
      if g > one:
        break
  
  let (p, qq) = (toInt[uint32](g), toInt[uint32](pq div g))
  return (min(p, qq), max(p, qq))