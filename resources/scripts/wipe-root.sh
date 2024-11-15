#!/usr/bin/env bash

tmp="$(mktemp -d)"
mount /dev/mapper/nixos "$tmp"

if [ -d "$tmp/root" ]; then
  mkdir -p "$tmp/history"
  timestamp="$(date -d "@$(stat -c %Y "$tmp/root")" "+%Y-%m-%d_%H:%M:%S")"
  mv "$tmp/root" "$tmp/history/$timestamp"
fi

btrfs subvolume create "$tmp/root"
umount "$tmp"
rmdir "$tmp"
