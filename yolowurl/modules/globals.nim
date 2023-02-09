#[
  additional global operators, procs, etc
  only captured the unusual/interesting globals
  everything else is likely in another file


  @see
    - https://nim-lang.org/docs/system.html#8 are all on this page somewhere
]#

echo "############################ interesting globals"
# globalRaiseHook (var) influence exception handling on a global level
# ^ if not nil, every raise statement calls this hook
# ^ if returns false, exception is caught and does not propagate
# addAndFetch doesnt have a description
# addEscapedChar escapes y:char then appends to x:string
# addQuoted escapes and quotes y:string then appends to x:string
# copyMem copies content from memory at source to memory at dest
# cpuRelax
# create allocates a new memory block with atleast T.sizeof * size bytes
# createShared allocates new memory block on the shared heap with atleast T.sizeof * bytes
# createSharedU allocates new memory block on the shared heap with atleast T.sizeof * bytes
# createU allocates memory block atleast T.sizeof * bytes
# dealloc frees the memory allocated with alloc, alloc0, realloc, create or createU
# deallocHeap frees the thread local heap
# deallocShared frees the mem allocated with allocShared, allocShared0 or reallocShared
# equalMem compares size bytes of mem blocks a and b
# errorMessageWriter (var) called instead of stdmsg.write when printing stacktrace
# freeShared frees the mem allocated with createShared, createSharedU, or resizeShared
# GC_disable()
# GC_disableMarkAndSweep()
# GC_enable()
# GC_enableMarkAndSweep()
# GC_fullCollect()
# GC_getStatistics():
# getAllocStats():
# getFrame():
# getFrameState():
# isNotForeign returns true if x belongs to the calling thread
# iterToProc
# moveMem copies content from memory at source to memory at dest
# onUnhandledException (var) override default behavior: write stacktrace to stderr then quit(1)
# outOfMemHook (var) override default behavior: write err msg then terminate (see docs for example)
# prepareMutation string literals in ARC/ORC mode are copy on write, this must be called before mutating them
# rawEnv retrieve the raw env pointer of a closure
# rawProc retrieve the raw proc pointer of closer X
# reset an object to its default value
# resize a memory block
# resizeShared
# setControlCHook proc to run when program is ctrlc'ed
# sizeof blah in bytes
# unhandledExceptionHook (var) override default behavior: write err msg then terminate
# compileOption(x[, y]) check if a switch is active and/or its value at compile time

# hostCPU (const) "i386", "alpha", "powerpc", "powerpc64", "powerpc64el", "sparc", "amd64", "mips", "mipsel", "arm", "arm64", "mips64", "mips64el", "riscv32", "riscv64"
echo "my hostCPU is " & hostCPU

# hostOS (const) "windows", "macosx", "linux", "netbsd", "freebsd", "openbsd", "solaris", "aix", "haiku", "standalone"
echo "my hostOS is " & hostOS

# appType (const) console|gui|lib
echo "app type is " & appType

# CompileTime (const) HH:MM:SS
echo "i was compiled at " & CompileTime

# isMainModule (const) true if module accessed as main module; used to embed tests
echo "am i the main module? ", $isMainModule

# NaN (const) IEEE value for Not a number; use isNan/classify from math instead
# NimMajor (const)
# NimMinor (const)
# NimPatch (const)
# NimVersion (const)
echo "does NimVersion = NimMajor.NimMinor.NimPatch? ",
  $NimVersion, " = ", $NimMajor, ".", $NimMinor, ".", $NimPatch

# off (const) alias for false
echo "off is an alias for ", $off

# on (const)
echo "on is an alias for ", $on

# QuitFailure (const) failure value passed to quit
echo "on failure I call quit with ", $QuitFailure

# QuitSuccess (const)
echo "on success i call quit with ", $QuitSuccess

# number of bytes owned by the process, but do not hold any meaningful data
echo "my process has X bytes of free memory ", getFreeMem()

