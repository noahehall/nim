##
## Nimv2 Hack
## ==========

##[
## TLDR
- to support nimv2 and v1 in the same app we had to use include (import must be module scoped)

TODOs
-----
- see if theres an alternative to include
  - check templateMacrosv2.outparams

## modules removed in v1
- asdf
]##

when (NimMajor, NimMinor, NimPatch) >= (1,9,3):
  include
    asyncParV2,
    dataWranglingV2,
    exceptionHandlingV2,
    osIoV2,
    stringsV2,
    templateMacrosV2
