##
## containers deepdive
## ===================
## [bookmark](https://nim-lang.org/docs/options.html)

##[
TLDR
- [custom types as keys require hash + == procs](https://nim-lang.org/docs/tables.html#basic-usage-hashing)
- generally all table types have the same interface; CountTables a bit more

todos
- tables
  - [the commit for indexBy, scroll down for tests](https://github.com/nim-lang/Nim/commit/5498415f3b44048739c9b7116638824713d9c1df)
  - newTableFrom

links
- high impact
  - [tables aka dictionary](https://nim-lang.org/docs/tables.html)
  - [string tables](https://nim-lang.org/docs/strtabs.html)
  - [enum utils](https://nim-lang.org/docs/enumutils.html)
  - [options](https://nim-lang.org/docs/options.html)
- niche
  - [shared tables](https://nim-lang.org/docs/sharedtables.html)


## tables
- the initBlah procs arent necessary as their initialized by default
  - use {...}.toBlah or newBlah(...) instead
- custom types require an overloaded hash and == proc before being use as keys in a table
- types: each has a blahRef variant
  - CountTable[A] tracks the occurrences of each key
  - OrderedTable[A; B] preserves the insertion order of keys
  - Table[A; B] regular dictionary
- == check returns true if both/neither are nil and
  - count: content + count
  - ordered: content + order
  - table:  content
]##

import std/[sugar, strformat, strutils, sequtils]

echo "############################ tables"
import std/tables

const
  baseTable = {"fname": "noah", "lname": "hall"}
  hashTable = baseTable.toTable # newTable
  orderededTable = baseTable.toOrderedTable # [('a', 5), ('b', 9)].toOrderedTable
  countTable = "pooperscooper".toCountTable # anyOpenArrayLikeThing.toCountTable


echo "############################ pure tables"

echo fmt"{countTable.largest=}"
echo fmt"{countTable.smallest=}"
echo fmt"total keys {hashTable.len=}"
echo fmt"""throws keyError {hashTable["fname"]=}"""
echo fmt"""{hashTable.getOrDefault "if this", "else that"=}"""
echo fmt"""{hashTable.contains "fname"=}"""
echo fmt"""{hashTable.hasKey "fname"=}"""
echo fmt"""{"fname" in hashTable=}"""

echo "############################ impure tables"
var
  mutated = hashTable
  mCountTable = countTable
proc echoMutated(): void = echo "table: ", mutated, " count: ", mcountTable
echoMutated()

mutated["middle"] = "slime"; echomutated()
mutated.del "middle"; echoMutated()
mCountTable.inc 'p'; echoMutated()
mCountTable.merge countTable; echoMutated()

echo fmt"""{mutated.mgetOrPut "some", "thing"=}"""
echo fmt"""returns bool, inserts on false {mutated.hasKeyOrPut "nope", "yup"=}"""
echoMutated()

var i: string = "puy"
echo fmt"""returns bool, moves value to blah {i=} -> ${mutated.pop "nope", i=} -> {i=}"""
echo fmt"""alias for pop {i=} -> ${mutated.take "epon", i=} -> {i=}"""

let keys = collect:
  for k in mutated.keys: k
echo fmt"collect mutated.[m]keys: {keys=}"

let values = collect:
  for k in mutated.values: k
echo fmt"collect mutated.[m]values: {values=}"

let keyValues = collect:
  for k, v in mutated.pairs: (k, v)
echo fmt"collect mutated.[m]pairs: {keyValues=}"

type
  User = object
    name: string
    uid: int

var t = initTable[int, User]()
let u = User(name: "Hello", uid: 99)
t[1] = u

t.withValue(1, value):
  ## block is executed only if `key` in `t`
  ## to modify value it must be a ref/ptr
  value.name = "Nim"
  value.uid = 1314

t.withValue(521, value):
  doAssert false
do:
  # block is executed when `key` not in `t`
  t[1314] = User(name: "exist", uid: 521)
