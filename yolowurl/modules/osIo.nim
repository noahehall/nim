##
## os, io and files
## ================

##[
## TLDR
- didnt finish this section, come back later

todos
- [io](https://nim-lang.org/docs/io.html)
- [check the nitch source code for good examples](https://github.com/unxsh/nitch)
- [check the nimgrep source code for good examples](https://github.com/nim-lang/Nim/blob/devel/tools/nimgrep.nim)
.. code-block:: Nim
  # bunch of todos
  cpuEndian
  cpuRelax

## os/io/file procs i think these are todo
- currentSourcePath() @see https://nim-lang.org/docs/system.html#currentSourcePath.t
- os.parentDir()
- macros.getProjectPath()
- getCurrentDir proc

## os vars/procs/etc
.. code-block:: Nim
  hostCPU (const)
    # "i386", "alpha", "powerpc", "powerpc64",
    # "powerpc64el", "sparc", "amd64", "mips",
    # "mipsel", "arm", "arm64", "mips64", "mips64el", "riscv32", "riscv64"
  # hostOS (const)
    # "windows", "macosx", "linux", "netbsd",
    # "freebsd", "openbsd", "solaris", "aix", "haiku", "standalone"

## io vars/procs/etc
.. code-block:: Nim
  FileMode = enum
    fmRead,                   # Open the file for read access only.
    fmWrite,                  # Open the file for write access only.
                              # If the file does not exist, it will be
                              # created. Existing files will be cleared!
    fmReadWrite,              # Open the file for read and write access.
                              # If the file does not exist, it will be
                              # created. Existing files will be cleared!
    fmReadWriteExisting,      # Open the file for read and write access.
                              # If the file does not exist, it will not be
                              # created. The existing file will not be cleared.
    fmAppend                  # Open the file for writing only; append data at the end.
]##

echo "############################ os"
echo "my hostCPU is " & hostCPU
echo "my hostOS is " & hostOS


# number of bytes owned by the process, but do not hold any meaningful data
echo "my process has X bytes of free memory ", getFreeMem()

# amount of memory i suppose, doesnt have description
echo "my process has X bytes of max memory ", getMaxMem()
echo "my process has X bytes of total memory ", getTotalMem()

# number of bytes owned by the process and hold data
echo "my process is using X bytes of memory ", getOccupiedMem()

echo "############################ io"
# stderr stream
# stdin stream
# stdout stream
# close a file
# endOfFile returns bool
# flushFile buffer down the toilet
# getFileHandle of the file f; useful for platform specific logic; use getOsFileHandle instead
# getFilePos of the file pointer that is reading from file f
# getFileSize in bytes
# getOsFileHandle of file f; only useful for platform specific logic
# open a file from a filehandle/string with a given fileMode (defaults readonly); doesnt throw
# readAll data from a file stream; raises IO exception/errors if current file pos not index 0
# readBuffer
# readBytes
# readChar
# readChars
# readFile use staticRead when used within a compile time macro
# readLine
# readLines should always provide 2 arguments
# reopen for redirecting std[in/out/err] file variables
# setFilePos
# setInheritable
# setStdIoUnbuffered
# write
# writeBuffer
# writeBytes
# writeChars
# writeFile
# writeLine
# lines iterate over any line in file f
# stdmsg expands to stdout/err depending on useStdoutAsStdmsg switch


let entireFile = readFile "yolowurl/yolowurl.md"
echo "file has ", len entireFile, " characters"

echo "whats your name: "
# echo "hello: ", readLine(stdin) disabled cuz it stops code runner

# you need to open a file to read line by line
# notice the dope bash-like syntax
proc readFile: string =
  let f = open "yolowurl/yolowurl.md"
  defer: close f # <-- make sure to close the file object
  result = readline f
echo "first line of file is ", readFile()

# upsert a file
const tmpfile = "/tmp/yolowurl.txt"
writeFile tmpfile, "a luv letter to nim"
echo readFile tmpfile

# overwrite an existing file
proc writeLines(s: seq[string]): void =
  let f = tmpfile.open(fmWrite) # open for writing
  defer: close f
  for i, l in s: f.writeLine l
writeLines @["first line", "Second line"]
echo readFile tmpfile

echo "############################ exec related"

# gorge alias for staticExec
# gorgeEx similar to gorge but returns tuple(result, exitCode)
# staticExec external process at compiletime and return its output (stdout + stderr)
# slurp alias for staticRead
# staticRead compile-time readFile for easy resource embedding, e.g. const myResource = staticRead"mydatafile.bin"

# docs
const buildInfo = "Revision " & staticExec("git rev-parse HEAD") &
                  "\nCompiled on " & staticExec("uname -v")
echo "build info: ", buildInfo
