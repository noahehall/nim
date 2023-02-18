#[
  @see
    - https://nim-lang.org/docs/enumutils.html
    - https://nim-lang.org/docs/options.html
    - https://nim-lang.org/docs/sharedtables.html
    - https://nim-lang.org/docs/strtabs.html
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
