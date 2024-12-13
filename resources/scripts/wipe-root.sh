#!/usr/bin/env bash

tmp="$(mktemp -d)"
mount /dev/mapper/nixos "$tmp"

mkdir -p "$tmp/history"
[ -d "$tmp/root" ] && mv "$tmp/root" "$tmp/history/$(date -d "@$(stat -c %Y "$tmp/root")" "+%Y-%m-%d_%H:%M:%S")"

find "$tmp/history" -maxdepth 1 -mtime +30 -exec rm -rf {} \;
btrfs subvolume create "$tmp/root"

umount "$tmp"
rmdir "$tmp"
