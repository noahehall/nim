##
## strings deepdive
## ================

##[
## TLDR
- since strings utilize many seq procs, start with sequtils
- see regex.nim for regex

links
- high impact
  - [str format](https://nim-lang.org/docs/strformat.html)
  - [parse utils](https://nim-lang.org/docs/parseutils.html)
  - [str utils](https://nim-lang.org/docs/strutils.html)
  - [critbit sorted strings](https://nim-lang.org/docs/critbits.html)
- niche
  - [cstr utils](https://nim-lang.org/docs/cstrutils.html)
  - [ropes (very long strings)](https://nim-lang.org/docs/ropes.html)
  - [str (high perf) basics](https://nim-lang.org/docs/strbasics.html)
  - [str misc](https://nim-lang.org/docs/strmisc.html)
  - [unicode](https://nim-lang.org/docs/unicode.html)
  - [unicode decode](https://nim-lang.org/docs/unidecode.html)
  - [word wrap](https://nim-lang.org/docs/wordwrap.html)
  - [encodings](https://nim-lang.org/docs/encodings.html)
  - [edit distance](https://nim-lang.org/docs/editdistance.html)
]##

import std/[strutils, strformat]

let
  oneline = "this is a one line string"
  multiline = "this is a\nmultiline string"


echo "############################  strutils"
echo oneline.split
echo oneline.toUpperAscii
echo oneline.repeat(5)
echo multiline.strip.splitLines

# % is like &
# echo "$1 $2" % ["index1", "index2"]
# echo "$# $#" % ["get first", "then get next"]
# echo "$hello $world" % ["hello", "yolo", "world", "wurl"]
# echo "the number is ", parseInt("10")

# echo "############################  strformat"
# # fmt doesnt interprate literal escape sequeqnces
# echo fmt"{str1}\n\n\n{str2}\n\n\n{str3}\n\n\n{str4}"
# # & does intrepret literal escape sequences
# echo &"{str1}\n\n\n{str2}\n\n\n{str3}\n\n\n{str4}"
# # this is also how you can concat different types
# let
#   a = [1,2]
#   b = @[1,2]
#   c = 'c'
#   d = "dee"

# echo &"{a} {b} {c} {d}"

# echo "############################  use cases"
# formatting objects
# type
#   Nirv = object
#     paths, strats, actions: bool
# var nirv = Nirv(paths: true, strats: true, actions: true)
# echo "we need better $ " & $nirv
# echo "we need better % $1 " % [$nirv]
# echo &"we need better & {nirv}"
# echo &"we need better & {$nirv}"
