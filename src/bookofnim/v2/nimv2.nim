##
## Nimv2 Hack
## ==========

##[
## TLDR
- to support nimv2 and v1 in the same app we had to use include (import must be module scoped)

TODOs
-----
- im sure theres a better strategy for doing this
]##

when (NimMajor, NimMinor, NimPatch) >= (1,9,3):
  include
    asyncParV2
