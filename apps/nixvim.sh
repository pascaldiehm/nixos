#!/usr/bin/env bash

INIT="$(mktemp --suffix .lua)"
trap 'rm $INIT' EXIT

nixvim-print-init | grep -v spelllang >"$INIT"
nvim --clean -u "$INIT" "$@"
