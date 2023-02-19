#[
  @see
    - https://nim-lang.org/docs/json.html
    - https://nim-by-example.github.io/json/
    - https://nim-lang.org/docs/jsonutils.html
    - https://nim-lang.org/docs/marshal.html
    - https://nim-lang.org/docs/parsejson.html
    - https://nim-lang.org/docs/varints.html
    - https://nim-lang.org/docs/parsexml.html (and html)
    - https://nim-lang.org/docs/xmlparser.html (and html)
    - https://nim-lang.org/docs/xmltree.html (and html)
    - https://nim-lang.org/docs/parsecsv.html
    - https://nim-lang.org/docs/parseutils.html

  before using marshal for json @see # @see https://stackoverflow.com/questions/26191114/how-to-convert-object-to-json-in-nim
]#
import std/[
  json,
  jsonutils,
  marshal # they say not to use this for json
  # parsejson auto imported by json, but can be imported explicitly
]

echo "############################ json"
let
  v1 = "value 1"
  v2 = "value 2"

# %* operator creates jsonNodes
let jiggy = %* {
  "k1": v1,
  "k2": v2,
  "k3": 20
  }
echo "gettin ", $jiggy, " wit it"

const stringified = """{
  "k1": "v1",
  "k2": 20,
  "k3": [1, 2, 3]
  }"""
let parsed = parseJson stringified
# get[Str,Int,Float,Bool] converts json types to nim types
echo "k1 is ", parsed["k1"].getStr
echo "k3 is ", parsed["k3"][1].getInt

# dealing with APIs is like in scala
# you have to fully type the expected response
type
  Stringified = object
    k1: string
    k2: int
    k3: seq[int]
let nimTypes = to(parsed, Stringified)
# now you can access the fields with standard nim syntax
echo "sequence is ", nimTypes.k3
