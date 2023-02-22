##
## working with data
## =================
## [bookmark](https://nim-lang.org/docs/json.html#add%2CJsonNode%2CJsonNode)

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
  - IMO use this over [] {"cuz", "u", "can", "do", "this"} to dig into an obj
- JObject preserves key ordering
- use std/option for keys when marshalling a JsonNode to a custom type
- use `somekey` for some key thats some reserved nim keyword
- %* doesnt support heterogeneous arrays, sets in objects, or not nil annotations

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
- getOrDefault from any j type
- getInt(defaultValue)
- getFloat(defaultValue)
- getStr(defaultValue)
- getBool(defaultValue)
- getBiggestInt(defaultValue)
- getElems(defaultValue) of an array
- getFields(defaultValue) of an object; requires import std/table
- to unmarshal a JsonNode to an arbitrary type
]##

import std/[sugar, strformat, strutils, sequtils, options, tables]

echo "############################ json "
# items/keys/mitems/mpairs/pairs
# parseJsonFragments
import std/json

type
  Headers = object
    `Content-Type`, Vary, Scheme, Host, Method: string
    `X-Vault-Token`: Option[string]
    Status: int
  ResponseType = object
    body: seq[string]
    headers: Headers

echo "############################ json pure"
# getBiggestInt
# parseFile fname into json


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
  resType = resJson.to ResponseType ## fully typed: json node -> arbitrary type

echo fmt"{resJson.pretty=}"""
echo fmt"{resJson.kind=}"
echo fmt"{resJson=}"
echo fmt"{resType=}"
echo fmt"{resJson.hash=}"
echo fmt"""{resJson.hasKey "body"=}"""
echo fmt"""{resJson.contains "body"=}"""
echo fmt"""{resJson.getOrDefault "body"=}"""
echo fmt"""{resJson.getOrDefault "headers"=}"""
echo fmt"""{resJson["body"].len=}"""
echo fmt"""{resJson["headers"].len=}"""
echo fmt"""{resJson["body"].getElems=}"""
echo fmt"""{resJson["body"].to seq[string]=}"""
echo fmt"""{resJson["body"][0].getStr=}"""
echo fmt"""{resJson["body"].contains %*"nim"=}"""
echo fmt"""{resJson["headers"].getFields=}"""
echo fmt"""{resJson["headers"]["Status"].getInt=}"""
echo fmt"""{resJson\{"headers","Status"\}.getInt=}"""
echo fmt"""{resJson["headers"]["Host"].copy=}"""

echo fmt"""curlies return default value {resJson\{"doesntexist"\}.getFloat=}"""
echo fmt"""e.g. empty string {resJson["headers"]\{"X-Vault-Token"\}.getStr=}"""
echo fmt"""{"string to json + quotes".escapeJson=}"""
echo fmt"""{"string to json - quotes".escapeJsonUnquoted=}"""

echo "############################ json impure"
# toUgly is faster than pretty/$ but requires a var

var
  reqData = %* { "tupac": {"quotes": ["dreams are for real"]}} ## dynamic: instantiate json node

proc echoReqData: void = echo fmt"{reqData=}"

echoReqData()

reqData["andreas"] = %* {"quotes": [
  "a language should scale like math: the same notation describes the lowest and highest layers"
]}
echoReqData()

reqData{"noah", "quotes"} = %* ["poop"]; echoReqData()

reqData{"noah", "quotes"}.add newJString("soup"); echoReqData()

reqData.add "greg", newJObject(); echoReqData()

reqData.delete "noah"; echoReqData()
