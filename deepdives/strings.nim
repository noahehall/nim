#[
  @see https://nim-lang.org/docs/strutils.html
  @see https://nim-lang.org/docs/strformat.html
  @see https://nim-lang.org/docs/dollars.html
]#

#[
  # basics
  & = concat, is overloaded when strformat is imported
  $ = toString
]#

import std/[strutils, strformat]

let
  str1 = "pooper scooper"
  str2 = """
    long
    string
    literal
    nothing\i\s
    \s\es\ca\pe\d
    """
  str3 = r"raw string\tliteral"
  str4 = "\r\rstring\t\n\rstring"
  char1 = 'a'

echo "############################  dollars (system)"
# $ === toString
echo $1 & $2, " concats to 12"

echo "############################  strutils"
echo str1.split
echo str1.toUpperAscii
echo str1.repeat(5)
echo str2.strip.splitLines

# % is like &
echo "$1 $2" % ["index1", "index2"]
echo "$# $#" % ["get first", "then get next"]
echo "$hello $world" % ["hello", "yolo", "world", "wurl"]
echo "the number is ", parseInt("10")

echo "############################  strformat"
# fmt doesnt interprate literal escape sequeqnces
echo fmt"{str1}\n\n\n{str2}\n\n\n{str3}\n\n\n{str4}"
# & does intrepret literal escape sequences
echo &"{str1}\n\n\n{str2}\n\n\n{str3}\n\n\n{str4}"
# this is also how you can concat different types
let
  a = [1,2]
  b = @[1,2]
  c = 'c'
  d = "dee"

echo &"{a} {b} {c} {d}"

echo "############################  use cases"
# formatting objects
type
  Nirv = object
    paths, strats, actions: bool
var nirv = Nirv(paths: true, strats: true, actions: true)
echo "we need better $ " & $nirv
echo "we need better % $1 " % [$nirv]
echo &"we need better & {nirv}"
echo &"we need better & {$nirv}"

# overload dollars to modify the Nirv toString
proc `$`(self: Nirv): string =
  &"paths = {self.paths}, strats = {self.strats}, actions = {self.actions}"
echo "we need better `$` " & $nirv
echo &"[original] we need better & {nirv}"
echo &"[overloadded] we need better & {$nirv}"
