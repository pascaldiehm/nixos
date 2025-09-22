#!/usr/bin/env bash

TMP="$(mktemp --suffix .lua)"
nixvim-print-init | grep -v spelllang >"$TMP"

nvim --clean -u "$TMP" "$@"
rm "$TMP"
