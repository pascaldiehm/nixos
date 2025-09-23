#!/usr/bin/env bash

TMP="$(mktemp -d)"
mount /dev/disk/by-label/nixos "$TMP"

mkdir -p "$TMP/history"
find "$TMP/history" -mindepth 1 -maxdepth 1 -mtime +7 -exec btrfs subvolume delete --recursive "{}" +

test -d "$TMP/root" && mv "$TMP/root" "$TMP/history/$(date --date "@$(stat --format "%Y" "$TMP/root")" "+%Y-%m-%d_%H:%M:%S")"
btrfs subvolume create "$TMP/root"

umount "$TMP"
rmdir "$TMP"
