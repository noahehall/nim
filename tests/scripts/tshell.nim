discard """
  action: "run"
  batchable: false
  cmd: "nim e --hints:on -d:testing $options $file"
  joinable: false
  valgrind: true
"""

import "bookofnim/backends/targets/shell.nims"
