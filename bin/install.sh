#!/usr/bin/env bash

[ "$EUID" -ne 0 ] && exec sudo "$0" "$@"
set -e

if ! ping -c 1 1.1.1.1 &>/dev/null; then
  echo "No internet connection"
  exit 1
fi

TYPE=""
while [ "$TYPE" != "D" ] && [ "$TYPE" != "S" ]; do
  clear
  echo "Which type should I install?"
  echo
  echo "D) Desktop"
  echo "S) Server"
  echo
  read -r -p "> " -N 1 TYPE
done

MACHINE=""
while [ -z "$MACHINE" ]; do
  clear
  echo "Which machine should I install?"
  echo
  read -r -p "> " MACHINE
done

DEV=""
while [ ! -b "$DEV" ]; do
  clear
  echo "Which device should I use?"
  echo
  lsblk
  echo
  read -r -p "> " DEV
  [ -b "$DEV" ] || DEV="/dev/$DEV"
done

echo "Formatting $DEV..."
parted "$DEV" -- mklabel gpt
parted "$DEV" -- mkpart nixos btrfs 512MB 100%
parted "$DEV" -- mkpart ESP fat32 1MB 512MB
parted "$DEV" -- set 2 esp on

echo "Waiting for partitions..."
PART_NIXOS="/dev/disk/by-partlabel/nixos"
while [ ! -b "$PART_NIXOS" ]; do sleep 1; done

PART_ESP="/dev/disk/by-partlabel/ESP"
while [ ! -b "$PART_ESP" ]; do sleep 1; done

if [ "$TYPE" = "D" ]; then
  echo "Encrypting root partition..."
  cryptsetup luksFormat "$PART_NIXOS"
  cryptsetup open "$PART_NIXOS" nixos
  PART_NIXOS="/dev/mapper/nixos"
fi

echo "Creating filesystems..."
mkfs.btrfs -L nixos "$PART_NIXOS"
mkfs.fat -F 32 -n ESP "$PART_ESP"

echo "Creating subvolumes..."
mount "$PART_NIXOS" /mnt
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/perm
umount /mnt

echo "Mounting partitions..."
mount -o subvol=root "$PART_NIXOS" /mnt
mkdir /mnt/{nix,perm,boot}
mount -o subvol=nix "$PART_NIXOS" /mnt/nix
mount -o subvol=perm "$PART_NIXOS" /mnt/perm
mount -o umask=077 "$PART_ESP" /mnt/boot

echo "Generating hardware configuration..."
mkdir -p /mnt/perm/etc/nixos
nixos-generate-config --root /mnt --show-hardware-config --no-filesystems >/mnt/perm/etc/nixos/hardware.nix
ln -s /mnt/perm/etc/nixos/hardware.nix /etc/nixos/hardware.nix

echo "Cloning NixOS configuration"
git clone https://github.com/pascaldiehm/nixos.git /mnt/perm/home/pascal/.config/nixos
[ "$TYPE" = "D" ] && git --git-dir /mnt/perm/home/pascal/.config/nixos/.git remote set-url origin git@github.com:pascaldiehm/nixos.git
git --git-dir /mnt/perm/home/pascal/.config/nixos/.git rev-parse HEAD >/mnt/perm/etc/nixos/commit
chown -R 1000:100 /mnt/perm/home/pascal
chmod 700 /mnt/perm/home/pascal
ln -s /mnt/perm/home/pascal /home/pascal

echo "Preparing GnuPG..."
mkdir -p ~/.gnupg
chmod 700 ~/.gnupg
echo "pinentry-program $(which pinentry-tty)" >~/.gnupg/gpg-agent.conf

echo "Setting up GnuPG..."
mkdir -p /mnt/perm/etc/nixos/.gnupg
chmod 700 /mnt/perm/etc/nixos/.gnupg
echo "disable-scdaemon" >/mnt/perm/etc/nixos/.gnupg/gpg-agent.conf

echo "Installing secret key..."
[ "$TYPE" = "D" ] && gpg --decrypt /home/pascal/.config/nixos/resources/secrets/desktop/key.gpg | gpg --homedir /mnt/perm/etc/nixos/.gnupg --import
[ "$TYPE" = "S" ] && gpg --decrypt /home/pascal/.config/nixos/resources/secrets/server/key.gpg | gpg --homedir /mnt/perm/etc/nixos/.gnupg --import

echo "Installing NixOS..."
nixos-install --impure --no-channel-copy --no-root-password --flake "/home/pascal/.config/nixos#$MACHINE"