# amount of memory i suppose, doesnt have description
echo "my process has X bytes of max memory ", getMaxMem()
echo "my process has X bytes of total memory ", getTotalMem()

# number of bytes owned by the process and hold data
echo "my process is using X bytes of memory ", getOccupiedMem()

# efficiently retrieve a tuple of all local variables
echo "locally defined vars are those not in a global scope ", locals()
block superPrivateScope:
  var inScope: string = "im in a block"
  echo "locals in a block: ", locals()

# shorthand for echo(msg); quit(code)
echo "quit the program with quit(n) or quit(msg, n)"

echo "############################ global vars"
# labeled var because they are anonymous procs
# localRaiseHook: same as globalRaiseHook but on a thread local level

echo "############################ global let"
# nimvm: bool true in Nim VM context and false otherwise; valid for when expressions

echo "############################ global const"
# cpuEndian
# Inf
# NegInf

echo "############################ global collections/sequences"
# overload contains proc for custom in logic
echo "seq[int] contains 6 ", @[5,6,7].contains(6)
echo "(1..3) contains 2 ", (1..3).contains(2)
echo "is a in arr[char] ", 'a' in ['a', 'b', 'c']
echo "99 notin {1,2,3} ", 99 notin {1,2,3}
echo "index of b in [a,b,c] ", ['a','b', 'c'].find('b')
echo "index of 4 in @[1..8] ", @[1,2,3,4,5,6,7,8].find 4

echo "############################ a word on operators"
echo "anything like `xBLAH=` can be written `xBLAH =`"
echo "the former enables you to define/overload operators via 'proc `poop=`[bloop](soop): doop = toot'"

echo "############################ global operators dunno"
# x =copy y
# x =destroy y Generic destructor implementation
# x =sink y Generic sink implementation
# x =trace y Generic trace implementation

echo "############################ global operators numbers"

var globalint = 2
var globalfloat = 2.5

echo "can use blah% w/ generally any operator. ints are suppose to cast to uint before operation but doesnt seem to work"
echo "10 %% 3 = ", 10 %% 3
echo "3 *% -3 = ", 3 *% -3
echo "3 +% -3 = ", 3 +% -3
echo "3 <=% -3 = ", 3 <=% -3
echo "can use blah= w/ generally any operator to mutate in place "
echo "*= will multiply in place and return void for ints/floats, lol remember those errors we kept getting in the beginning?"


echo "############################ global operators string/char"

var globalstring = "before"
globalstring &= "appends in place, returns void"
echo "before ", globalstring

echo globalstring & "appends char or string and returns new string"

echo "############################ global operators seqs"
# @ converts [x..y, type] into seq[type] efficiently
# converting an openArray into a seq is not as efficient as it copies all elements
var globalseq = @[1,2,3]

echo "concat 2 seq, copies both returns new", globalseq & @[4,5,6]
echo "copy seq then append a single el and return new seq ", globalSeq & 4
echo "copy seq then prepend a single el and return new seq ", 0 & globalseq

echo "############################ global operators sets"

var globalset1 = {1,2,3}
var globalset2 = {2,4,6}
echo "intersection of {1,2,3} and {2,4,6} = ", globalset1 * globalset2
echo "union of {1,2,3} and {2,4,6} = ", globalset1 + globalset2
echo "difference of {1,2,3} and {2,4,6} = ", globalset1 - globalset2
echo "is {1,2,3} a subset of {1,2,3} ", globalset1 <= {1,2,3}
echo "is {1,2,3} a strict subset of y ", globalset1 < {1,2,3}
echo "the cardinality of {1,2,3} is ", card globalset1

var globalset11 = deepCopy globalset1
globalset11.excl({2})
echo "remove {2} from {1,2,3} ", globalset11

echo "############################ global operators ordinal"
var globalarr = [1,0,0,4]
globalarr[1..2] = @[2,3]
echo "inplace mutation [1,0,0,4][1..2]= @[2,3] should be ", globalarr
