##
## os, i/o (V2)
## ============


##[
## TLDR
- come back later

links
-----
- [appdirs](https://github.com/nim-lang/Nim/blob/devel/lib/std/appdirs.nim)
- [cmdline](https://github.com/nim-lang/Nim/blob/devel/lib/std/cmdline.nim)
- [dirs](https://github.com/nim-lang/Nim/blob/devel/lib/std/dirs.nim)
- [envvars](https://github.com/nim-lang/Nim/blob/devel/lib/std/envvars.nim)
- [files](https://github.com/nim-lang/Nim/blob/devel/lib/std/files.nim)
- [paths](https://github.com/nim-lang/Nim/blob/devel/lib/std/paths.nim)
- [symlinks](https://github.com/nim-lang/Nim/blob/devel/lib/std/symlinks.nim)
- [sync io](https://github.com/nim-lang/Nim/blob/devel/lib/std/syncio.nim)


TODOs
-----
- see if system/io was just moved to std/syncio

]##

{.push warning[UnusedImport]:off .}

import std/[
  appdirs,
  cmdline,
  dirs,
  envvars,
  files,
  paths,
  symlinks,
  syncIo
]

echo "osIo v2!"
