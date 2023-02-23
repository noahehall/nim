##
## os and i/o
## ==========
## [bookmark](https://nim-lang.org/docs/osproc.html)

##[
## TLDR
- if a proc accepts a filename (string), it may also accept a File/Filehandle
- generally you should check when defined(posix/linux/etc) and use unixToNativePath
  - extremely relevant if your app supports disparate systems
  - posix
    - admin: root
    - cachedir: XDG_CACHE_HOME | HOME / .cache [/ app] (etc for other dir types)
    - dest paths inherit [user default perms](https://www.baeldung.com/linux/new-files-dirs-default-permission)
    - dir symlinks copied as symlinks to dest
    - executables not in path may require "executable.sh".normalizeExe to get `./executable.sh`
    - file creation time may actually be last modified time
    - file symlinks are followed (by default) then copied to dest
    - osLastError works like $?
    - paramCount not defined when generating dynamic libraries (See --app:lib)
    - parseCmdLine splits on whitespace outside of quotes (use parseopt module instead)
    - path considered hidden based solely on the path string
    - paths are case sensitive
    - permissions are copied after file/dir is -> could lead to race conditions
    - permissions can be set without following symlinks if lchmod is avail and doesnt err
    - relativePath works as expected
    - removeFile errors if readonly
    - tempdir: TMPDIR | TEMP | TMP | TEMPDIR
  - windows
    - admin: admin local group
    - cachedir: LOCALAPPDATA [/ app / cache] (etc for other dir types)
    - dest paths inherit source paths attributes
    - dir & file symlinks are skipped
    - network paths are considered absolute
    - osLastError works like windows i guess
    - parseCmdLine is overly complex (use parseopt module instead)
    - path considered hidden if file exists and hidden attribute set
    - paths are case insensitive
    - relativePath requires startpath & basepath args with same roots
    - removeFile errors ignores read-only attribute
    - require evelated privs for sym/hardlinks
    - tempdir: calls windows GetTempPath
    - permissions set on files have to follow symlinks
  - OSX
    - i think OSX should align with posix sans whatever follows
    - cachedir: XDG_CACHE_HOME | HOME / .cache [/app] (etc for other dir types)

## links
- high impact
  - [basic os utils](https://nim-lang.org/docs/os.html)
  - [distro detection & os pkg manager](https://nim-lang.org/docs/distros.html)
  - [fusion file permissions](https://nim-lang.github.io/fusion/src/fusion/filepermissions.html)
  - [fusion io utils](https://nim-lang.github.io/fusion/src/fusion/ioutils.html)
  - [fusion scripting](https://nim-lang.github.io/fusion/src/fusion/scripting.html)
  - [get cpu/cors info](https://nim-lang.org/docs/cpuinfo.html)
  - [i/o multiplexing](https://nim-lang.org/docs/selectors.html)
  - [nim cmd line parser](https://nim-lang.org/docs/parseopt.html)
  - [posix wrapper](https://nim-lang.org/docs/posix_utils.html)
  - [process exec & comms](https://nim-lang.org/docs/osproc.html)
  - [read stdin](https://nim-lang.org/docs/rdstdin.html)
  - [terminal](https://nim-lang.org/docs/terminal.html)
- niche
  - [open users browser](https://nim-lang.org/docs/browsers.html)
  - [raw posix interface]https://nim-lang.org/docs/posix.html

## todos
- os
  - DynlibFormat, ExeExt[s], ScriptExt


## os

os exceptions
-------------
- OSError e.g. file not found, incorrect perms

os types
--------
- CopyFlag[enum] symlink handling
- DeviceId[int32]
- FileId[int64]
- FileInfo[object] associated with a file object
- FilePermission[enum] modeled after nix
- OSErrorCode[int32]
- PathComponent[enum] type of path(file, symlink to (dir/file)) to a file object
- ReadDirEffect[object] reading a dir
- ReadEnvEffect[object] reading from ram
- WriteDirEffect[object] write to a dir
- WriteEnvEffect[object] write to ram

os consts
---------
- AltSep '/'
- CurDir '.'
- DirSep '/'
- doslikeFileSystem true
- ExtSep '.'
- FileSystemCaseSensitive false
- invalidFilenameChars {'bunch of stuff'}
- invalidFilenames ["bunch of stuff"]
- ParDir ".."
- PathSep ';'

os procs
--------
- copyFile dest parentDir must exist; overwrites but preserves perms
- execShellCmd blocks until finished
- createDir mkdir -p
- existsOrCreateDir mkdir
- moveDir doesnt follow symlinks, thus symlinks are moved and not their target
- moveFile (see moveDir) + can be used to rename files
- normalizePath (no d) modifies string inplace
- normalizeExe prefixes path with ./
- osErrorMsg converts an OSErrorCode to a human readable string
- osLastError $?
- newOsError errorCode determines the msg as retrieved by osErrorMsg, get code via osLastError
- raiseOsError


## osproc
- advanced cmd execution & process communication

osproc types
------------
- Process ref of an os proces
- ProcessOption enum that can be passed to startProcess
  - poEchoCmd before executing
  - poUsePath to find cmd
  - poEvalCommand without quoting
  - poStdErrToStdOut 2>&1
  - poParentStreams use parent stream
  - poInteractive optimize buffer handling for UI applications
  - poDaemon execute cmd in background
]##

import std/[sugar, strformat, strutils, sequtils, tables]

echo "############################ os"

import std/os

var i: int

const
  tmpdir = "/tmp/nim"
  dirtmp = "/tmp/min"
  fossdir = "~/git/foss/"
  dotpath = "./par/sibl/nephew"
  relpath = "par/sibl/niece"
  somefile = "README"
  md = "md"
  readme = somefile.addFileExt md
  txt = "txt"

echo "############################ os paths"
# createHardLink src, dest
# createSymlink src, dest
# expandSymlink
# symlinkExists

echo fmt"{absolutePath dotpath=}"
echo fmt"{absolutePath relpath, tmpdir=}"
echo fmt"{absolutePath tmpdir=}"
echo fmt"{expandTilde fossdir=}"
echo fmt"{extractFilename fossdir=}"
echo fmt"need to remove trailing / {extractFilename fossdir[0..^2]=}"
echo fmt"long hair dont care {lastPathPart fossdir=}"
echo fmt"{isAbsolute fossdir=}"
echo fmt"{tmpdir.isRelativeTo getTempDir()=}"
echo fmt"{isRootDir tmpdir=}"
echo fmt"{tmpDir.relativePath fossDir.expandTilde=}"
echo fmt"like js lastIndexOf {searchExtPos readme=}"
echo fmt"{splitPath fossdir=}"
echo fmt"{splitPath fossdir[0..^2]=}"
echo fmt"{unixToNativePath fossdir=}"


echo fmt"""{cmpPaths "pAtH", "PaTh"=}"""
echo fmt"""{"concat/thisDir/notthisone" /../ "with/this/dir"=}"""
echo fmt"""{"concat" /../ "with/this/dir"=}"""
echo fmt"""{"join" / "multiple" / "paths"=}"""
echo fmt"""{joinPath "one/three", "../two", "three"=}"""
echo fmt"""{normalizedPath "//p//o/oo/p//.//./"=}"""
echo fmt"""{normalizePathEnd "//p//o/oo/p//.//./"=}"""


echo "############################ os dirs"
# parentDir()
# copyDir src, dest
# moveDir src, dest
# setCurrentDir tothis
# walkDirs walkDir but accepts a pattern
# walkPattern walkDirs + walkFiles

echo fmt"{getCurrentDir()=}"
echo fmt"{getCacheDir()=}"
echo fmt"{getConfigDir()=}"
echo fmt"{getTempDir()=}"
echo fmt"i.e. expandTilde ~ {getHomeDir()=}"
echo fmt"shifts path {tailDir fossdir=}"

echo fmt"{fossdir.parentDirs.toSeq=}"
echo fmt"{parentDirs(fossdir, true).toSeq=}"

for dir in [tmpdir, dirtmp]: createDir dir; echo fmt"{dir} {dirExists dir=}"; removeDir dir

let hiddenFiles = collect:
  for k in getHomeDir().walkDir:
    if k.path.isHidden: k.path.lastPathPart
echo fmt"filtered collect getHomeDir().walkdir {hiddenFiles=}"

i = 0
let hiddenFilesRec = collect:
  for v in getHomeDir().walkDirRec:
    if i > 10: break else: i += 1
    if v.isHidden: v.lastPathPart
echo fmt"filtered collect getHomeDir().walkdirRec {hiddenFilesRec=}"

echo "############################ os files"
# copyFile src, dest, options
# copyFileToDir src, dest, options
# removeFile
# tryRemoveFile
# setLastModificationTime fname, times
# walkFiles walkDir but accepts a pattern

echo fmt"{fileExists getCurrentDir() / somefile.addFileExt md=}"
echo fmt"{addFileExt someFile, md=}"
echo fmt"{addFileExt someFile & $'.' & md, txt=}"
echo fmt"{changeFileExt someFile.addFileExt md, txt=}"
echo fmt"{expandFilename somefile.addFileExt md=}"
echo fmt"{getCreationTime readme=}"
echo fmt"{getLastAccessTime readme=}"
echo fmt"{getLastModificationTime readme=}"
echo fmt"bunch of stuff {getFileInfo readme=}"
echo fmt"bytes {getFileSize readme=}"
echo fmt"{isValidFilename absolutePath readme=}"
echo fmt"{sameFile readme, readme=}"
echo fmt"{sameFileContent readme, readme=}"
echo fmt"{splitFile readme=}"
echo fmt"{readme.absolutePath.splitFile=}"


echo "############################ os permissions/user"
# copyFileWithPermissions src, dest, ignorePermErrs = true, options
# copyDirWithPermissions, source, dest, ignorePermErrs = true
# exclFilePermissions fname, perms
# inclFilePermissions fname, perms
# setFilePermissions fname, perms, followSymlinks = true

echo fmt"{isAdmin()=}"
echo fmt"{getFilePermissions readme=}"

echo "############################ os ram"
# delEnv key

echo fmt"""{getEnv "USER"=}"""
echo fmt"""{existsEnv "woobidedoobide"=}"""
echo fmt"""{getEnv "woobidedoobide", "poop"=}"""
"ENV_PUTTED".putEnv "1"
echo fmt"""ENV_PUTTED.putEnv "1" -> {getEnv "ENV_PUTTED"=}"""

let env = collect:
  ## should probably be a strtabs
  for k,v in envPairs():
    if "poop" notin v and v == $1: {k: v}
echo fmt"filtered collect envPairs() {env=}"

echo "############################ os exec/cmds/process"
# exitStatusLikeShell status
# quoteShell string
# quoteShellPosix string
# quoteShellWindows string
# quoteShellCommand [argX, argY...]
# sleep inMilliseconds
when declared commandLineParams: echo fmt"{commandLineParams()}" else: discard ## \
  ## only returns parameters, not the executable (see getAppFilename)

when declared paramCount:
  ## not defined when generating a dynamic library
  echo fmt"{paramCount()=}"
  echo if paramCount() > 0: fmt"{paramStr 1=}" else: fmt"no params provided to {paramStr 0=}"
else: discard

when defined(linux):
  echo fmt"{osErrorMsg OSErrorCode 0=}"
  echo fmt"{osErrorMsg OSErrorCode 1=}"
  echo fmt"{osErrorMsg OSErrorCode osLastError()=}"


if fmt"tree -L 1 {tmpdir.parentDir} | grep -E [n,m]i[n,m]".execShellCmd != 0: ## \
  ## dunno "tree -P nim" didnt work here or on cmdline, had to use grep
  echo "you dont have tree installed"

if fmt"tree1 {tmpdir.parentDir}".execShellCmd != 0:
  echo "uses sh by default, thus no bash aliases"

echo fmt"{getCurrentPRocessId()=}"
echo fmt"compiled osIo.nim {getAppDir()=}"
echo fmt"compiled osIo.nim {getAppFilename()=}"
echo fmt"nim/nimble at compiletime {getCurrentCompilerExe()=}"

echo fmt"""{findExe "nim"=}"""
