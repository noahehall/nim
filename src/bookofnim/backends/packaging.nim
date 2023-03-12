##
## nimble packages, nimscripts, and app cfgs
## =========================================
## bookmark: dunno

##[
## TLDR
- nimble shipped with nim isnt the nimbiest version
  - install a nimbier nimble with `nimble install nimble`
- parallel tasks are described in asyncPar
- for some reason (oops) parseCfg is in shell.nims
  - TODO: even tho you cant use parseCfg in a nimscript (put example here)

links
-----
- other
  - [configs used by nim](https://github.com/nim-lang/Nim/tree/devel/config)
  - [example config with tasks](https://github.com/kaushalmodi/nim_config/blob/master/config.nims)
  - [example nimscript script](https://github.com/noahehall/nim/blob/develop/src/bookofnim/backends/targets/shell.nims)
  - [nimble repo](https://github.com/nim-lang/nimble)
  - [understanding how nim is built for X may help you do the same](https://nim-lang.org/docs/packaging.html)
  - peter:
      - [nimscript part 1](https://peterme.net/using-nimscript-as-a-configuration-language-embedding-nimscript-pt-1.html)
      - [nimscript part 2](https://peterme.net/how-to-embed-nimscript-into-a-nim-program-embedding-nimscript-pt-2.html)
      - [nimscript part 3](https://peterme.net/creating-condensed-shared-libraries-embedding-nimscript-pt-3.html)
- high impact
  - [nimble pkg reference](https://github.com/nim-lang/nimble#nimble-reference)
  - [nims intro](https://nim-lang.org/docs/nims.html)
  - [nimscript compatibility tests](https://github.com/nim-lang/Nim/blob/devel/tests/test_nimscript.nims)
  - [nimscript spec (including tasks)](https://nim-lang.org/docs/nimscript.html)
  - [parse config](https://nim-lang.org/docs/parsecfg.html)
- niche
  - [base object of a lexer](https://nim-lang.org/docs/lexbase.html)

todos
-----
- verify the different app cfg locations

## nimble
- nim package manager

nimble configuration
--------------------
- posix: ~/.config/nimble/nimble.ini
- windows: Users\someuser\AppData\Roaming\nimble\nimble.ini
.. code-block:: Nim
    # where to install pkgs
    nimbleDir = r"~/nimble/"

    # if true will add chcp 65001 to .cmd stubs generated in ~/.nimble/bin/
    chcp = true

    # specify new custom package list(s)
    # over default with one named "Official"
    # multiple path/urls can be specified per name
    [PackageList]
    name = "My local list"
    path/url = r"/any/path/or/url"
    cloneUsingHttps = true  # replace git:// with https://
    httpProxy = ""

creating nimble packages
------------------------
- by default nimble uses [git repos](https://github.com/nim-lang/packages) as its primary source for packages
- each package contains a .nimble file with install & build directives
  - [check nimble api src for all .nimble options](https://github.com/nim-lang/nimble/blob/master/src/nimblepkg/nimscriptapi.nim)
  - the .nimble file should (but not required to) have the same name as the package
  - its interpreted using nimscript and supports any nim vm compatible features
    - e.g. tasks can be used to define nimble package-specific commands
- packages install dirs
  - libraries: copied to `$nimbleDir/pkgs2/pkgname-ver-checksum`
  - binaries: compile -> copy to library dir > symlink to `$nimbleDir/bin`
.. code-block:: Nim
    # package metadata
    packageName = "if different from $project"
    version = "1.2.3"
    author = "rohtua"
    description = "6 pack of ramen"
    license = "TO KILL"

    # package directives
    # skipDirs, skipFiles, skipExt          <-- deny list: will never be installed
    # installDirs, installFiles, installExt <-- allow list: will only be installed
    installExt = @["nim"] # required if your pkg is both a library & binary
    srcDir = "./src"
    binDir = "./bin"
    backend = "c"
    namedBin["main"] = "mymain" # rename binary
    namedBin = {"main": "mymain", "main2": "other-main"}.toTable() # rename binaries

    # package dependencies
    # ^= latest compatible semver
    # ~= latest version by increasing the last digit to highest version
    requires "nim >= 1.6.10", "sim ^= 10.6.1"
    requires "dim ~= 6.1.10"
    requires "wim > 0.1 & <= 0.5"
    requires "lim#head" # the latest commit
    requires "pim == 1.2.3" # not recommended; as transient deps could rely on a diff ver
    requires "https://github.com/user/pkg#abcd"

    # foreign deps: not managed by nimble, e.g. openssl
    when defined(nimdistros):
      import distros
      if detectOs(Ubuntu):
        foreignDep "libssl-dev"
      else:
        foreignDep "openssl"

    # package tasks: list a pkgs tasks via `nimble tasks`
    # see task section below

package dir structure
---------------------
.. code-block:: Nim
  .                           # The root directory of the project
  ├── LICENSE
  ├── README.md
  ├── foobar.nimble           # The project .nimble file
  └── src
      ├── foobar.nim          # Imported via `import foobar`
  │   └── foobar              # package module dir
  │   │   ├── utils.nim       # Imported via `import foobar/utils`
  │   │   ├── common.nim      # Imported via `import foobar/common`
          └── private         # package internal modules
  │   │   │   ├── hidden.nim  # Imported via `import foobar/private/hidden`
  └── tests           # Contains the tests
      ├── config.nims
      ├── tfoo1.nim   # First test
      └── tfoo2.nim   # Second test

releasing and publishing packages
---------------------------------
- releasing
  - increment the version in .nimble
  - commit changes
  - `git tag v1.2.3`
  - push your tags
- publishing
  - use `nimble publish`
  - or manually clone the [packages](https://github.com/nim-lang/packages) repo and submit a PR

## nimscript
- subset of nim that can be evaluated by nims builtin VM
- [runnable example](https://github.com/noahehall/nim/blob/develop/src/bookofnim/backends/targets/shell.nims)

nimscript limitations
---------------------
- not available
  - any stdlib module relying on `importc` pragma
  - multimethods
- works but not 100% tested
  - ptr operations
  - var T args (rely on ptr operations)
- nimscript vs nim
  - random.randomize() requires an int64 as a seed


nimscript for app configuration
-------------------------------
- nim will automatically process .nims configs in the following order (later overrides previous)
.. code-block:: Nim
  $XDG_CONFIG_HOME/nim/config.nims || ~/config/nim/config.nims
  $parentDir/config.nims
  $projectDir/config.nims
  $project.nims

- syntax for setting switches has 2 forms
.. code-block:: Nim
  switch("opt", "size") || hint(name, bool) || warning(name, bool)
  --opt:size # IMO the cleaner syntax


nimscript for scripting
-----------------------
- The syntax, style, etc is identical to compiled nim
- supports templates, macros, types, concepts, effect tracking system, etc
- std and third party pkgs can work in both .nim and .nims (see limitations)
- a nims file is its own config file, but you can rely on the other types
- shebang has two formats
.. code-block:: Nim
    # without switches
    #!/usr/bin/env nim

    # with switches
    #!/usr/bin/env -S nim --hints:off

nimscript nimble integration
----------------------------
- author
- backend
- bin
- binDir
- description
- installDirs
- installExt
- installFiles
- license
- packageName
- skipDirs
- skipExt
- skipFiles
- srcDir
- version
- requires(varargs[string])

nimscript types
---------------
- ScriptMode enum
  - Silent bool
  - Verbose bool echos cmd before execution
  - Whatif bool echos cmds without execution

nimscript vars
--------------
- mode ScriptMode runtime behavior
- requiresData seq[string] for read/write access

nimscript procs
---------------
- cppDefine(string) is a C preprocessor #define and needs to be mangled
- patchFile(pkg, thisFile, withThisFile) overrides location of a file belonging to pkg
- readAllFromStdin() read all data from stdin; blocks until EOF event (stdin closed)
- readLineFromStdin() read a line from stdin; blocks until EOF event (stdin closed)
- toDll(fname) posix adds lib$fname.so, windows appends .dll to fname
- toExe(fname) posix returns fname unmodified, windows appends .exe
- cpFile from, to
- mvFile
- setCommand that Nim should continue execution with
- getCommand that Nim is currently using to execute
- switch(x, y) nim compiler switch, IMO prefer --x:y

nimscript tasks
---------------
- a template which creates a proc named blahTask
- useful for package build scripts, shell scripts, devops actions, and integration with nimble
  - tasks have before and after lifecycle hooks within .nimble files
  - you have the power of nim wherever you would use a shell script
- default tasks: help, build, tests, and bench cmds

## parsecfg
- high performance config parser in windows ini syntax
  - fully supported in .nim files
  - semi supported in .nims and .nimble files
- supports string literals, raw and triple quoted nim strings

parsecfg types
--------------
- CfgEvent object describing the parsing event
  - kind enum CfgEventKind the type of line being parsed
    - cfgSectionStart the start of config section
      - section returns [name]
    - cfgKeyValuePair in the form key=value
      - key
      - value
    - cfgOption in the form --key=value
      - key
      - value
    - cfgError failed to parse
      - msg reason
    - cfgEof end of file
- CfgParser object BaseLexor
- Config OrderedTableRef

parsecfg procs
--------------
- delSectionKey from in in a specific/empty str section
- getSectionValue from a key in a specific/empty str section
- loadConfig from a path
- newConfig() dictionary
- setSectionKey set key & value in a specific/empty str section
- writeConfig to a path
- close parser and its associated stream
- delSection and all associated keys
- errorStr of error event with line and column
]##
