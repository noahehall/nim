##
## collections deep dive
## =====================
## [bookmark](https://nim-lang.org/docs/packedsets.html)

##[
## TLDR
- lists/queues are kept in lists.nim
- table like stuff in containers

## links
- high impact
  - [int sets](https://nim-lang.org/docs/intsets.html)
  - [ordered +/ hash sets](https://nim-lang.org/docs/sets.html)
  - [packed (sparse bit) sets](https://nim-lang.org/docs/packedsets.html)
  - [seq (seq, strings, array) utils](https://nim-lang.org/docs/sequtils.html)
  - [set utils](https://nim-lang.org/docs/setutils.html)
- niche
  - [fusion pointers](https://nim-lang.github.io/fusion/src/fusion/pointers.html)
  - [fixed length runtime arrays](https://nim-lang.org/docs/rtarrays.html)

## seqs
- toSeq(blah) transforms any iterable into a sequence
- newSeqWith useful for creating 2 dimensional sequences
- some procs have an it variant for even more succintness
  - allIt
  - anyIt
  - applyIt
  - countIt
  - filterIt
  - keepItIf
  - mapIt

## sets
- efficient hash set and ordered hash set
- values can be any hashable type, unlike system.set which only accept ordinals
- like most things, has items and pairs iterator
- types: all of the init like procs are no longer necessary
  - HashSet[A]
  - OrderedSet[A]
  - SomeSet[A] = HashSet|OrderedSet[A]
]##

import std/[sugar, strformat]

echo "############################ sequtils"
import std/[sequtils]

const
  immutable = toSeq(1..10)
  seq2d = newSeqWith(3, toSeq(1..5)) # @[@[1,2,3,4,5].repeat 3]
  zipped = @[("opt1", 'a'), ("opt2", 'b'), ("opt3", 'c')]

echo "############################ pure sequtils"

echo "newSeqWith ", seq2d
echo "all items?  ", immutable.all x => x < 11
echo "allIt is even cooler ", immutable.allIt it < 11
echo "any item? ", immutable.any x => x == 10
echo "concat ", concat immutable, immutable, immutable
echo "distribute == !concat: ", concat(immutable, immutable, immutable).distribute 3
echo "duplicate ", immutable.cycle 3
echo "deduplicate accepts isSorted 2nd param for faster algo ", deduplicate(immutable.cycle 3)
echo "occurance ", immutable.count 1
echo "map ", immutable.map x => x * 2
echo "index with largest value: ", maxIndex immutable
echo "index with smallest value: ", minIndex immutable
echo "repeat: ", 5.repeat 5
echo "unzip: ", unzip zipped
echo "zip: ", @["opt1", "opt2", "opt3"].zip @['a', 'b', 'c']
echo "mapLiterals to a diff type ", [0.1, 0.2].mapLiterals int
echo "fold left template requires a and b ", immutable.foldl a + b
echo "fold right template requires a and b ", immutable.foldr a + b

# hmm thought this would be 55 + 45, but instead its "55" + "45"
echo "fold left/right accepts an initial value ", immutable.foldl a + b, 45

echo "filter ", immutable.filter x => x > 5
for n in immutable.filter x => x > 9:
  echo "filter can be iterated " & $n


echo "############################ impure sequtils"
var mutable = toSeq(1..10)
var mutated: string
proc echoMutated(): void = echo "seq: ", $mutable, "str: ", $mutated

echoMutated()

mutable.apply x => x * x; echoMutated() ## \
  ## mutates its operand
mutable.apply x => mutated.addInt x; echoMutated() ## \
  ## mutates the string instead
mutable.delete 2..3; echoMutated() ## \
  ## inclusive from..to
mutable.insert @[3,2,1], 1; echoMutated() ## \
  ## default is to unshift at 0 and can be omitted
mutable.keepIf x => x > 0; echoMutated()

echo "############################ sets"
import std/sets

const
  stringSet1 = toHashSet ["ay", "bee", "see", "dee"] ## string|array|seq
  stringSet2 = toHashSet ["dee","ee", "ehf", "gee", "aych"]
  floatSet = toOrderedSet [1.0, 3.0, 2.0, 4.0]

echo "############################ sets pure"

echo fmt"alias for intersection {stringset1 * stringset2=}"
echo fmt"alias for union {stringset1 + stringset2=}"
echo fmt"alias for symmetricDifference {stringset1 -+- stringset2=}"
echo fmt"alias for difference {stringset1 - stringset2=}"
echo fmt"{stringset2 - stringset1=}"
echo fmt"{stringset1 <= stringset1=}"
echo fmt"{stringset1 == stringset1=}"
echo fmt"{(stringset1 * stringset2) < stringset1=}"
echo fmt"{stringset1.disjoint stringset2=}"
echo fmt"{stringset1.card=}"
echo fmt"{stringset1.len=}"
echo fmt"{stringset1.hash=}"
echo fmt"""{"ay" in stringset1=}"""
echo fmt"""{"yo" in stringset2=}"""
echo fmt"""{stringset1.contains "son"=}"""

var x = stringSet1
echo fmt"""requires a var to use [] getter {x["ay"]=}"""
echo fmt"{stringset1.map(x => x[^1])=}"


echo "############################ sets impure"

var mstringset = stringSet1
proc echoMutatedSet(): void = echo "strset: ", $mstringset

echo fmt"""true if item existed {mstringset.containsOrIncl "woop"=}"""; echoMutatedSet()
echo fmt"""{mstringset.containsOrIncl "woop"=}"""; echoMutatedSet()
echo fmt"""true if item missing {mstringset.missingOrExcl "woop"=}"""; echoMutatedSet()
echo fmt"""{mstringset.missingOrExcl "woop"=}"""; echoMutatedSet()
echo fmt"""silently removes key/hashset {{mstringset.excl "woop"}}"""
echo fmt"""adds key/hash if missing {{mstringset.incl "soup"}}"""
echo fmt"""pop an arbitrary item, throws on empty set {mstringset.pop=}"""
