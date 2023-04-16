#!/usr/bin/env bash

# FYI: this file is deprecated
# all CI tasks should use nimscript

set -ex

testament=~/.nimble/bin/testament

install_deps() {
  sudo apt-fast -y install \
    valgrind
}

install_deps
testament all
