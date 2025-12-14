#!/usr/bin/env bash

test "$UID" = 0 || exec sudo "$0" "$@"

function dup() {
  PASSPHRASE="$(cat "${BACKUP_PASS}")" duplicity --archive-dir /var/lib/duplicity --ssh-options "-i '${BACKUP_KEY}'" "$@"
}

if [ "$#" = 0 ]; then
  dup cleanup --force "${TARGET}/${MACHINE}"
  dup remove-all-but-n-full --force 2 "${TARGET}/${MACHINE}"

  # shellcheck disable=SC2086
  dup incremental --full-if-older-than 1M / "${TARGET}/${MACHINE}" ${SPEC} --exclude "**"
elif [ "$1" = "status" ]; then
  dup collection-status "${TARGET}/${2:-${MACHINE}}"
elif [ "$1" = "list" ]; then
  dup list-current-files "${TARGET}/${2:-${MACHINE}}"
elif [ "$1" = "restore" ]; then
  if [ "$#" = 2 ]; then
    dup restore "${TARGET}/${MACHINE}" "$2"
  elif [ "$#" = 3 ]; then
    dup restore --path-to-restore "$2" "${TARGET}/${MACHINE}" "$3"
  elif [ "$#" = 4 ]; then
    dup restore --path-to-restore "$3" "${TARGET}/$2" "$4"
  else
    echo "Usage: backup restore [[machine] path] <target>"
    exit 1
  fi
else
  echo "Unknown command: $1"
  exit 1
fi
