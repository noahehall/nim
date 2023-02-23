##
## the book of nim
## ===============
## :Authors:
##  noah
## :Org:
##  personal

##[
TLDR
- everything you should know about nim
- always check the nim docs for the full syntax
- the htmldocs dont surface everything in source (we arent using runnableExamples)
  - click the source link at the top of any file
  - or clone and run root/main.nim or nimscript/nimscript.nims
]##

import
  # yolowurl/yolowurl,
  deepdives/[
    asyncParMem,
    collections,
    containers,
    data,
    datetime,
    osIo,
    regex,
    strings,
    sugar,
  ],
  backends/[
    compiler_builds
  ]
