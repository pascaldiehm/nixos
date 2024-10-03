#!/usr/bin/env bash

function error() {
    echo "Error: $1"
    exit 1
}

[ "$EUID" -eq 0 ] || error "Please run as root"
ping -c 1 1.1.1.1 &> /dev/null || error "No internet connection"

command -v git || nix-env -iA nixos.git

MACHINE=""
while [ -z "$MACHINE" ]; do
    clear
    echo "Which machine should I install?"
    read -p "> " MACHINE
done

DEV=""
while [ ! -b "$DEV" ]; do
    clear
    lsblk
    echo
    echo "Which device should I format?"
    read -p "> " DEV
    [ ! -b "$DEV" ] && DEV="/dev/$DEV"
done

clear
echo "Formatting $DEV..."
parted "$DEV" -- mklabel gpt
parted "$DEV" -- mkpart root ext4 512MB 100%
parted "$DEV" -- mkpart ESP fat32 1MB 512MB
parted "$DEV" -- set 2 esp on

PART_ROOT="${DEV}1"
[ ! -b "$PART_ROOT" ] && PART_ROOT="${DEV}p1"
while [ ! -b "$PART_ROOT" ]; do
    clear
    lsblk
    echo
    echo "I couldn't detect the root partition. Please enter it manually."
    read -p "> " PART_ROOT
    [ ! -b "$PART_ROOT" ] && PART_ROOT="/dev/$PART_ROOT"
done

PART_BOOT="${DEV}2"
[ ! -b "$PART_BOOT" ] && PART_BOOT="${DEV}p2"
while [ ! -b "$PART_BOOT" ]; do
    clear
    lsblk
    echo
    echo "I couldn't detect the boot partition. Please enter it manually."
    read -p "> " PART_BOOT
    [ ! -b "$PART_BOOT" ] && PART_BOOT="/dev/$PART_BOOT"
done

clear
echo "Creating filesystems..."
mkfs.ext4 -L nixos "$PART_ROOT"
mkfs.fat -F 32 -n boot "$PART_BOOT"

echo "Mounting partitions..."
mount "$PART_ROOT" /mnt
rm -rf /mnt/lost+found
mkdir -p /mnt/boot
mount -o umask=077 "$PART_BOOT" /mnt/boot

echo "Building NixOS configuration..."
nixos-generate-config --root /mnt
ln -s /mnt/etc/nixos/hardware-configuration.nix /etc/nixos/hardware-configuration.nix
git clone https://github.com/pascaldiehm/nixos /mnt/home/pascal/.config/nixos

echo "Fixing home directory permissions..."
chown -R 1000:100 /mnt/home/pascal
chmod 700 /mnt/home/pascal

echo "Installing NixOS..."
nixos-install --impure --no-channel-copy --no-root-password --root /mnt --flake "/mnt/home/pascal/.config/nixos#$MACHINE"
