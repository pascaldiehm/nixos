#!/usr/bin/env bash

set -e

if [ "$#" != 3 ]; then
  echo "Usage: godot-editor <project> <file> <line>"
  exit 1
elif nc -z 127.0.0.1 6004; then
  nvim --server 127.0.0.1:6004 --remote-send "<Cmd>e +$3 $2<Return>"
else
  cd "$1"
  exec kitty nvim --listen 127.0.0.1:6004 "+$3" "$2"
fi
