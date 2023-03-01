discard """
  action: "run"
  valgrind: true
  disabled: true # memory leaks
"""

import bookofnim / deepdives / [
    servers, ## http, sockets, ftp etc + async versions
    osIo, ## operating system, distros, files etc
    datetime, ## dates and times
    data, ## json, csv, etc
    containers,  ## tuples, tables and object
    collections, ## non list/queues, e.g. arrays and seqs
    asyncPar, ## concurrency, parallelism (except async servers)
  ]
