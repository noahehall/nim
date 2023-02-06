#[
  types
    - HSlice heterogeneous slice type
]#

echo "############################ range"
# b[0 .. ^1] ==  b[0 .. b.len-1] == b[0 ..< b.len]
# forward: starts at 0
# backward: start at ^1,
# range of values from an integer or enumeration type
# are checked at runtime whenever the value changes
# valuable for catching / preventing underflows.
# e.g. Nims natural type: type Natural = range[0 .. high(int)]
# ^ should be used to guard against negative numbers

# ^ returns a distinct int of type BackwardsIndex
const lastFour = ^4
const lastOne = ^1
echo "tell me your name ", "my name is noah"[lastFour .. lastOne]

type
  MySubrange = range[0..5]
echo MySubrange

echo "############################ slice"
# same syntax as slice but different type (Slice) & context
# collection types define operators/procs which accept slices in place of ranges
# the operator/proc specify the type of values they work with
# the slice provides a range of values matching the type required by the operator/proc

# copied from docs
var
  a = "Nim is a programming language"
  bbb = "Slices are useless."
echo a[7 .. 12] # --> 'a prog' > forward slice
bbb[11 .. ^2] = "useful" # backward slice
echo bbb # --> 'Slices are useful.'
