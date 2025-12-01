#!/usr/bin/env bash

TOKEN="$(cat "${TOKEN}")"

if [ "$#" = 1 ]; then
  curl --silent --show-error --header "Authorization: Bearer $TOKEN" --data "$1" https://ntfy.pdiehm.dev/default
elif [ "$#" = 2 ]; then
  curl --silent --show-error --header "Authorization: Bearer $TOKEN" --data "$2" "https://ntfy.pdiehm.dev/${MACHINE}-$1"
else
  echo "Usage: ntfy [channel] <message>"
  exit 1
fi
