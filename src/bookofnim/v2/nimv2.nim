##
## Nimv2 Hack
## ==========

##[
## TLDR
- to support nimv2 and v1 in the same app we had to use include (import must be module scoped)

TODOs
-----
- see if theres an alternative to include
  - check templateMacrosv2.outparams and update TLDR
- figure out where the impure/db_ modules moved to

## experimental modules in v2
- [diff](https://github.com/nim-lang/Nim/blob/devel/lib/experimental/diff.nim)

## std modules deprecated in v2
- [future](https://github.com/nim-lang/Nim/blob/devel/lib/deprecated/pure/future.nim)
- [mersenne](https://github.com/nim-lang/Nim/blob/devel/lib/deprecated/pure/mersenne.nim)
- [ospaths](https://github.com/nim-lang/Nim/blob/devel/lib/deprecated/pure/ospaths.nim)
- [oswalkdir](https://github.com/nim-lang/Nim/blob/devel/lib/deprecated/pure/oswalkdir.nim)
- [securehash](https://github.com/nim-lang/Nim/blob/devel/lib/deprecated/pure/securehash.nim)
- [sums](https://github.com/nim-lang/Nim/blob/devel/lib/deprecated/pure/sums.nim)

## std modules removed in v2
- [sums](https://github.com/nim-lang/Nim/blob/v1.6.12/lib/std/sums.nim)

]##

when (NimMajor, NimMinor, NimPatch) >= (1,9,3):
  include
    asyncParV2,
    dataWranglingV2,
    exceptionHandlingV2,
    osIoV2,
    stringsV2,
    templateMacrosV2
