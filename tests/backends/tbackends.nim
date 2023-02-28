discard """
  action: "run"
  valgrind: true
"""

import backends/[
    nimcMemory, ## compiler and memory management
    packaging, ## compiling, nimble, etc
    targeting, ## the 4 backends, archs, os, nimscript, etc
  ]
