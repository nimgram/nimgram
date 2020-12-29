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

        discard mpz_set_str(a, sa.toString(), cint(10))
        discard mpz_set_str(e, se.toString(), cint(10))
        discard mpz_set_str(m, sm.toString(), cint(10))

        mpz_powm_sec(r, a, e, m)

        var expStr = mpz_get_str(nil, cint(16), r)

        mpz_clear(a)
        mpz_clear(e)
        mpz_clear(m)
        mpz_clear(r)
        #TODO: Detected memory leak using Valgrind, check if it is fixable
        return fromHex(StUint[2048], $expStr)