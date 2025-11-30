#!/usr/bin/env bash

test "$UID" = 0 || exec sudo "$0" "$@"
set -a

# shellcheck disable=SC1090,SC1091
source "${backup_env}"

function dup() {
  duplicity --archive-dir /var/lib/duplicity --ssh-options "-i '${backup_key}'" "$@"
}

if [ "$#" = 0 ]; then
  dup cleanup --force "${target}/${machine}"
  dup remove-all-but-n-full --force 2 "${target}/${machine}"

  # shellcheck disable=SC2086
  dup incremental --full-if-older-than 1M / "${target}/${machine}" ${spec} --exclude "**"
elif [ "$1" = "status" ]; then
  dup collection-status "${target}/${2:-${machine}}"
elif [ "$1" = "list" ]; then
  dup list-current-files "${target}/${2:-${machine}}"
elif [ "$1" = "restore" ]; then
  if [ "$#" = 2 ]; then
    dup restore "${target}/${machine}" "$2"
  elif [ "$#" = 3 ]; then
    dup restore --path-to-restore "$2" "${target}/${machine}" "$3"
  elif [ "$#" = 4 ]; then
    dup restore --path-to-restore "$3" "${target}/$2" "$4"
  else
    echo "Usage: backup restore [[machine] path] <target>"
    exit 1
  fi
else
  echo "Unknown command: $1"
  exit 1
fi
