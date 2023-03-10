##
## the book of nim
## ===============
## :Authors:
##  noah
## :Org:
##  personal

##[
## TLDR
- the minimum nim needed to make meaningful nim apps
- always check the nim docs for the full syntax
- if viewing this online:
  - every imported file has a `source` link to dive into the source code
- the imported files (see below)
  - are grouped by expected search patterns & use case
  - the nimscript source code [is available here](https://github.com/noahehall/nim/blob/develop/src/bookofnim/backends/targets/shell.nims)

links
-----
- [latest test results](https://noahehall.github.io/nim/testresults.html)
]##

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
    lists, ## list/queues
    maths, ## statistical analysis, rational numbers, etc
    osIo, ## operating system, distros, files etc
    pragmasEffects, ## pragmas and the effect system
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
