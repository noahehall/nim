#[
  @see
    - https://nim-lang.org/docs/critbits.html
    - https://nim-lang.org/docs/deques.html
    - https://nim-lang.org/docs/enumerate.html
    - https://nim-lang.org/docs/heapqueue.html
    - https://nim-lang.org/docs/intsets.html
    - https://nim-lang.org/docs/lists.html
    - https://nim-lang.org/docs/options.html
    - https://nim-lang.org/docs/packedsets.html
    - https://nim-lang.org/docs/sequtils.html
    - https://nim-lang.org/docs/sets.html
    - https://nim-lang.org/docs/sharedlist.html
    - https://nim-lang.org/docs/sharedtables.html
    - https://nim-lang.org/docs/tables.html
]#
import std/[sequtils, sets]

echo "############################ sequtils"
# useful for functional programming

import std/sets

echo "############################ sets"
# efficient hash set and ordered hash set
# store any value that can be hashed and dont contain duplicates
# use cases
# remove dupes from a container
# membership testing
# math ops on two sets, e.g. unions, intersection, etc
