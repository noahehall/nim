##
## maths
## =====
## [bookmark](https://nim-lang.github.io/Nim/math.html)

##[
## TLDR
- come back later

links
-----
- high impact
  - [basic math](https://nim-lang.github.io/Nim/math.html)
  - [rational numbers](https://nim-lang.github.io/Nim/rationals.html)
  - [statistical analysis](https://nim-lang.github.io/Nim/stats.html)
- niche
  - [complex numbers](https://nim-lang.github.io/Nim/complex.html)
  - [floating point env](https://nim-lang.github.io/Nim/fenv.html)
  - [summation functions](https://nim-lang.github.io/Nim/sums.html)

system procs
------------
- min of 2 things
- max of 2 things
- clamp between two vals, faster than max(a, min(b, c))
- succ get the next value of an ordinal
- pred get the prev value of an ordinal
- inc the an ordinal in place
- dec dec an ordinal in place
]##

{.push warning[UnusedImport]:off .}

echo "############################ math"

import std/math
