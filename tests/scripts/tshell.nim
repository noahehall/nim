discard """
  action: "run"
  batchable: false
  cmd: "nim e --hints:on -d:testing $options $file"
  joinable: false
  valgrind: true
"""

import "backends/targets/shell.nims"
