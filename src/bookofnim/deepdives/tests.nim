## testing
## =======
## [bookmark](https://nim-lang.github.io/Nim/testament.html)


##[
## TLDR
- idiomatic nim tests
  - tests dir should contain
    - optional [config.nims](https://github.com/nim-lang/Nim/blob/devel/tests/config.nims)
    .. code-block:: Nim
      # now importing custom modules in your test file will work
      switch("path", "$projectDir/../where/you/keep/your/source/code")
      --path:"$projectDir/../.." # IMO preferred
    - optional [nim.cfg](https://github.com/nim-lang/Nim/blob/devel/tests/arc/nim.cfg)
    - optional file (any name, e.g. skip) with tests to skip (1 per line, `# comments ignored`)
    - subdirs for test categories, e.g. `root/tests/mymodule/\*.nim`
      - test files prefixed with `t` e.g. `tsomefile.nim`

gotchas
-------
- testament
  - dont add leading tabs before discard """ stuff here """ when using output type directives
    - e.g. for formatting; remember """ raw strings keep tabs, thus wont match against output
- valgrind
  - Use --mm:orc -d:useMalloc with Valgrind in order to avoid false positives.

links
-----
- other
  - [nimscript test file](https://github.com/nim-lang/Nim/blob/devel/tests/test_nimscript.nims)
  - [example testament tests](https://github.com/nim-lang/Nim/tree/devel/tests)
  - [testament src](https://github.com/nim-lang/Nim/tree/devel/testament)
- high impact
  - [status fuzz testing](https://github.com/status-im/nim-testutils/tree/master/testutils/fuzzing)
  - [testament: preferred testing tool](https://nim-lang.github.io/Nim/testament.html)
  - [testament: unit test boilerplate](https://nim-lang.github.io/Nim/testament.html#writing-unitests)
  - [profiling and debugging](https://nim-lang.org/blog/2017/10/02/documenting-profiling-and-debugging-nim-code.html)
  - [nimble test docs](https://github.com/nim-lang/nimble#tests)
  - [valgrind dynamic analysis toolset](https://valgrind.org/)
- niche
  - [dr nim](https://nim-lang.github.io/Nim/drnim.html)
  - [unit tests (prefer testament)](https://nim-lang.github.io/Nim/unittest.html)
  - [Z3 proof engine](https://github.com/Z3Prover/z3)


## testament
- advanced automatic unittest runner with support for:
  - process isolation
  - test case stats & html reports
  - cross-compile support
  - dry runs & logging
  - etc
- you can `apt install valgrind` to check for mem leaks in test

testament html reports
----------------------
- first run some tests to generate test data for the parser
- then create html reports with `testament html`

testament running tests
-----------------------
- you can target all, individual, categories or globs of test files
.. code-block:: Nim
  testament all
  testament run somefile
  testament pattern "tests/**/**/*.nim"

testament writing tests
-----------------------
- a single test consists of two sections
  - test specs (optional): as defined by [this file](https://github.com/nim-lang/Nim/blob/devel/testament/specs.nim)
    - type TSpec and proc parseSpec determine fields and validation rules, respectively
      - focus on parseSpec as it massages spec keys into Tspec fields
  - test code (required): just normal nim code!
    - test lifecycle: parse spec -> validate spec > execute code against spec
    - the default is to fail a test if any error is thrown
      - however you can change this behavior, e.g.
        - "compile" only | "run" and compile | "reject" tests that dont throw expected errors
        - reject test if stdout fails sparsely match with expected stdout
  - examples that reflect specs & code
    - [unittests examples](https://nim-lang.github.io/Nim/testament.html#unitests-examples)
    - expected output with tests grouped in blocks [tarray](https://github.com/nim-lang/Nim/blob/devel/tests/array/tarray.nim)
    - expected errors [inline with the code](https://github.com/nim-lang/Nim/blob/9a110047cbe2826b1d4afe63e3a1f5a08422b73f/tests/effects/teffects1.nim)
    - expected errors [based on exit code + output substitution](https://github.com/nim-lang/Nim/blob/devel/tests/assert/tassert.nim)
    - expected errors [based on errormsg thrown on specific line in specific file](https://github.com/nim-lang/Nim/blob/devel/tests/misc/tnot.nim)
    - successful execution [without a spec section](https://github.com/nim-lang/Nim/blob/devel/tests/alias/talias.nim)
    - successful [compilation](https://github.com/nim-lang/Nim/blob/devel/tests/alias/t19349.nim)
    - tracking [regressions](https://github.com/nim-lang/Nim/tree/devel/tests/ccgbugs)
    - async [http servers](https://github.com/nim-lang/Nim/blob/devel/tests/async/tasyncawait.nim)
    - async [file read/write](https://github.com/nim-lang/Nim/blob/devel/tests/async/tasyncfile.nim)
    - [multitasking](https://github.com/nim-lang/Nim/blob/devel/tests/parallel/tblocking_channel.nim)
    - targeting specific [os/architectures](https://github.com/nim-lang/Nim/blob/devel/tests/distros/tdistros_detect.nim)
    - targeting specific [backends, e.g. javascript](https://github.com/nim-lang/Nim/tree/devel/tests/js)
      - [simpler javascript example](https://github.com/nim-lang/Nim/blob/devel/tests/js.nim)
    - [benchmarking](https://github.com/nim-lang/Nim/blob/devel/tests/benchmarks/ttls.nim)

testament options
-----------------
- --print results to console
- --simulate dry runs
- --failing log only
- --targets "c cpp js objc"
- --nim:/some/path
- --directory:/initial/dir
- --colors:on/off
- --backendLogging:on/off
- --skipFrom:/some/file # throws if file not found

testament env vars
------------------
- NIM_TESTAMENT_BATCH runs batchable tests together

testament specs
---------------
- FYI
  - if file|line|column is specified, either msg | errormsg | nimout (if line)
    - set to a non empty value
    - appear before file option
  - if exitcode is set forces action == run
  - if errormsg is set forces action == reject
  - can use config.nims/nim.cfg instead of cmd if only changing nimc flags
    - cmd is required for nimscripts; e.g. `cmd: "nim e --hints:on -d:testing $options $file"`
- action sets test validation to compile | (compile &) run | reject
- batchable can run in batch mode; i.e. all tests with the same dependency set can be batched
- column @see FYI section
- disabled if true | OS/ARCH matches this string; can be specified multiple times
  - win | linux | bsd | osx | unix
  - littlendian | bigendian |
  - cpu8/16/32/64
  - travis | appveyor | azure
  - any OS/CPU value defined in compiler/platform
- errormsg: expected in stdout
- exitcode: test should return
- ccodecheck can be passed multiple times
- cmd default `nim $target --hints:on -d:testing --nimblePath:build/deps/pkgs $options $file`
- file that will stderr/out a msg | errormsg | nimout; @see FYI section
- input: stdinput for test
- joinable: will be run with other tests
- line in `file` that will stderr/out the string set in error(msg) options; @see FYI section
- matrix of ; delimited switches each being a group of test scenarios
- maxcodesize test permitted to compile to
- nimout '''multi line output''' each line sparsely matched against COMPILER (not test!!) output
- nimoutFull nimout is the full output or a subset
- output test prints to stdout for validation <--- likely what you want for testing test output
- outputsub test prints that must be included in the full stdout
- sortoutput before validating against stdout
- targets default "c" accepts space separated backends
- timeout in seconds after which test considered failed
- valgrind is in path and should check for memory leaks

## nimble tests
- nimble can be used for running tests via tasks
- you can override the standard test command in your $project.nimble file
.. code-block:: Nim
  task test, "Runs the test suite":
    exec "nim r tests/tester"

## unittests
- the nim std library comes with its own unit test framework
  - unittests provides a [familiar test interface](https://github.com/dom96/prometheus/blob/master/tests/tcounter.nim)
- however, testament is preferred so we'll be skipping std/unittest

]##
