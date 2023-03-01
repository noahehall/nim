discard """
  action: "run"
  valgrind: true
"""

import bookofnim / deepdives / [
    crypto, ## cryptography (+ random) related
    dataWrangling, ## regex, strscan, etc
    dbs, ## database clients + mime types
    lists, ## list/queues
    maths, ## statistical analysis, rational numbers, etc
    pragmasEffects, ## pragmas and the effect system
    strings, ## string utils, en/decoders, etc
    sugar, ## sugar, algorithms and other helpers
    templateMacros, ## templates and macros
  ]
