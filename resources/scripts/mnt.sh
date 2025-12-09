#!/usr/bin/env bash

set -e
TMP="$(mktemp -d)"
ROOT=0

if [ "$1" = "android" ]; then
  aft-mtp-mount "$TMP"
elif [ "$1" = "tmpfs" ]; then
  sudo mount -t tmpfs tmpfs "$TMP"
  ROOT=1
elif expr "$1" : ftp:// >/dev/null; then
  curlftpfs "$1" "$TMP"
elif expr "$1" : ssh:// >/dev/null; then
  sshfs "$(sed -E "s|^ssh://([^:]+)(:(.*))?$|\1:\3|" <<<"$1")" "$TMP"
elif [ -b "$1" ] || [ -f "$1" ]; then
  sudo mount "$1" "$TMP"
  ROOT=1
elif [ -b "/dev/$1" ]; then
  sudo mount "/dev/$1" "$TMP"
  ROOT=1
elif [ -b "/dev/disk/by-label/$1" ]; then
  sudo mount "/dev/disk/by-label/$1" "$TMP"
  ROOT=1
elif [ -b "/dev/disk/by-partlabel/$1" ]; then
  sudo mount "/dev/disk/by-partlabel/$1" "$TMP"
  ROOT=1
else
  echo "Cannot mount $1"
  rmdir "$TMP"
  exit 1
fi

cd "$TMP"
$SHELL || true
cd /

echo "Syncing..."
sync

echo "Unmounting..."
if ((ROOT)); then
  sudo umount "$TMP"
else
  umount "$TMP"
fi

echo "Done."
rmdir "$TMP"
