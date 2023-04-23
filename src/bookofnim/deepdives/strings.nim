##
## strings
## =======
## [bookmark](https://nim-lang.org/docs/uri.html)

##[
## TLDR
- generally any proc that accepts a string, also accepts a char, and sometimes set[char]
- if supporting unicode, use the unicode procs to prevent any gotchas
  - e.g. the default .len proc doesnt return the actual number of chars in a unicode string

links
-----
- high impact
  - [str format](https://nim-lang.org/docs/strformat.html)
  - [str utils](https://nim-lang.org/docs/strutils.html)
  - [uri parsing](https://nim-lang.org/docs/uri.html)
- niche
  - [cstr utils](https://nim-lang.org/docs/cstrutils.html)
  - [ropes (very long strings)](https://nim-lang.org/docs/ropes.html)
  - [str (high perf) utils](https://nim-lang.org/docs/strbasics.html)
  - [str misc](https://nim-lang.org/docs/strmisc.html)
  - [unicode](https://nim-lang.org/docs/unicode.html)
  - [unicode decode](https://nim-lang.org/docs/unidecode.html)
  - [word wrap](https://nim-lang.org/docs/wordwrap.html)
  - [encodings](https://nim-lang.org/docs/encodings.html)
  - [edit distance](https://nim-lang.org/docs/editdistance.html)
  - [punycode](https://nim-lang.org/docs/punycode.html)


todos
-----
- strutils
  - BinaryPrefixMode, FloatFormatMode, SkipTable, addSep, align[left,right]
  - center, cmpIgnoreStyle, dedent, indent, indentation, unindent
  - nimIdentNormalize, validIdentifier
  - format (like % +auto stringifies), normalize, spaces
  - formatBiggestFloat, format[Eng, Float, Size], from[Bin, Hex, Oct]
  - initSkipTable, insertSep, intToStr
  - isAlpha[Ascii, Numeric],
  - is[Digit, EmptyOrWhitespace, LowerAscii, SpaceAscii, UpperAscii]
  - parse[Int, BiggestInt/Uint, BinInt, Bool, Enum, Float, HexInt, HexStr, OctInt, Uint]
  - to[Bin,Hex,Oct,Octal]
  - trimZeros,
- rework this entire file
  - we dont need examples of every fkn proc, but we should list them

## strformat
- simply importing strformat enhances the system & operator
- doesnt interprate literal escapes like & does e.g. fmt"{str1}\n\n\n"
- escape works with these [char](https://nim-lang.org/docs/manual.html#lexical-analysis-character-literals) and [string](https://nim-lang.org/docs/manual.html#lexical-analysis-string-literals) literals
  - for others use a hex/decimal char/string
  - if an API returns a string regex containing `\s` im sure theres something in regex.nim that can help
- fmt syntax: [[fill]align][sign][#][0][minimumwidth][.precision][type]
  - 3 align flags: > < ^
  - 3 sign flags for numbers: + - (space)
  - additional flags exist specifically for integers & floats
- [fmt floats section is interesting](https://nim-lang.org/docs/strformat.html#formatting-floats)
  - [as is fmt expressions](https://nim-lang.org/docs/strformat.html#expressions)
  - [shiz gets crazy](https://nim-lang.org/docs/strformat.html#implementation-details)
  - [flags for fmt](https://nim-lang.org/docs/strformat.html#standard-format-specifiers-for-strings-integers-and-floats)

## strutils
- AllChars (and related) useful for creating inverted sets to check for invalid chars in a string
- % used for index/named replacement
- stripLineEnd is useful conjunction with osproc.execCmdEx
- skipped type conversion procs; check skipped for the ones we skipped
- the split like procs also have an iterator syntax that accepts a block
- [tokenize looks interesting](https://nim-lang.org/docs/strutils.html#tokenize.i%2Cstring%2Cset%5Bchar%5D)

## string formatters
- strutils: "$1 $2" % ["first, "second"]
- strformat: fmt"{first} {second}"

]##

{.push warning[UnusedImport]:off, hint[XDeclaredButNotUsed]:off .}

import std/[sugar, sequtils]

let
  oneline = "this is a one line string"
  multiline = "this is a\nmultiline string"
  multiline2 = """
    this is a
    multiline string
  """

echo "############################  strformat"
import std/strformat

echo fmt"interoplation with fmt: \t{oneline}"
echo &"interpolation with &: \t {oneline}"
echo &"""padleft:>20 {"padleft":>20}"""
echo fmt"""padright:>20 {"padright":<20}"""
echo fmt"""padcenter:^20 {"padcenter":^20}"""
echo fmt"you debug strings like this {oneline=}"
echo fmt"even with expressions/procs/blocks/etc e.g. {(2*3)=}"
echo fmt"escape with double brackets {{oneline}}"

echo "############################ strutils pure"
import std/strutils

echo fmt"{{AllChars}} is the set of all characters"
echo "Digits, Letters, Newlines, Whitespace are particularly useful"
echo "HexDigits, IdentChars, IdentStartChars also exist"

echo "1-based index interpolation: 1=$1 2=$2" % ["index1", "index2"]
echo "verbatim interpolation: first=$# next=$#" % ["winner", "not the winner"]
echo "named interpolation: hello=$hello world=$world" % ["hello", "yolo", "world", "wurl"]

echo fmt"{oneline.split=}"
echo fmt"{oneline.split.join=}"
echo fmt"{oneline.rsplit=}"
echo fmt"{oneline.splitWhitespace=}"
echo fmt"{oneline.toUpperAscii.toLowerAscii.capitalizeAscii=}"
echo fmt"{oneline.repeat 2 =}"
echo fmt"{multiline.strip.splitLines=}"
echo fmt"{oneline.cmpIgnoreCase oneline.toUpperAscii=}"
echo fmt"{oneline.contains oneline[1..3]=}"
echo fmt"{oneline.count 'o'=}"
echo fmt"{multiline.countLines=}"

echo fmt"""\s is an invalid character: {"dunn\t\no".escape.unescape=}"""
echo fmt"""case sensitive {oneline.find "string"=}"""
echo fmt"""case sensitive {oneline.rfind "string"=}"""
echo fmt"""{oneline.endsWith "string"=}"""
echo fmt"""{oneline.startsWith "this"=}"""
echo fmt"""if subr starts at index {oneline.continuesWith("one", 10)=}"""
echo fmt"""index of first match {abbrev("woop", ["soup", "wooperscooper"])=}"""
echo fmt"""expects varargs[tuple] {oneline.multiReplace(("s","z"))=}"""
echo fmt"""{oneline.replace 's', 'z'=}"""

echo "allchars in set? ", "abc".allCharsInSet {'a','b','c'}
echo "count the occurance of a set a chars ", oneline.count {'o', 'n', 'e'}

echo "############################ strutils impure"
var mutated: string
proc echoMutated(): void = echo "str: ", $mutated

mutated.add "this string"; echoMutated()
mutated.addf &" {mutated}"; echoMutated() # faster than using add + formatter
mutated.delete 1.. (mutated.len div 2 + 1); echoMutated()
mutated.removePrefix "this "; echoMutated()
mutated.removeSuffix "string"; echoMutated()
