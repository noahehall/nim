##
## nimble packages, nimscripts, and app cfgs
## =========================================
## [bookmark](https://github.com/nim-lang/nimble#configuration)

##[
## TLDR
- nimble
  - nimble shipped with nim isnt the nimbiest version
    - install a nimbier nimble with `nimble install nimble`
  - nimble commands [are described here](https://github.com/noahehall/theBookOfNoah/blob/master/linux/bash_cli_fns/nimlang.sh) to reduce duplication

links
-----
- other
  - [shell script with useful nimble functions](https://github.com/noahehall/theBookOfNoah/blob/master/linux/bash_cli_fns/nimlang.sh)
  - [example config with tasks](https://github.com/kaushalmodi/nim_config/blob/master/config.nims)
  - [nimble repo](https://github.com/nim-lang/nimble)
  - [example nimscript script](https://github.com/noahehall/nim/blob/develop/backends/shell.nim)
- high impact
  - [nimble cmds](https://github.com/nim-lang/nimble#nimble-usage)
  - [nimble configuration](https://github.com/nim-lang/nimble#configuration)
  - [nims intro](https://nim-lang.org/docs/nims.html)
  - [nimscript spec (including tasks)](https://nim-lang.org/docs/nimscript.html)
  - [parallel tasks](https://nim-lang.org/docs/tasks.html)
  - [parse config](https://nim-lang.org/docs/parsecfg.html)

todos
-----
- dunno yet

## nimble
- subset of nim that can be evaluated by nims builtin VM

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
- by default nimble uses git repos as its primary source for packages
  - [the list of available packages](https://github.com/nim-lang/packages)
- each package contains a .nimble file with install & build directives
  - the .nimble file should have the same name as the package
  - its interpreted using nimscript and supports any nim vm compatible features
    - e.g. tasks can be used to define nimble package-specific commands
.. code-block:: Nim
    # package
    version = "1.2.3"
    author = "rohtua"
    description = "6 pack of ramen"
    license = "TO KILL"

    # deps
    # ^= latest compatible semver
    # ~= latest version by increasing the last digit to highest version
    requires "nim >= 1.6.10", "sim ^= 10.6.1"
    requires "dim ~= 6.1.10"
    requires "https://github.com/user/pkg#abcd"

    # tasks: see deepdives/asyncParMem for task spec
    # run via nimble woopwoop
    task woopwoop, "w00p w00p task":
      echo "w00p w00p"

## nimscript

nimscript limitations
---------------------
- any stdlib module relying on `importc` pragma cant be used
- ptr operations are tested, but may have bugs
- var T args (rely on ptr operations) thus may have bugs too
- multimethods not available
- random.randomize() requires an int64 as a seed

nimscript as build tool
-----------------------
- you have to read through docs/task as well as system/tasks
- default provides: help, build, tests, and bench cmds

nimscript for configs
---------------------
- nim will automatically process .nims configs in the following order (later overrides previous)
.. code-block:: Nim
  $XDG_CONFIG_HOME/nim/config.nims or ~/config/nim/config.nims
  $parentDir/config.nims # think this might be $parentDir/config/*.nims
  $projectDir/config.nims
  $project.nims

- you can set switches via 2 syntax
.. code-block:: Nim
  switch("opt", "size")
  hint(name, bool)
  warning(name,bool)
  --opt:size # IMO this is the cleaner syntax


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
]##
