#!/usr/bin/env zsh

function mkcd() {
  mkdir -p "$1"
  cd "$1"
}

function watch() (
  trap "tput cnorm; tput rmcup" EXIT
  trap "return 0" INT

  tput smcup
  tput civis

  while clear; do
    echo -e "\e[90mWatching: $*\e[m\n"
    eval "$*"

    sleep 1
  done
)

if [ "$NIXOS_MACHINE_TYPE" = "desktop" ]; then
  function mktex() {
    latexmk -pdf -cd -outdir="$PWD/build" "$1"
  }

  function nv() {
    if [ "$#" = 0 ]; then
      nvim
    elif [ -f "$1" ]; then
      nvim "$1"
    elif [ -d "$1" ]; then
      pushd "$1"
      nvim .
      popd
    else
      mkdir -p "$(dirname "$1")"
      nvim "$1"
    fi
  }
elif [ "$NIXOS_MACHINE_TYPE" = "server" ]; then
  function service() {
    if [ "$#" = 0 ]; then
      docker compose ls
    else
      docker compose --file "/home/pascal/docker/$NIXOS_MACHINE_NAME/$1/compose.yaml" "${@:2}"
    fi
  }
fi
