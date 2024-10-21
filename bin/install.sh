#!/usr/bin/env bash

[ "$EUID" -eq 0 ] || { echo "Please run as root"; exit 1; }
ping -c 1 1.1.1.1 &> /dev/null || { echo "No internet connection"; exit 1; }

set -e

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
echo "Encrypting root partition..."
cryptsetup luksFormat "$PART_ROOT"
cryptsetup open "$PART_ROOT" nixos

echo "Creating filesystems..."
mkfs.ext4 -L nixos /dev/mapper/nixos
mkfs.fat -F 32 -n boot "$PART_BOOT"

echo "Mounting partitions..."
mount /dev/mapper/nixos /mnt
rm -rf /mnt/lost+found
mkdir -p /mnt/boot
mount -o umask=077 "$PART_BOOT" /mnt/boot

echo "Generating hardware configuration..."
nixos-generate-config --root /mnt
rm /mnt/etc/nixos/configuration.nix
mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hardware.nix
ln -s /mnt/etc/nixos/hardware.nix /etc/nixos/hardware.nix

echo "Cloning NixOS configuration..."
git clone https://github.com/pascaldiehm/nixos /mnt/home/pascal/.config/nixos

echo "Fixing home directory permissions..."
chown -R 1000:100 /mnt/home/pascal
chmod 700 /mnt/home/pascal

echo "Decrypting secrets..."
mkdir -p -m 700 ~/.gnupg
echo "pinentry-program $(which pinentry-tty)" > ~/.gnupg/gpg-agent.conf
gpg-connect-agent reloadagent /bye
echo -n "Insert the YubiKey and press enter..."
read

echo "fetch" | gpg --command-fd 0 --card-edit
mkdir -p -m 700 /mnt/etc/nixos/.gnupg
gpg --decrypt /mnt/home/pascal/.config/nixos/resources/secrets/key.gpg | gpg --homedir /mnt/etc/nixos/.gnupg --import
ln -s /mnt/etc/nixos/.gnupg /etc/nixos/.gnupg

echo "Installing NixOS..."
nixos-install --impure --no-channel-copy --no-root-password --root /mnt --flake "/mnt/home/pascal/.config/nixos#$MACHINE"
