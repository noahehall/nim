#[
  @see
    - https://nim-lang.org/docs/algorithm.html

  procs n stuff
    swap (a,b) swatch the values of a and b, more efficient than tmp = a; a = b; b = tmp.
]#

import std/algorithm

echo "############################ sort algorithms"
# cmp is useful for writing generic algs without perf loss
# cmpMem is available for pointer types
echo "echo sort seq[int] with cmp[int] ", sorted(@[4, 2, 6, 5, 8, 7], cmp[int])
