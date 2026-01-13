#!/usr/bin/env bash

TMP="$(mktemp -d)"
mount /dev/disk/by-label/nixos "$TMP"

mkdir -p "$TMP/history"
find "$TMP/history" -mindepth 1 -maxdepth 1 -mtime +7 -exec btrfs subvolume delete --recursive "{}" +

if [ -d "$TMP/root" ]; then
  TARGET="$TMP/history/$(date -d "@$(stat -c "%Y" "$TMP/root")" "+%Y-%m-%d_%H:%M:%S")"
  while [ -d "$TARGET" ]; do TARGET+="="; done

  mv "$TMP/root" "$TARGET"
fi

btrfs subvolume create "$TMP/root"
umount "$TMP"
rmdir "$TMP"
