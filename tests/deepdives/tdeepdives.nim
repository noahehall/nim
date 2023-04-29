discard """
  action: "run"
  valgrind: true
"""

import bookofnim / deepdives / [
    collections, ## non list/queues, e.g. arrays and seqs
    containers,  ## tuples, tables and object
    crypto, ## cryptography (+ random) related
    data, ## json, csv, etc
    dataWrangling, ## regex, strscan, etc
    datetime, ## dates and times
    ffi, ## interfacing with other languages
    filters, ## templating systems and preprocessors
    lists, ## list/queues
    maths, ## statistical analysis, rational numbers, etc
    memoryCompiler, ## memory GC and compiler
    memoryRuntime, ## runtime memory operations
    osIo, ## operating system, distros, files etc
    packaging, ## packaging and configuring apps
    pragmasEffects, ## pragmas and the effect system
    servers, ## http, sockets, ftp etc + async versions
    strings, ## string utils, en/decoders, etc
    sugar, ## sugar, algorithms and other helpers
    templateMacros, ## templates and macros
    tests,  ## testament
  ]
