##
## working with data
## =================
## [bookmark](https://nim-lang.org/docs/json.html#creating-json)

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
  - [fusion htmlparser](https://nim-lang.github.io/fusion/src/fusion/htmlparser.html)
  - [fusion ht/xml parser](https://nim-lang.github.io/fusion/src/fusion/htmlparser/parsexml.html)
  - [fusion ht/xml tree](https://nim-lang.github.io/fusion/src/fusion/htmlparser/xmltree.html)

## json

- [] field axor, throws if not found
- {} field axor, nil/default value if not found; works?.like?.es6 operator
- for JObject, key ordering is preserved
- use std/option for keys when marshalling a JsonNode to a custom type
- use `somekey` for some key thats some reserved nim keyword

json types
----------
- JsonNodeObj base type
- JsonNode ref JsonNodeObj object variant representing any json type
- JsonNodeKind enum
  - all have a newJBlah constructor
  - JArray seq[JsonNode]
  - JBool bool
  - JFloat float
  - JInt BiggestInt
  - JNull nil
  - JObject OrderedTable[string, JsonNode]
  - JString string

json procs
----------
- kind get json node type
- parseJson parses string into a json node
- getInt(defaultValue)
- getFloat(defaultValue)
- getStr(defaultValue)
- getBool(defaultValue)
- to unmarshal a JsonNode to an arbitrary type
]##

import std/[sugar, strformat, strutils, sequtils, options]

echo "############################ json pure"

import std/json

type
  Headers = object
    `Content-Type`, Vary, Scheme, Host, Method: string
    `X-Vault-Token`: Option[string]
    Status: int
  ResponseType = object
    body: seq[string]
    headers: Headers

const
  response = """{
    "body": ["nim", "lang"],
    "headers": {
        "Content-Type": "application/json",
        "Vary": "Accept-Encoding",
        "Scheme": "https",
        "Host": "www.poop.com",
        "Status": 200,
        "Method": "Get"
      }
    }"""

let
  resJson = response.parseJson ## dynamic: string -> json node
  resType = resJson.to ResponseType # fully typed: json node -> arbitrary type

echo fmt"{resJson.kind=}"
echo fmt"{resJson=}"
echo fmt"{resType=}"


echo fmt"""{resJson["body"][0].getStr=}"""
echo fmt"""{resJson["body"].to seq[string]=}"""
echo fmt"""{resJson["headers"]["Status"].getInt=}"""
echo fmt"""{resJson\{"headers","Status"\}.getInt=}"""
echo fmt"""curlies return default value {resJson\{"doesntexist"\}.getFloat=}"""
echo fmt"""e.g. empty string {resJson["headers"]\{"X-Vault-Token"\}.getStr=}"""



# let nimTypes = to(parsed, Stringified)
# # now you can access the fields with standard nim syntax
# echo "sequence is ", nimTypes.k3

echo "############################ json impure"

var
  reqData = %* {"name": "Tupac", "quotes": ["Dreams are for real"]} ## dynamic: instantiate json node

echo fmt"{reqData=}"
