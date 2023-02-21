##
## os and i/o
## ==========
## [bookmark](https://nim-lang.org/docs/os.html#fileExists%2Cstring)

##[
## TLDR
- generally you should check when defined(posix/etc)
  - posix
    - filepaths are case sensitive
    - dest paths inherit [user default perms](https://www.baeldung.com/linux/new-files-dirs-default-permission)
    - dir symlinks copied as symlinks to dest
    - file symlinks are followed (by default) then copied to dest
    - permissions copied after file/dir is copied and could lead to race conditions
  - windows
    - filepaths are case insensitive
    - dest paths inherit source paths attributes
    - dir & file symlinks are skipped
    - require evelated privs for sym/hardlinks
  - OSX

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
]##

import std/[sugar, strformat, strutils, sequtils]

echo "############################ os"

import std/os

const
  tmpdir = "/tmp/nim"
  dirtmp = "/tmp/min"
  fossdir = "~/git/foss"
  dotpath = "./par/sibl/nephew"
  relpath = "par/sibl/niece"
  somefile = "README"
  md = "md"
  txt = "txt"

#
# paths, files n dirs
#
# parentDir()
# expandFilename fname
# expandSymlink
echo fmt"{getCurrentDir()=}"
echo fmt"{absolutePath dotpath=}"
echo fmt"{absolutePath relpath, tmpdir=}"
echo fmt"{absolutePath tmpdir=}"
echo fmt"{addFileExt someFile, md=}"
echo fmt"{addFileExt someFile & $'.' & md, txt=}"
echo fmt"{changeFileExt someFile & $'.' & md, txt=}"
echo fmt"{expandTilde fossdir=}"
echo fmt"{extractFilename fossdir=}"

echo fmt"""posix is case sensitive {cmpPaths "pAtH", "PaTh"=}"""
echo fmt"""{"concat/thisDir/notthisone" /../ "with/this/dir"=}"""
echo fmt"""{"concat" /../ "with/this/dir"=}"""
echo fmt"""{"join" / "multiple" / "paths"=}"""

for dir in [tmpdir, dirtmp]:
  createDir dir
  echo fmt"{dir} {dirExists dir=}"

# copyDir src, dest
# copyFile src, dest, options
# copyFileToDir src, dest, options
# createHardLink src, dest
# createSymlink

#
# permissions
#
# copyFileWithPermissions src, dest, ignorePermErrs = true, options
# copyDirWithPermissions, source, dest, ignorePermErrs = true
# exclFilePermissions fname, permissions

#
# ram
#
# delEnv key
# existsEnv key

#
# cmdline
#
# exitStatusLikeShell status

when declared(commandLineParams):
  ## only returns parameters, not the executable (see getAppFilename)
  echo fmt"{commandLineParams()}"
else: discard

if fmt"tree {tmpdir.parentDir}".execShellCmd != 0:
  echo "you dont have tree installed"

if fmt"tree1 {tmpdir.parentDir}".execShellCmd != 0:
  echo "uses sh by default, thus no bash aliases"
