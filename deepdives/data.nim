##
## working with data
## =================
## [bookmark](https://nim-lang.org/docs/json.html#creating-json)

##[
TLDR
- [see dom96s response to this question before using marshal to parse json](https://stackoverflow.com/questions/26191114/how-to-convert-object-to-json-in-nim)
- json imports parsejson module; no need to import it twice
  - [] field axor, throws if key not found
  - {} field axor, nil if key not found
- use std/option for keys when marshalling a JsonNode to a custom type
- use `somekey` for somekey thats a reserved nim identifier

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
- JsonNode object variant representing any json type
- JObject
- JArray
- JString
- JInt
- JFloat
- JBool
- JNull

json procs
----------
- kind get json node type
- parseJson parses json string into a json node
- getInt(defaultValue)
- getFloat(defaultValue)
- getStr(defaultValue)
- getBool(defaultValue)
- to marshal a JsonNode to custom type
]##

import std/[sugar, strutils, sequtils, options]

echo "############################ json"

import std/json
const
  apiResponse = """{
    "body": "404 not found",
    "headers": {
        "Content-Type": "text/xml",
        "Vary": "Accept-Encoding",
        "Scheme": "https"
        "Host": "www.poop.com"
        "Status": "404"
        "Method": "Get"
      }
    }"""
  v1 = "value 1"
  v2 = "value 2"

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
