# Nimgram
# Copyright (C) 2020-2022 Daniele Cortesi <https://github.com/dadadani>
# This file is part of Nimgram, under the MIT License
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import std/random, std/options
import std/math
import std/times
import pkg/bigints
import stint
import std/strutils

## Module implemeting the PoW (Proof of Work) algorithm used by MTProto

proc brent(n: BigInt): BigInt =
  if n mod initBigInt(2) == initBigInt(0):
    return initBigInt(2)

  randomize(now().toTime().toUnix())
  var
    y = initBigInt(random.rand(int(parseBiggestInt($n)) - 1))
    c = initBigInt(random.rand(int(parseBiggestInt($n)) - 1))
    m = initBigInt(random.rand(int(parseBiggestInt($n)) - 1))
    g, r, q = initBigInt(1)
    x, k, ys = initBigInt(0)

  while g == initBigInt(1):
    x = y
    for i in uint64(0) ..< toInt[uint64](r).get:
      y = ((y * y) mod n + c) mod n
    k = initBigInt(0)
    while k < r and g == initBigInt(1):
      ys = y
      for i in 0 ..< toInt[uint64](min(m, r - k)).get:
        y = ((y * y) mod n + c) mod n
        q = q * abs(x - y) mod n
      g = initBigInt(gcd(toInt[uint64](q).get, toInt[uint64](n).get))
      k = k + m
    r = r * initBigInt(2)
  if g == n:
    while true:
      ys = ((ys * ys) mod n + c) mod n
      g = initBigInt(gcd(uint64(abs(float64(toInt[uint64](x).get) - float64(
          toInt[uint64](ys).get)).toBiggestInt), toInt[uint64](n).get))
      if g > initBigInt(1):
        break

  result = g

proc factors*(n: BigInt): (BigInt, BigInt) =

  let a = brent(n)
  let b = n div a
  if a < b: (a, b) else: (b, a)
