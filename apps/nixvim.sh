#!/usr/bin/env bash

INIT="$(grep "^init=" "$(which nixvim-print-init)" | cut -d = -f 2)"
nvim --clean -u "$INIT" -s - "$@" <<<":set spelllang="
