#[
  procs
    @	Turn an array into a sequence
    add	Add an item to the sequence
    del	O(1) removal, doesn't preserve the order
    delete	Delete an item while preserving the order of elements (O(n) operation)
    insert	Insert an item at a specific position
    len	Return the length of a sequence
    newSeq	Create a new sequence of a given length
    newSeqOfCap	Create a new sequence with zero length and a given capacity
    pop	Remove and return last item of a sequence
    setLen	Set the length of a sequence
    x & y	Concatenate two sequences
    x[a .. ^b]	Slice of a sequence but b is a reversed index (both ends included)
    x[a .. b]	Slice of a sequence (both ends included)
    x[a ..< b]	Slice of a sequence (excluded upper bound)
]#
echo "############################ sequences dynamic-length dimensionally homogeneous"
# length can change @ runtime (like strings)
# always heap allocated & gc'ed
# always indexed starting at 0
# can be passed to any proc accepting a seq/openarray
# the @ is the array to seq operator: init array and convert to seq
# ^ or use the newSeq proc
# for loops use the items (seq value) or pairs (index, value) on seqs

# seq[T] generic type for constructing sequences
var
  poops: seq[int] = @[1,2,3,4]
  spoop: seq[int] = newSeq[int](4) # empty but has length 4
  emptySeq: seq[int]
  seqEmpty = newSeq[int]()

poops.add(5)
echo poops
spoop.add(poops)
echo spoop.len
echo "first ", poops[0]
echo "first ", poops[0 ..< 1]
echo "first 2", poops[0 .. 1]
echo "last ", poops[^1]

var me = "noAH"
me[0 .. 1] = "NO"
echo "change first 2 els ", me
