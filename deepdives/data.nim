##
## working with data
## =================
## [bookmark](https://nim-lang.org/docs/json.html)

##[
TLDR
- [see dom96s response to this question before using marshal to parse json](https://stackoverflow.com/questions/26191114/how-to-convert-object-to-json-in-nim)

links
- high impact
  - [csv parser](https://nim-lang.org/docs/parsecsv.html)
  - [ht/xml parser](https://nim-lang.org/docs/xmlparser.html)
  - [ht/xml tree](https://nim-lang.org/docs/xmltree.html)
  - [ht/xml](https://nim-lang.org/docs/parsexml.html)
  - [json parser](https://nim-lang.org/docs/parsejson.html)
  - [json utils](https://nim-lang.org/docs/jsonutils.html)
  - [json](https://nim-lang.org/docs/json.html)
  - [logging](https://nim-lang.org/docs/logging.html)
  - [marshal](https://nim-lang.org/docs/marshal.html)
  - [mem files](https://nim-lang.org/docs/memfiles.html)
  - [parse cfg](https://nim-lang.org/docs/parsecfg.html)
  - [parse utils](https://nim-lang.org/docs/parseutils.html)
  - [var ints](https://nim-lang.org/docs/varints.html)


## json
- parsejson auto imported by json, but can also be imported explicitly
]##

# import std/[
#   json,
#   jsonutils,
#   marshal # they say not to use this for json
#   # parsejson auto imported by json, but can be imported explicitly
# ]

# echo "############################ json"
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
