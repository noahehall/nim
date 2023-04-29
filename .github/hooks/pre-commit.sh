#!/usr/bin/env bash

set -euo pipefail

export CI=true

echo $"removing test cache"

# rm test cache files and previous artifacts
# TODO: add this logic to the scripts/test.nims so all tests rm cached files

# testament cache files dont have an extension
find ./tests -type f ! -name '*.*' -delete
# known cache locations
rm -rf nimcache/*
rm -rf testresults/*
rm -f tests/megatest.nim
rm -f outputGotton.txt

echo $"executing nim tests"

# TODO: this leaves a dangling file because test.nims outputs testresults.html
# ^ but pre-commit only considers staged files
nim e .github/scripts/test.nims |
  while IFS= read -r line; do
    echo $line
  done
