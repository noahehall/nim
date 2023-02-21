##
## os and i/o
## ==========
## [bookmark](https://nim-lang.org/docs/os.html#normalizeExe%2Cstring)

##[
## TLDR
- if a proc accepts a filename (string), it likely accepts a File/Filehandle
- generally you should check when defined(posix/etc)
  - posix
    - admin: root
    - cachedir: XDG_CACHE_HOME | HOME / .cache [/ app] (etc for other dir types)
    - dest paths inherit [user default perms](https://www.baeldung.com/linux/new-files-dirs-default-permission)
    - dir symlinks copied as symlinks to dest
    - file creation time may actually be last modified time
    - file symlinks are followed (by default) then copied to dest
    - path considered hidden if prefixed with '.'{1}
    - paths are case sensitive
    - permissions copied after file/dir is copied and could lead to race conditions
    - tempdir: TMPDIR | TEMP | TMP | TEMPDIR
  - windows
    - admin: admin local group
    - cachedir: LOCALAPPDATA [/ app / cache] (etc for other dir types)
    - dest paths inherit source paths attributes
    - dir & file symlinks are skipped
    - network paths are considered absolute
    - path considered hidden if file existsw and hidden attribute set
    - paths are case insensitive
    - require evelated privs for sym/hardlinks
    - tempdir: calls windows GetTempPath
  - OSX
    - cachedir: XDG_CACHE_HOME | HOME / .cache [/app] (etc for other dir types)

links
- high impact
  - [basic os utils](https://nim-lang.org/docs/os.html)
  - [distro detection & os pkg manager](https://nim-lang.org/docs/distros.html)
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

skipped
- os
  - DynlibFormat, ExeExt[s], ScriptExt


## os exceptions
- OSError e.g. file not found, incorrect perms
- newOsError errorCode determines the msg as retrieved by osErrorMsg, get error code via osLastError

## os types
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

## os consts
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

## os procs
- copyFile dest parentDir must exist; overwrites but preserves perms
- execShellCmd blocks until finished
- createDir mkdir -p
- existsOrCreateDir mkdir
- moveDir doesnt follow symlinks, thus symlinks are moved and not their target
- moveFile (see moveDir) + can be used to rename files
- normalizePath (no d) modifies string inplace
]##

import std/[sugar, strformat, strutils, sequtils]

echo "############################ os"

import std/os

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


echo fmt"""{cmpPaths "pAtH", "PaTh"=}"""
echo fmt"""normalizes (not concats) {"concat/thisDir/notthisone" /../ "with/this/dir"=}"""
echo fmt"""{"concat" /../ "with/this/dir"=}"""
echo fmt"""normalizes (not joins) {"join" / "multiple" / "paths"=}"""
echo fmt"""{joinPath "one/three", "../two", "three"=}"""
echo fmt"""{normalizedPath "//p//o/oo/p"=}"""
echo "############################ os dirs"
# parentDir()
# copyDir src, dest
# moveDir src, dest
echo fmt"{getCurrentDir()=}"
echo fmt"{getCacheDir()=}"
echo fmt"{getConfigDir()=}"
echo fmt"{getTempDir()=}"
echo fmt"i.e. expandTilde ~ {getHomeDir()=}"


for dir in [tmpdir, dirtmp]: createDir dir; echo fmt"{dir} {dirExists dir=}"


echo "############################ os files"
# copyFile src, dest, options
# copyFileToDir src, dest, options

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


echo "############################ os permissions/user"
# ignorePermErrs is technically ignorePermissionErrors
# perms is technically permissions

echo fmt"{isAdmin()=}"
echo fmt"{getFilePermissions readme=}"
# copyFileWithPermissions src, dest, ignorePermErrs = true, options
# copyDirWithPermissions, source, dest, ignorePermErrs = true
# exclFilePermissions fname, perms
# inclFilePermissions fname, perms

echo "############################ os ram"
# delEnv key

echo fmt"""{getEnv "USER"=}"""
echo fmt"""{existsEnv "woobidedoobide"=}"""
echo fmt"""{getEnv "woobidedoobide", "poop"=}"""


echo "############################ os exec/cmds/process"
# exitStatusLikeShell status

when declared(commandLineParams):
  ## only returns parameters, not the executable (see getAppFilename)
  echo fmt"{commandLineParams()}"
else: discard

# dunno "tree -P nim" didnt work here or on cmdline, had to use grep
if fmt"tree -L 1 {tmpdir.parentDir} | grep -E [n,m]i[n,m]".execShellCmd != 0:
  echo "you dont have tree installed"

if fmt"tree1 {tmpdir.parentDir}".execShellCmd != 0:
  echo "uses sh by default, thus no bash aliases"

echo fmt"{getCurrentPRocessId()=}"

echo fmt"compiled osIo.nim {getAppDir()=}"
echo fmt"compiled osIo.nim {getAppFilename()=}"
echo fmt"nim/nimble at compiletime {getCurrentCompilerExe()=}"

echo fmt"""{findExe "nim"=}"""
