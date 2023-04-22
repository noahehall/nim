##
## data wrangling
## ==============
## [bookmark](https://nim-lang.org/docs/strscans.html)

##[
TLDR
- for parsing configuration files, see packaging
- re follows perl 5 (see pcre spec link) thus not posix compliant
- pegs meant to replace re
- scanf can be extended with arbitrary procs for data wrangling

links
- intros
  - [pcre specification](https://perldoc.perl.org/perlre)
  - [EBNF wikipedia](https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_form)
- examples
  - [nimgrep source code](https://github.com/nim-lang/Nim/blob/devel/tools/nimgrep.nim)
- high impact
  - [peg matching](https://nim-lang.org/docs/pegs.html)
  - [regex pcre wrapper](https://nim-lang.org/docs/re.html)
  - [string scans](https://nim-lang.org/docs/strscans.html)
  - [fusion matching](https://nim-lang.github.io/fusion/src/fusion/matching.html)
  - [parse utils](https://nim-lang.org/docs/parseutils.html)
- nitche
  - [perl compatible regex](https://nim-lang.org/docs/pcre.html)

todos
-----
- re
  - study the expression: no clue what this means

## re
- everything works as expected, only things i found interesting are listed
- wrapper around pcre pkg
- supports up to 20 or 40 capturing subpatterns, not sure which is correct
- start param can change where scan starts, but output is always relative to ^input
- findAll and split can be iterated
- =~ is particularly useful

re metacharacters
-----------------
- the usual suspects
- \ddd octal code ddd or backreference
- \x{hh} character with hex code hh


re exceptions
-------------
- RegexError re syntax invalid

re types
--------
- Regex
- RegexFlag enum
  - reIgnoreCase
  - reMultiLine ^ $ match new lines
  - reDotAll . matches anything
  - reExtended ignore whitespace and `#` and comments
  - reStudy study the expression?

re consts
---------
- MaxReBufSize high(cint)
- MaxSubPatterns 20


re procs
--------
- find
- match

]##

{.push warning[UnusedImport]:off .}

import std/[sugar, strformat]

echo "############################ re"
# rex"ignore whitespace and # comments"
# transformFile for quick scripting

const lost = "lost something in this string, can you help me find it?"

import std/re

echo fmt"""{lost.contains re"^lost.*\?$"=}"""
echo fmt"""{lost.endsWith re"it\?"=}"""
echo fmt"""{lost.startsWIth re"lost"=}"""
echo fmt"""{lost.find re"\s"=}"""
echo fmt"""{lost.findAll re"\s"=}"""
echo fmt"""{lost.findBounds re"thing"=}"""
echo fmt"""{lost.match re"lost"=}"""
echo fmt"""{lost.match re"matches at ^ unless start provided"=}"""
echo fmt"""{lost.matchLen re"lost"=}"""
echo fmt"""{lost.multiReplace [(re"some.*g\s", "my keys ")]=}"""
echo fmt"""{lost.replace re"some.*g\s", "my keys "=}"""
echo fmt"""{lost.replacef re"(some.*g\s)", "$1special " =}"""
echo fmt"""{lost.split re"\s"=}"""
echo fmt"""pass a block to access matches[] {lost =~ re".*find\s\{1\}it"=}"""
