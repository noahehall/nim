##
## collections deep dive
## =====================
## everything you need to work with collections of items

##[
TLDR
- this module deepends on sugar, start there first

links
- high impact
  - [seq (seq, strings, array) utils](https://nim-lang.org/docs/sequtils.html)
  - [double ended queue](https://nim-lang.org/docs/deques.html)
  - [enumarate any seq](https://nim-lang.org/docs/enumerate.html)
  - [heapqueue](https://nim-lang.org/docs/heapqueue.html)
  - [hash sets](https://nim-lang.org/docs/sets.html)
- niche
  - [int sets](https://nim-lang.org/docs/intsets.html)
  - [packed (sparse bit) sets](https://nim-lang.org/docs/packedsets.html)
]##
import std/[sequtils]
