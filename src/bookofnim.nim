##
## the book of nim
## ===============
## :Authors:
##  noah
## :Org:
##  personal

##[
## TLDR
- the minimum nim needed to make meaningful nim v2 apps
- always check the nim docs for the full syntax
- if viewing this online:
  - every imported file has a `source` link to dive into the source code
- the imported files (see below)
  - are grouped by expected search patterns & use case
  - the nimscript guide [is available here](https://github.com/noahehall/nim/blob/develop/src/bookofnim/backends/targets/shell.nims)

links
-----
- [latest test results](https://noahehall.github.io/nim/htmldocs/testresults.html)
- use nims devel branch until the online documentation for v2 is ready
  - [docs](https://github.com/nim-lang/Nim/tree/devel/doc)
  - [system](https://github.com/nim-lang/Nim/blob/devel/lib/system.nim)
  - [system imports](https://github.com/nim-lang/Nim/tree/devel/lib/system)
  - [std](https://github.com/nim-lang/Nim/tree/devel/lib/std)
  - [pure](https://github.com/nim-lang/Nim/tree/devel/lib/pure)
  - [impure](https://github.com/nim-lang/Nim/tree/devel/lib/impure)

]##

{.push warning[UnusedImport]:off .}

# latest Nim v1
import bookofnim / helloworld / helloworld ## basic nim

import bookofnim / deepdives / [
    asyncPar, ## concurrency, parallelism (except async servers)
    collections, ## non list/queues, e.g. arrays and seqs
    containers,  ## tuples, tables and object
    crypto, ## cryptography (+ random) related
    data, ## json, csv, etc
    dataWrangling, ## regex, strscan, etc
    datetime, ## dates and times
    dbs, ## database clients + mime types
    ffi, ## interfacing with other languages
    filters, ## templating systems and preprocessors
    lists, ## list/queues
    maths, ## statistical analysis, rational numbers, etc
    osIo, ## operating system, distros, files etc
    pragmasEffects, ## pragmas and the effect system
    runtimeMemory, ## runtime memory operations
    servers, ## http, sockets, ftp etc + async versions
    strings, ## string utils, en/decoders, etc
    sugar, ## sugar, algorithms and other helpers
    templateMacros, ## templates and macros
    tests,  ## testament, nimble
  ]

import bookofnim / backends / [
    nimcMemory, ## compiler and memory management
    packaging, ## compiling, nimble, etc
    targeting, ## the 4 backends, archs, os, nimscript, etc
  ]

# latest nim v2
import bookofnim / v2 / nimv2
