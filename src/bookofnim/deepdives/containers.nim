##
## containers deepdive
## ===================
## [bookmark](https://nim-lang.github.io/fusion/src/fusion/btreetables.html)

##[
## TLDR
- [custom types as keys require hash + == procs](https://nim-lang.org/docs/tables.html#basic-usage-hashing)
- generally all table types have the same interface; CountTables a bit more
- critbit can be used as a sorted string dictionary
- system.table is often used to collect and convert literals into std/tables

links
-----
- high impact
  - [tables: hash](https://nim-lang.org/docs/tables.html)
  - [tables: string](https://nim-lang.org/docs/strtabs.html)
  - [tables: fusion btree](https://nim-lang.github.io/fusion/src/fusion/btreetables.html)
- niche
  - [enum utils](https://nim-lang.org/docs/enumutils.html)
  - [shared tables](https://nim-lang.org/docs/sharedtables.html)

TODOs
-----
- tables
  - [the commit for indexBy, scroll down for tests](https://github.com/nim-lang/Nim/commit/5498415f3b44048739c9b7116638824713d9c1df)


## tables
- the initBlah procs arent necessary as their initialized by default
  - use {...}.toBlah or newBlah(...) instead
- custom types require an overloaded hash and == proc before being use as keys in a table

table types
-----------
- each has a blahRef variant
  - CountTable[A] tracks the occurrences of each key
  - OrderedTable[A; B] preserves the insertion order of keys
  - Table[A; B] regular hash table
- == check returns true if both/neither are nil and
  - count: content + count identical
  - ordered: content + order identical
  - table: content identical

## strtabs
- efficient string to string hash table supporting case/style in/sensitive
  - style insenstive: ignores _ and case
  - case is/not sensitive does what you think
- particularly powerful as values can be retrieved from ram if $key not found

strtab types
------------
- FormatFlag enum
  - useEnvironment value for $key if not found
  - useEmpty string as default $key value
  - useKey for value if not found in env/table
- StringTableMode enum
  - modeCase[In]Sensitive
  - modeStyleInsensitive
- StringTableObj
- StringTableRef

]##

{.push
  hint[GlobalVar]:off,
  hint[XDeclaredButNotUsed]:off,
  warning[UnusedImport]:off
.}

import std/[sugar, strformat, strutils]


echo "############################ tables"
# newTableFrom

import std/tables

const
  baseTable = {"fname": "noah", "lname": "hall"} ## system table
  hashTable = baseTable.toTable ## newTable
  orderededTable = baseTable.toOrderedTable ## [('a', 5), ('b', 9)].toOrderedTable
  countTable = "wooperscooper".toCountTable ## anyOpenArrayLikeThing.toCountTable
  anotherTable = toTable[string, int]({
    "first": 1,
    "second": 2
  })

echo "############################ pure tables"

echo fmt"{countTable.largest=}"
echo fmt"{countTable.smallest=}"
echo fmt"total keys {hashTable.len=}"
echo fmt"""throws keyError {hashTable["fname"]=}"""
echo fmt"""{hashTable.getOrDefault "if this", "else that"=}"""
echo fmt"""{hashTable.contains "fname"=}"""
echo fmt"""{hashTable.hasKey "fname"=}"""
echo fmt"""{"fname" in hashTable=}"""


let keys = collect:
  for k in hashTable.keys: k
echo fmt"collect hashTable.[m]keys: {keys=}"

let values = collect:
  for k in hashTable.values: k
echo fmt"collect hashTable.[m]values: {values=}"

let keyValues = collect:
  for k, v in hashTable.pairs: (k, v)
echo fmt"collect hashTable.[m]pairs: {keyValues=}"

echo "############################ impure tables"
var
  mutated = hashTable
  mCountTable = countTable
proc echoMutated(): void = echo "table: ", mutated, " count: ", mCountTable
echoMutated()

mutated["middle"] = "slime"; echoMutated()
mutated.del "middle"; echoMutated()
mCountTable.inc 'p'; echoMutated()
mCountTable.merge countTable; echoMutated()

echo fmt"""{mutated.mgetOrPut "some", "thing"=}"""
echo fmt"""returns bool, inserts on false {mutated.hasKeyOrPut "nope", "yup"=}"""
echoMutated()

var i: string = "puy"
echo fmt"""returns bool, moves value to blah {i=} -> ${mutated.pop "nope", i=} -> {i=}"""
echo fmt"""alias for pop {i=} -> ${mutated.take "epon", i=} -> {i=}"""

type
  User = object
    name: string
    uid: int

var t = initTable[int, User]() ## initialize an empty hash table
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


echo "############################ strtabs"
# len, keys, pairs, values

import std/strtabs

let
  authnz = {
    "ROLE": "USER",
    "TRUSTED": "0",
    }.newStringTable modeCaseSensitive ## \
      ## also accepts a tuple[varargs] of keyX,valY, ...

echo fmt"{authnz.mode=}"
echo fmt"key % obj -> $ROLE $TRUSTED" % authnz

echo fmt"""{"ROLE" in authnz=}"""
echo fmt"""{"RoLe" notin authnz=}"""
echo fmt"""{authnz.hasKey "woop"=}"""
echo fmt"""{authnz.getOrDefault "RoLe", "ANON"=}"""


echo "############################ strtabs impure"
# del

var newUser = newStringTable(modeCaseSensitive)

proc echoUser: void = echo fmt"{newUser=}"

echo "############################ custom objects as keys"
# example of using custom objects as keys
# see crypto.nim for full details of the hashes module

import std/hashes


proc hash(x: User): Hash = !$x.uid.hash
  ## arbitrary logic for hashing a User
  ## for use as key in a table

var userDictionary = initTable[User, string]()
userDictionary[User(name: "noah", uid: 1234)] = "custom keys!"

echo fmt"{userDictionary=}"
