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
    latexmk -pdf -cd "-outdir=$PWD/build" "$1"
  }

  function nixos-diff() {
    git -C ~/.config/nixos fetch
    git -C ~/.config/nixos diff "$(nixos-version --configuration-revision)"...origin
  }

  function nixos-iso() {
    nix build ~/.config/nixos#nixosConfigurations.installer.config.system.build.isoImage
    cp result/iso/*.iso nixos.iso
    rm result
  }

  function nixos-secrets() {
    sudo GNUPGHOME=/etc/nixos/.gnupg sops ~/.config/nixos/resources/secrets/${1:-desktop}/store.yaml
  }

  function nixos-test() {
    nixos-rebuild --sudo --impure --flake ~/.config/nixos "${1:-test}"
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
  function nixos-upgrade() {
    nixos-rebuild --sudo --impure --flake github:pascaldiehm/nixos "${1:-switch}"
  }

  function service() {
    if [ "$#" = 0 ]; then
      docker compose ls
    else
      docker compose --file "/home/pascal/docker/$NIXOS_MACHINE_NAME/$1/compose.yaml" "${@:2}"
    fi
  }
fi
