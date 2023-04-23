# copypasta from nim @see https://github.com/nim-lang/Nim/blob/devel/tests/config.nims
## prevent common user config settings to interfere with testament expectations
## Indifidual tests can override this if needed to test for these options.
switch("colors", "off")
switch("excessiveStackTrace", "off")

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
switch("putenv", "TEST=1") # dont set ENV=TEST, e.g. to run tests against PERF
switch("assertions", "on")
switch("stackTraceMsgs", "on")
switch("verbosity", "3")
