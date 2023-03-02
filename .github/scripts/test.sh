#!/usr/bin/env bash

# FYI: you should prefer executing CI tasks with nim
# @see test.nims as example

set -ex

testament=~/.nimble/bin/testament

install_deps() {
  sudo apt-fast -y install \
    valgrind
}

install_deps
testament all
