discard """
  action: "run"
  batchable: false
  cmd: "nim e --hints:on -d:testing $options $file"
  joinable: false
  valgrind: true
  disabled: true
  # ^ TODO(noah): thisDir() reports this file, and not the source file
  # ^ try currentSourcePath i think it is
"""

import "bookofnim/backends/targets/shell.nims"
