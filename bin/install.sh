#!/usr/bin/env bash

set -e

[ "$EUID" -eq 0 ] || exec sudo "$0" "$@"

if ! ping -c 1 1.1.1.1 &>/dev/null; then
  echo "No internet connection"
  exit 1
fi

MACHINE=""
while [ -z "$MACHINE" ]; do
  echo "Which machine should I install?"
  read -p "> " MACHINE
done

DEV=""
while [ ! -b "$DEV" ]; do
  lsblk
  echo
  echo "Which device should I format?"
  read -p "> " DEV
  [ ! -b "$DEV" ] && DEV="/dev/$DEV"
done

echo "Formatting $DEV..."
parted "$DEV" -- mklabel gpt
parted "$DEV" -- mkpart nixos btrfs 512MB 100%
parted "$DEV" -- mkpart ESP fat32 1MB 512MB
parted "$DEV" -- set 2 esp on

echo "Waiting for partitions..."
while [ ! -b /dev/disk/by-partlabel/nixos ]; do sleep 1; done
while [ ! -b /dev/disk/by-partlabel/ESP ]; do sleep 1; done

echo "Encrypting root partition..."
cryptsetup luksFormat /dev/disk/by-partlabel/nixos
cryptsetup open /dev/disk/by-partlabel/nixos nixos

echo "Creating filesystems..."
mkfs.btrfs -L nixos /dev/mapper/nixos
mkfs.fat -F 32 -n ESP /dev/disk/by-partlabel/ESP

echo "Creating subvolumes..."
mount /dev/mapper/nixos /mnt
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/perm
umount /mnt

echo "Mounting partitions..."
mount -o subvol=root /dev/mapper/nixos /mnt
mkdir /mnt/{nix,perm,boot}
mount -o subvol=nix /dev/mapper/nixos /mnt/nix
mount -o subvol=perm /dev/mapper/nixos /mnt/perm
mount -o umask=077 /dev/disk/by-partlabel/ESP /mnt/boot

echo "Generating hardware configuration..."
mkdir -p /mnt/perm/etc/nixos
nixos-generate-config --show-hardware-config --no-filesystems >/mnt/perm/etc/nixos/hardware.nix
ln -s /mnt/perm/etc/nixos/hardware.nix /etc/nixos/hardware.nix

echo "Cloning NixOS configuration..."
git clone https://github.com/pascaldiehm/nixos /mnt/perm/home/pascal/.config/nixos
git --git-dir /mnt/perm/home/pascal/.config/nixos/.git remote set-url origin git@github.com:pascaldiehm/nixos.git
chown -R 1000:100 /mnt/perm/home/pascal
chmod 700 /mnt/perm/home/pascal
ln -s /mnt/perm/home/pascal /home/pascal

echo "Preparing GnuPG..."
mkdir -p -m 700 ~/.gnupg
echo "pinentry-program $(which pinentry-tty)" >~/.gnupg/gpg-agent.conf

echo "Setting up GnuPG..."
mkdir -p -m 700 /mnt/perm/etc/nixos/.gnupg
echo "disable-scdaemon" >/mnt/perm/etc/nixos/.gnupg/gpg-agent.conf
ln -s /mnt/perm/etc/nixos/.gnupg /etc/nixos/.gnupg

echo -n "Insert YubiKey and press enter..."
read

echo "Installing secret key..."
echo "fetch" | gpg --command-fd 0 --card-edit
gpg --decrypt /home/pascal/.config/nixos/resources/secrets/key.gpg | gpg --homedir /etc/nixos/.gnupg --import

echo "Installing NixOS..."
nixos-install --impure --no-channel-copy --no-root-password --flake "/home/pascal/.config/nixos#$MACHINE"
