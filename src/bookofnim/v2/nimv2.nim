##
## Nimv2 Hack
## ==========

##[
## TLDR
- migrating to V2
  - system modules moved to std library
    - assertions > std/assertions
    - atomics > std/sysatomics
    - widestrs > std/widestrs
    - system threads > architecture redesign
      - think this was split into multiple `system/thread*` modules
      - as well as some new std modules

TODOs
-----
- see if theres an alternative to include for supporting nimv2
  - check templateMacrosv2.outparams
- figure out where the impure/db_ modules moved to
- verify the TLDR about sys modules moved to std
  - ensure the source code is relatively the same and they arent a totally new module
- aggregate a big list of changes in this file
  - but still decompose examples into distinct files

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
- [asyncftpclient](https://github.com/nim-lang/Nim/blob/v1.6.12/lib/pure/asyncftpclient.nim)
- [future](https://github.com/nim-lang/Nim/blob/v1.6.12/lib/pure/future.nim)
- [nimtracker](https://github.com/nim-lang/Nim/blob/v1.6.12/lib/pure/nimtracker.nim)
- [punycode](https://github.com/nim-lang/Nim/blob/v1.6.12/lib/pure/punycode.nim)
- [smtp](https://github.com/nim-lang/Nim/blob/v1.6.12/lib/pure/smtp.nim)
  - weird because the smtp.nim.cfg still exists in v2

## system modules removed in v2
- [arithm](https://github.com/nim-lang/Nim/blob/v1.6.12/lib/system/arithm.nim)
- [dragonbox](https://github.com/nim-lang/Nim/blob/v1.6.12/lib/system/dragonbox.nim)
- [io](https://github.com/nim-lang/Nim/blob/v1.6.12/lib/system/io.nim)
- [schubfach](https://github.com/nim-lang/Nim/blob/v1.6.12/lib/system/schubfach.nim)
- [syslocks](https://github.com/nim-lang/Nim/blob/v1.6.12/lib/system/syslocks.nim)
- [syspawn](https://github.com/nim-lang/Nim/blob/v1.6.12/lib/system/sysspawn.nim)
- [threads](https://github.com/nim-lang/Nim/blob/v1.6.12/lib/system/threads.nim)
- [widestrs](https://github.com/nim-lang/Nim/blob/v1.6.12/lib/system/widestrs.nim)

]##

when (NimMajor, NimMinor, NimPatch) >= (1,9,3):
  include
    asyncParV2,
    dataWranglingV2,
    dbsV2,
    exceptionHandlingV2,
    osIoV2,
    stringsV2,
    systemV2,
    templateMacrosV2
