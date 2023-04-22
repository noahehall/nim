##
## nimble packages, nimscripts, and app cfgs
## =========================================
## bookmark: dunno

##[
## TLDR
- nimble
  - shipped with nim isnt the nimbiest version
  - install a nimbier nimble with `nimble install nimble`
  - is package-level package manager, i.e. pnpm not apt-get
- parallel tasks are described in asyncPar
- nimscript defined here is strictly for app configuration and nimble support
  - check targets/shell.nims for in depth nimscripting

links
-----
- other
  - [configs used by nim](https://github.com/nim-lang/Nim/tree/devel/config)
  - [example config with tasks](https://github.com/kaushalmodi/nim_config/blob/master/config.nims)
  - [nimble repo](https://github.com/nim-lang/nimble)
  - [understanding how nim is built for X may help you do the same](https://nim-lang.org/docs/packaging.html)
- high impact
  - [nimble pkg reference](https://github.com/nim-lang/nimble#nimble-reference)
  - [nims intro](https://nim-lang.org/docs/nims.html)
  - [parse config](https://nim-lang.org/docs/parsecfg.html)
- niche
  - [base object of a lexer](https://nim-lang.org/docs/lexbase.html)

todos
-----
- verify the different app cfg locations
- for some reason (oops) parseCfg is in shell.nims, it should be in this file
- [this file has example of using @if... @end in a cfg file](https://github.com/nim-lang/Nim/blob/devel/lib/pure/asyncdispatch.nim.cfg)

## nimble
- nim package manager

nimble packages
---------------
- a directory with a .nimble file and one/more .nim files
  - the .nimble filename should match the source codes mainFile.nim
  - the .nimble file is executed as nimscript, thus you have full access to nims VM
    - a package should generally define atleast a test task on install
- requires git/mercurial depending on where you're fetching remote packages from
- nimble package versions: `nimble install blah bleh@123`
  - @123 | @>=0.1.2 | @#gitCommitHash | @#head (or any tag)
  - @url

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

package directives
------------------
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

package dir structure
---------------------
.. code-block:: Nim
  ├── LICENSE
  ├── README.md
  ├── foobar.nimble  # The project .nimble file
  ├── foobar.nim     # only put it here if this is the only module
  └── src
      ├── foobar.nims         # cfg specifically for sibling foobar.nim
      ├── foobar.nim          # Imported via `import foobar`
  │   └── foobar              # package module dir
  │   │   ├── utils.nim       # Imported via `import foobar/utils`
  │   │   ├── common.nim      # Imported via `import foobar/common`
          └── private         # consumers cant import private modules
  │   │   │   ├── hidden.nim  # internally you can `import foobar/private/hidden`
  └── tests           # Contains the tests
      ├── config.nims
      ├── tfoo1.nim   # First test
      └── tfoo2.nim   # Second test

creating nimble libraries
-------------------------
- all previous info still stands correct, however pay attention to the following
- libraries arent pre-compiled, thus the directory structure most be obeyed
  - if the library contains a single module, it can be in the root directory next to the .nimble file
  - else create MyPackageName dir and put library files in there
    - consumers can then `import myPackageName / myModuleName`

releasing and publishing packages
---------------------------------
- be sure to compile with nimble and NOT nim
  - nimble adds extra checks, e.g. package dependencies are listed in the .nimble file
- releasing
  - increment the version in .nimble
  - commit changes
  - tag the commit `git tag v1.2.3`
    - this MUST MATCH the version number in step 1, else nimble will refuse to install it
  - git push --tags
- publishing
  - use `nimble publish`
  - or manually clone the [packages](https://github.com/nim-lang/packages) repo and submit a PR


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

## nimscript
- subset of nim that can be evaluated by nims builtin VM

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
