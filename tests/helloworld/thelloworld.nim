discard """
  action: "run"
  valgrind: true
  disabled: true # memory leaks
"""

import bookofnim / helloworld / helloworld ## basic nim split into modules
