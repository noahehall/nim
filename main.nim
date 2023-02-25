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
  - or clone and run root/main.nim or backends/targets/shell.nims
- the imported files (see below) are grouped by expected search patterns
]##

import
  helloworld/helloworld,
  deepdives/[
    asyncParMem,
    collections,
    containers,
    data,
    datetime,
    maths,
    osIo,
    pragmasEffects,
    dataWrangling,
    strings,
    sugar,
    templateMacros,
    tests,
  ],
  backends/[
    compiling,
    packaging,
    targeting,
  ]
