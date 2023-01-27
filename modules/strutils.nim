# https://nim-lang.org/docs/strutils.html

# std/X required because this module is named strutils
import std/strutils

let
  str1 = "pooper scooper"

echo str1.split()
echo str1.toUpperAscii()
echo str1.repeat(5)
