import random
import algorithm
import math
import times
import stint
import strutils

## NOTE: even if this module is inside "crypto", there isn't actually any type of cryptography in place
## Random can be used safetly because this operation is only used as a POW (proof of work)
## Ported from Python code

proc brent*(n: Int128): Int128 =
  if n mod Int128(2.stint(128)) == Int128(0.stint(128)):
    return Int128(0.stint(128))
  
  randomize(now().toTime().toUnix())
  var
    y = Int128(random.rand(int(parseBiggestInt($n)) - 1).stint(128))
    c = Int128(random.rand(int(parseBiggestInt($n)) - 1).stint(128))
    m = Int128(random.rand(int(parseBiggestInt($n)) - 1).stint(128))
    g, r, q = Int128(1.stint(128))
    x, k, ys = Int128(0.stint(128))
  
  while g == Int128(1.stint(128)):
    x = y
    for i in uint64(0) ..< r.truncate(uint64):
      y = ((y * y) mod n + c) mod n
    k = Int128(0.stint(128))
    while k < r and g == Int128(1.stint(128)):
      ys = y
      for i in 0 ..< min(m, r - k).truncate(uint64):
        y = ((y * y) mod n + c) mod n
        q = q * abs(x - y) mod n
      g = Int128(gcd(q.truncate(uint64), n.truncate(uint64)).stint(128))
      k = k + m  
      #t = k + m
      #k = t
    r = r * Int128(2.stint(128))
  if g == n:
    while true:
      ys = ((ys * ys) mod n + c) mod n
      g = gcd(uint64(abs(float64(x.truncate(uint64)) - float64(ys.truncate(uint64))).toBiggestInt), n.truncate(uint64)).stint(128)
      if g > Int128(1.stint(128)):
        break
  
  result = g

proc factors*(n: Int128): (Int128, Int128) =
  let a = brent(n)
  let b = n div a
  if a < b: (a, b) else: (b, a)
