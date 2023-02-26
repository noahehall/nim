##
## the book of nim
## ===============
## :Authors:
##  noah
## :Org:
##  personal

##[
## TLDR
- everything you should know about nim
- always check the nim docs for the full syntax
- the htmldocs dont surface everything (we arent using runnableExamples)
  - htmldocs provide high level info but few API details
  - source links at the top of every file, however, provide detailed examples
- the imported files (see below) are like chapters in a book
  - grouped by expected search patterns & use case, not technical correctness
  - the nimscript digest [is available here](https://github.com/noahehall/nim/blob/develop/backends/targets/shell.nims)
]##

import
  helloworld/helloworld, ## basic nim split into modules
  deepdives/[
    asyncPar, ## concurrency, parallelism
    collections, ## non list/queues, e.g. arrays and seqs
    containers,  ## tuples, tables and object
    data, ## e.g. json, csv
    dataWrangling, ## e.g. regex
    datetime, ## dates and times
    maths, ## math stuff
    osIo, ## operating system, distros, files etc
    pragmasEffects, ## pragmas and the effect system
    servers, ## http, sockets, ftp etc
    strings, ## e.g. string utils
    sugar, ## sugar, algorithms and other helpers
    templateMacros, ## templates and macros
    tests, ## e.g. testament, and unittests
  ],
  backends/[
    nimcMemory,
    packaging,
    targeting,
  ]
