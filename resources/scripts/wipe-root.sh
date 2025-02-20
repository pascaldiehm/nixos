#!/usr/bin/env bash

TMP="$(mktemp -d)"
mount /dev/disk/by-label/nixos "$TMP"

mkdir -p "$TMP/history"
[ -d "$TMP/root" ] && mv "$TMP/root" "$TMP/history/$(date -d "@$(stat -c "%Y" "$TMP/root")" "+%Y-%m-%d_%H:%M:%S")"
btrfs subvolume create "$TMP/root"

find "$TMP/history" -mindepth 1 -maxdepth 1 -mtime +30 | while read -r dir; do
  chattr -i "$dir/var/empty"
  rm -rf "$dir"
done

umount "$TMP"
rmdir "$TMP"
