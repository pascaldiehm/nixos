#!/usr/bin/env bash

set -e
TMP="$(mktemp -d)"
ROOT="false"

if [ "$1" = "android" ]; then
  aft-mtp-mount "$TMP"
elif [ "$1" = "tmpfs" ]; then
  sudo mount -t tmpfs tmpfs "$TMP"
  ROOT="true"
elif echo "$1" | grep -q "^ftp://"; then
  curlftpfs "$1" "$TMP"
elif echo "$1" | grep -q "^ssh://"; then
  sshfs "$(echo "$1" | sed -E "s|ssh://([^:]+)(:(.*))?|\1:\3|")" "$TMP"
elif [ -b "$1" ] || [ -f "$1" ]; then
  sudo mount "$1" "$TMP"
  ROOT="true"
elif [ -b "/dev/$1" ]; then
  sudo mount "/dev/$1" "$TMP"
  ROOT="true"
else
  echo "Cannot mount $1"
  rmdir "$TMP"
  exit 1
fi

pushd "$TMP"
$SHELL || true
popd

echo "Syncing..."
sync

echo "Unmounting..."
if [ "$ROOT" = "true" ]; then
  sudo umount "$TMP"
else
  umount "$TMP"
fi

echo "Done."
rmdir "$TMP"
