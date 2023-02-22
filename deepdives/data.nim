##
## working with data
## =================
## [bookmark](https://nim-lang.org/docs/json.html)

##[
TLDR
- [see dom96s response to this question before using marshal to parse json](https://stackoverflow.com/questions/26191114/how-to-convert-object-to-json-in-nim)
- json imports parsejson module; no need to import it twice

links
- high impact
  - [csv parser](https://nim-lang.org/docs/parsecsv.html)
  - [json parser](https://nim-lang.org/docs/parsejson.html)
  - [json utils](https://nim-lang.org/docs/jsonutils.html)
  - [json](https://nim-lang.org/docs/json.html)
  - [logging](https://nim-lang.org/docs/logging.html)
  - [marshal](https://nim-lang.org/docs/marshal.html)
  - [mem files](https://nim-lang.org/docs/memfiles.html)
  - [parse cfg](https://nim-lang.org/docs/parsecfg.html)
  - [parse utils](https://nim-lang.org/docs/parseutils.html)
- niche
  - [ht/xml parser](https://nim-lang.org/docs/xmlparser.html)
  - [ht/xml tree](https://nim-lang.org/docs/xmltree.html)
  - [ht/xml](https://nim-lang.org/docs/parsexml.html)
  - [html generator](https://nim-lang.org/docs/htmlgen.html)
  - [html parser](https://nim-lang.org/docs/htmlparser.html)
  - [var ints](https://nim-lang.org/docs/varints.html)

## json

json types
----------
- JsonNode
- JObject
- JArray
- JString
- JInt
- JFloat
- JBool
- JNull

]##

import std/[sugar, strutils, sequtils]

echo "############################ json"
# let
#   v1 = "value 1"
#   v2 = "value 2"

# # %* operator creates jsonNodes
# let jiggy = %* {
#   "k1": v1,
#   "k2": v2,
#   "k3": 20
#   }
# echo "gettin ", $jiggy, " wit it"

# const stringified = """{
#   "k1": "v1",
#   "k2": 20,
#   "k3": [1, 2, 3]
#   }"""
# let parsed = parseJson stringified
# # get[Str,Int,Float,Bool] converts json types to nim types
# echo "k1 is ", parsed["k1"].getStr
# echo "k3 is ", parsed["k3"][1].getInt

# # dealing with APIs is like in scala
# # you have to fully type the expected response
# type
#   Stringified = object
#     k1: string
#     k2: int
#     k3: seq[int]
# let nimTypes = to(parsed, Stringified)
# # now you can access the fields with standard nim syntax
# echo "sequence is ", nimTypes.k3
