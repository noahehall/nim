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
    regex,
    strings,
    sugar,
    templateMacros,
  ],
  backends/[
    compiling,
    packaging,
    targeting,
  ]
