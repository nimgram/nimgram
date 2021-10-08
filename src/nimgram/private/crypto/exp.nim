# Nimgram
# Copyright (C) 2020-2021 Daniele Cortesi <https://github.com/dadadani>
# This file is part of Nimgram, under the MIT License
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY
# OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.



import stint

when not defined(disablegmp):
    import gmp

proc exp*(sa, se, sm: StUint[2048]): StUint[2048] = 
    when defined(disablegmp):
        #Note: only use stint's powmod if you don't want external libraries to be loaded, it is slow
        return powmod(sa, se, sm)
    else:
        var a, e, m, r: mpz_t

        mpz_init(a)
        mpz_init(e)
        mpz_init(m)
        mpz_init(r)

        discard mpz_set_str(a, cstring(sa.toString()), cint(10))
        discard mpz_set_str(e, cstring(se.toString()), cint(10))
        discard mpz_set_str(m, cstring(sm.toString()), cint(10))

        mpz_powm_sec(r, a, e, m)

        var expStr = mpz_get_str(nil, cint(16), r)

        mpz_clear(a)
        mpz_clear(e)
        mpz_clear(m)
        mpz_clear(r)
        #TODO: Detected memory leak using Valgrind, check if it is fixable
        return fromHex(StUint[2048], $expStr)