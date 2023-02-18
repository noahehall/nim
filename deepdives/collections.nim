##
## collections deep dive
## =====================
## everything you need to work with collections of items

##[
TLDR
- this module will heavily use sugar, start there first
- bookmark: https://nim-lang.org/docs/sequtils.html#delete%2Cseq%5BT%5D%2CSlice%5Bint%5D

links
- high impact
  - [seq (seq, strings, array) utils](https://nim-lang.org/docs/sequtils.html)
  - [double ended queue](https://nim-lang.org/docs/deques.html)
  - [enumarate any seq](https://nim-lang.org/docs/enumerate.html)
  - [heapqueue](https://nim-lang.org/docs/heapqueue.html)
  - [hash sets](https://nim-lang.org/docs/sets.html)
  - [packed (sparse bit) sets](https://nim-lang.org/docs/packedsets.html)
  - [int sets](https://nim-lang.org/docs/intsets.html)
- niche


## seq procs
- toSeq(blah) transforms any iterable into a sequence
- all
- any
- apply a proc to every item
]##

import std/[sequtils, sugar]

echo "############################ immutable sequtils"
const immutable = toSeq(1..10)
echo "all items?  ", immutable.all x => x < 11
echo "any item? ", immutable.any x => x == 10
echo "concat ", concat(immutable, immutable, immutable)
echo "duplicate ", immutable.cycle 3
echo "deduplicate accepts isSorted second param for faster algo ", deduplicate(immutable.cycle 3)
echo "occurance ", immutable.count 1


echo "############################ mutable sequtils"
var mutable = toSeq(1..10)
var mutated: string
proc echoMutated(): void = echo "seq: ", $mutable, "str: ", $mutated

echoMutated()

mutable.apply x => x * x
echoMutated()
mutable.apply x => mutated.addInt x # mutates the string instead
echoMutated()
