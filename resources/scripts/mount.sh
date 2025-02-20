#!/usr/bin/env bash

set -e

DIR="$(mktemp -d)"
ROOT="false"

if [ "$1" = "android" ]; then
  aft-mtp-mount "$DIR"
elif [ "$1" = "tmpfs" ]; then
  sudo mount -t tmpfs /dev/null "$DIR"
  ROOT="true"
elif echo "$1" | grep -q "^ftp://"; then
  curlftpfs "$1" "$DIR"
elif echo "$1" | grep -q "^ssh://"; then
  sshfs "$(echo "$1" | sed -E "s|ssh://([^:]+)(:(.*))?|\1:\3")" "$DIR"
elif [ -b "$1" ] || [ -f "$1" ]; then
  sudo mount "$1" "$DIR"
  ROOT="true"
elif [ -b "/dev/$1" ]; then
  sudo mount "/dev/$1" "$DIR"
  ROOT="true"
else
  echo "Cannot mount $1"
  rmdir "$DIR"
  exit 1
fi

pushd "$DIR"
$SHELL
popd

echo "Syncing..."
sync

echo "Unmounting..."
if [ "$ROOT" = "true" ]; then
  sudo umount "$DIR"
else
  umount "$DIR"
fi

echo "Done."
rmdir "$DIR"
