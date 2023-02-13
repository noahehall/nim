##
## os, io
## ======

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
  hostOS (const)
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

echo "############################ files "
# flushFile buffer down the toilet
# lines iterate over any line in file f
# open a file from a filehandle/string with a given fileMode (defaults readonly); doesnt throw
# readAll data from a file stream; raises IO exception/errors if current file pos not index 0
# readBuffer/Bytes/Chars/Line
# readChar shouldnt be used in perf critical code
# readLines should always provide 2 arguments
# reopen for redirecting std[in/out/err] file variables
# setFilePos
# setInheritable
# setStdIoUnbuffered
# slurp alias for staticRead
# staticRead compile-time readFile for easy resource embedding, e.g. const myResource = staticRead"mydatafile.bin"
# stderr stream
# stdin stream
# stdmsg expands to stdout/err depending on useStdoutAsStdmsg switch
# stdout stream
# write
# writeBuffer/Bytes/Chars/File/Line

const yoloWurlReadme = "yolowurl/yolowurl.md"

let entireFile = try: readFile yoloWurlReadme except: "" ## \
  ## calls readAll then closes the file afterwards
  ## raises IO exception on err
  ## use staticRead instead for compiletime
if entireFile.len is Positive:
  echo "file has ", len entireFile, " characters"


let first5Lines = try: readLines yoloWurlReadme, 5 except: @[] ## \
  ## raises IO exception on err, EOF if N > lines in file
  ## lines must be delimited by LF/CRLF
  ## available at compiletime
for line in first5Lines: echo "say my line: ", line

proc readFile: string =
  let f = open yoloWurlReadme ## \
    ## open string, fMode = fmRead, bufSize = -1: File
    ## open File; string/filehandle; fmode = fmRead: bool
    ## can pass bufSize whenever you pass a string
  defer: close f ## \
    ## make sure to close the file object
  echo "i started to read when I was ", getFilePos f
  echo "first line in file is: ", readline f
  echo if endOfFile f: "game over" else: "hooked on phonics worked for me"
  echo "we need to get a handle on this file ", getFileHAndle f ## \
    ## returns the C library's handle on the file
  echo "so instead use ", getOsFileHandle f ## \
    ## useful for platform specific logic
    ## perhaps always use getOsFileHandle, dunno
  echo "but wasnt good until i turned ", getFilePos f
  echo "reading so much I gained ", getFileSize f, " in bytes"
  result = readline f
echo "the current line in file is ", readFile()

try:
  for line in yoloWurlReadme.lines: echo "loop over line: ", line ## \
    ## append .lines to the string/File
    ## else it loops over the filename (not the content)
    ## raises IOError if file doesnt exist
except: echo "maybe file doesnt exist?"

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

echo "############################ stdin/out/err "

echo "whats your name: "
# echo "hello: ", readLine(stdin) disabled cuz it stops code runner

writeLine stdout, "equivalent to an echo"; flushFile stdout
writeLine stderr, "but i only see red"; flushFile stderr

echo "############################ exec related"

# gorge alias for staticExec
# gorgeEx similar to gorge but returns tuple(result, exitCode)

# docs
const buildInfo = "Revision " & staticExec("git rev-parse HEAD") &
                  "\nCompiled on " & staticExec("uname -v") ## \
                  ## compile time only
                  ## returns stdout + stderr
echo "build info: ", buildInfo
