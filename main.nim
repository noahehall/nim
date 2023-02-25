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
- the htmldocs dont surface everything  (we arent using runnableExamples)
  - htmldocs provide high level info but very few nim API details
  - API examples & info are detailed in the source link at the top of every file
    - clone and run root/main.nim or backends/targets/shell.nims
- the imported files (see below) are like chapters in a book
  - grouped by expected search patterns & use case, not technical correctness
  - the nimscript digest [is available here](https://github.com/noahehall/nim/blob/develop/backends/targets/shell.nims)
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
