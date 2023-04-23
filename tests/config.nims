# copypasta from nim @see https://github.com/nim-lang/Nim/blob/devel/tests/config.nims
## prevent common user config settings to interfere with testament expectations
## Indifidual tests can override this if needed to test for these options.
switch("colors", "off")

switch("excessiveStackTrace", "off")

when (NimMajor, NimMinor, NimPatch) >= (1,5,1):
  # to make it easier to test against older nim versions, (best effort only)
  switch("filenames", "legacyRelProj")
  switch("spellSuggest", "0")

hint("Processing", off)
  # dots can cause annoyances; instead, a single test can test `hintProcessing`

# uncomment to enable all flaky tests disabled by this flag
# (works through process calls, e.g. tests that invoke nim).
# switch("define", "nimTestsEnableFlaky")

# switch("hint", "ConvFromXtoItselfNotNeeded")
# switch("warningAsError", "InheritFromException") # would require fixing a few tests

# experimental APIs are enabled in testament, refs https://github.com/timotheecour/Nim/issues/575
# sync with `kochdocs.docDefines` or refactor.
switch("define", "nimExperimentalAsyncjsThen")
switch("define", "nimExperimentalLinenoiseExtra")

# preview APIs are expected to be the new default in upcoming versions
switch("define", "nimPreviewFloatRoundtrip")
switch("define", "nimPreviewDotLikeOps")
switch("define", "nimPreviewJsonutilsHoleyEnum")
switch("define", "nimPreviewHashRef")
when defined(windows):
  switch("tlsEmulation", "off")

# internal
switch("putenv", "TEST=1")
