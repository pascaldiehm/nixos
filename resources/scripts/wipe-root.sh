#!/usr/bin/env bash

tmp="$(mktemp -d)"
mount /dev/mapper/nixos "$tmp"

mkdir -p "$tmp/history"
[ -d "$tmp/root" ] && mv "$tmp/root" "$tmp/history/$(date -d "@$(stat -c "%Y" "$tmp/root")" "+%Y-%m-%d_%H:%M:%S")"
btrfs subvolume create "$tmp/root"

find "$tmp/history" -maxdepth 1 -mtime +30 | while read -r dir; do
  chattr -i "$dir/var/empty"
  rm -rf "$dir"
done

umount "$tmp"
rmdir "$tmp"
