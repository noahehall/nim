discard """
  action: "run"
  batchable: false
  cmd: "nim e --hints:on -d:testing $options $file"
  joinable: false
  valgrind: true
  disabled: true # thisDir() reports this file, and not the source file
"""

import "bookofnim/backends/targets/shell.nims"
