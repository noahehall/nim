## testing
## =======
## [bookmark](https://nim-lang.org/docs/testament.html)


##[
## TLDR
- tests are run with `nimble test`
- test dir should contain
  - a `nim.cfg` with atleast `--path:"../src/"` pointing to the src dir
  - test files are prefixed with `t` e.g. `tsomefile.nim`
- you can override the test command in your $project.nimble file
.. code-block:: Nim
  task test, "Runs the test suite":
    exec "nim r tests/tester"

links
-----
- other
  - [nimscript test file](https://github.com/nim-lang/Nim/blob/devel/tests/test_nimscript.nims)
  - [nimlang tests](https://github.com/nim-lang/Nim/tree/devel/tests)
  - [testament src](https://github.com/nim-lang/Nim/tree/devel/testament)
- high impact
  - [status fuzz testing](https://github.com/status-im/nim-testutils/tree/master/testutils/fuzzing)
  - [testament: preferred testing tool](https://nim-lang.org/docs/testament.html)
  - [profiling and debugging](https://nim-lang.org/blog/2017/10/02/documenting-profiling-and-debugging-nim-code.html)
  - [nimble test docs](https://github.com/nim-lang/nimble#tests)
- niche
  - [dr nim](https://nim-lang.org/docs/drnim.html)
  - [unit tests](https://nim-lang.org/docs/unittest.html)
  - [Z3 proof engine](https://github.com/Z3Prover/z3)

]##
