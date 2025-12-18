#!/usr/bin/env bash

function help() {
  echo "Usage: nx <command> [args...]"
  echo
  echo "Commands:"
  echo "  help                 Show this help"
  echo "  test                 Test configuration"
  echo "  upgrade [mode]       Upgrade machine"
  echo "  list                 List generations"
  echo "  reset <gen> [mode]   Reset to previous generation"
  echo "  repl [host]          Start repl with configuration"
  echo "  secrets [type]       Edit secrets"
  echo "  iso                  Build ISO image"
}

if [ "$#" = 0 ]; then
  help
  exit 1
elif [ "$1" = "help" ]; then
  if [ "$#" != 1 ]; then
    echo "Usage: nx help"
    exit 1
  fi

  help
elif [ "$1" = "test" ]; then
  if [ "$#" != 1 ]; then
    echo "Usage: nx test"
    exit 1
  fi

  nixos-rebuild --sudo --impure --flake ~/.config/nixos test
elif [ "$1" = "upgrade" ]; then
  if [ "$#" -gt 2 ]; then
    echo "Usage: nx upgrade [mode]"
    echo
    echo "mode   Upgrade mode"

    exit 1
  fi

  sudo --validate
  while true; do
    trap 'kill -- -"$$"' EXIT
    sleep 250
    sudo --validate
  done &

  SUDO_LOOP_PID="$!"
  trap 'kill "$SUDO_LOOP_PID"' EXIT

  nixos-rebuild --sudo --impure --flake github:pascaldiehm/nixos "${2:-boot}"
elif [ "$1" = "list" ]; then
  if [ "$#" != 1 ]; then
    echo "Usage: nx list"
    exit 1
  fi

  nixos-rebuild list-generations
elif [ "$1" = "reset" ]; then
  if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
    echo "Usage: nx reset <gen> [mode]"
    echo
    echo "gen    Generation ID"
    echo "mode   Upgrade mode"
    exit 1
  fi

  sudo "/nix/var/nix/profiles/system-$2-link/bin/switch-to-configuration" "${3:-boot}"
elif [ "$1" = "repl" ]; then
  if [ "$#" -gt 2 ]; then
    echo "Usage: nx repl [host]"
    echo
    echo "host   Machine to inspect"

    exit 1
  fi

  nixos-rebuild --impure --flake "$HOME/.config/nixos#${2:-$NIXOS_MACHINE_NAME}" repl
elif [ "$1" = "secrets" ]; then
  if [ "$#" -gt 2 ]; then
    echo "Usage: nx secrets [type]"
    echo
    echo "type   Machine type"

    exit 1
  fi

  sudo GNUPGHOME=/etc/nixos/.gnupg sops "$HOME/.config/nixos/resources/secrets/${2:-$NIXOS_MACHINE_TYPE}/store.yaml"
elif [ "$1" = "iso" ]; then
  if [ "$#" != 1 ]; then
    echo "Usage: nx iso"
    exit 1
  fi

  nix build github:pascaldiehm/nixos#nixosConfigurations.installer.config.system.build.isoImage
  cp result/iso/*.iso nixos.iso
  rm result
else
  help
  exit 1
fi
