##
## structured containers
## =====================

##[
## TLDR
- heterogenous containers of named fields of any type
- objects, enums and tuples are in userDefinedTYpes.nim

links
-----
- where they all go?

todo
----
- in general everything about tables


## table
- syntactic sugar for an array constructor
- {"k": "v"} == [("k", "v")]
- {key, val}.newOrderedTable
- empty table is {:} in contrast to a set which is {}
- the order of (key,val) are preserved to support ordered dicts
- can be a const which requires a minimal amount of memory


]##

echo "############################ tables"
var myTable = {"fname": "noah", "lname": "hall"}
echo "my name is: ", $myTable
# TODO: find this in the docs somewhere, this seems a bit rediculouos
# ^ lol you can get the value via blah["key"] with hashtables
# @see https://nim-lang.org/docs/tables.html
echo "my firstname is: ", myTable[0][1]
