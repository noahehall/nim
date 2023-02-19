##
## containers deepdive
## ===================
## [bookmark](https://nim-lang.org/docs/tables.html#pop%2COrderedTableRef%5BA%2CB%5D%2CA%2CB)

##[
TLDR
- [custom types as table keys require hashing](https://nim-lang.org/docs/tables.html#basic-usage-hashing)
- checkout data.nim for additional stuff
- you may need sugar, sequtils and strutils for effectively working with tables
- generally all table types have the same interface; CountTables have a bit more

todos
- tables
  - [the commit for indexBy, scroll down for tests](https://github.com/nim-lang/Nim/commit/5498415f3b44048739c9b7116638824713d9c1df)
  - newTableFrom

links
- high impact
  - [tables aka dictionary](https://nim-lang.org/docs/tables.html)
  - [string tables](https://nim-lang.org/docs/strtabs.html)
  - [enum utils](https://nim-lang.org/docs/enumutils.html)
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
  orderededTable = baseTable.toOrderedTable # newOrderedTable
  countTable = "pooperscooper".toCountTable # newCountTable


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
