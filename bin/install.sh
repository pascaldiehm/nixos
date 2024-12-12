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
  read -p "> " -N 1 TYPE
done

MACHINE=""
while [ -z "$MACHINE" ]; do
  clear
  echo "Which machine should I install?"
  echo
  read -p "> " MACHINE
done

DEV=""
while [ ! -b "$DEV" ]; do
  clear
  echo "Which device should I use?"
  echo
  lsblk
  echo
  read -p "> " DEV
  [ -b "$DEV" ] || DEV="/dev/$DEV"
done

echo "Formatting $DEV..."
if [ "$TYPE" = "D" ]; then
  parted "$DEV" -- mklabel gpt
  parted "$DEV" -- mkpart nixos btrfs 512MB 100%
  parted "$DEV" -- mkpart ESP fat32 1MB 512MB
  parted "$DEV" -- set 2 esp on
elif [ "$TYPE" = "S" ]; then
  parted "$DEV" -- mklabel gpt
  parted "$DEV" -- mkpart nixos ext4 512MB 100%
  parted "$DEV" -- mkpart ESP fat32 1MB 512MB
  parted "$DEV" -- set 2 esp on
fi

echo "Waiting for partitions..."
while [ ! -b /dev/disk/by-partlabel/nixos ]; do sleep 1; done
while [ ! -b /dev/disk/by-partlabel/ESP ]; do sleep 1; done

if [ "$TYPE" = "D" ]; then
  echo "Encrypting root partition..."
  cryptsetup luksFormat /dev/disk/by-partlabel/nixos
  cryptsetup open /dev/disk/by-partlabel/nixos nixos
fi

echo "Creating filesystems..."
if [ "$TYPE" = "D" ]; then
  mkfs.btrfs -L nixos /dev/mapper/nixos
  mkfs.fat -F 32 -n ESP /dev/disk/by-partlabel/ESP
elif [ "$TYPE" = "S" ]; then
  mkfs.ext4 -L nixos /dev/disk/by-partlabel/nixos
  mkfs.fat -F 32 -n ESP /dev/disk/by-partlabel/ESP
fi

if [ "$TYPE" = "D" ]; then
  echo "Creating subvolumes..."
  mount /dev/mapper/nixos /mnt
  btrfs subvolume create /mnt/nix
  btrfs subvolume create /mnt/root
  btrfs subvolume create /mnt/perm
  umount /mnt
fi

echo "Mounting partitions..."
if [ "$TYPE" = "D" ]; then
  mount -o subvol=root /dev/mapper/nixos /mnt
  mkdir /mnt/{nix,perm,boot}
  mount -o subvol=nix /dev/mapper/nixos /mnt/nix
  mount -o subvol=perm /dev/mapper/nixos /mnt/perm
  mount -o umask=077 /dev/disk/by-partlabel/ESP /mnt/boot
elif [ "$TYPE" = "S" ]; then
  mount /dev/disk/by-partlabel/nixos /mnt
  mkdir /mnt/boot
  mount -o umask=077 /dev/disk/by-partlabel/ESP /mnt/boot
fi

echo "Generating hardware configuration..."
if [ "$TYPE" = "D" ]; then
  mkdir -p /mnt/perm/etc/nixos
  nixos-generate-config --show-hardware-config --no-filesystems >/mnt/perm/etc/nixos/hardware.nix
  ln -s /mnt/perm/etc/nixos/hardware.nix /etc/nixos/hardware.nix
elif [ "$TYPE" = "S" ]; then
  mkdir -p /mnt/etc/nixos
  nixos-generate-config --show-hardware-config >/mnt/etc/nixos/hardware.nix
  ln -s /mnt/etc/nixos/hardware.nix /etc/nixos/hardware.nix
fi

echo "Cloning NixOS configuration"
if [ "$TYPE" = "D" ]; then
  git clone https://github.com/pascaldiehm/nixos.git /mnt/perm/home/pascal/.config/nixos
  git --git-dir /mnt/perm/home/pascal/.config/nixos/.git remote set-url origin git@github.com:pascaldiehm/nixos.git
  git --git-dir /mnt/perm/home/pascal/.config/nixos/.git rev-parse HEAD >/mnt/perm/etc/nixos/commit
  chown -R 1000:100 /mnt/perm/home/pascal
  chmod 700 /mnt/perm/home/pascal
  ln -s /mnt/perm/home/pascal /home/pascal
elif [ "$TYPE" = "S" ]; then
  git clone https://github.com/pascaldiehm/nixos.git /mnt/home/pascal/.config/nixos
  git --git-dir /mnt/home/pascal/.config/nixos/.git remote set-url origin git@github.com:pascaldiehm/nixos.git
  git --git-dir /mnt/home/pascal/.config/nixos/.git rev-parse HEAD >/mnt/etc/nixos/commit
  chown -R 1000:100 /mnt/home/pascal
  chmod 700 /mnt/home/pascal
  ln -s /mnt/home/pascal /home/pascal
fi

echo "Preparing GnuPG..."
mkdir -p -m 700 ~/.gnupg
echo "pinentry-program $(which pinentry-tty)" >~/.gnupg/gpg-agent.conf

echo "Setting up GnuPG..."
if [ "$TYPE" = "D" ]; then
  mkdir -p -m 700 /mnt/perm/etc/nixos/.gnupg
  echo "disable-scdaemon" >/mnt/perm/etc/nixos/.gnupg/gpg-agent.conf
elif [ "$TYPE" = "S" ]; then
  mkdir -p -m 700 /mnt/etc/nixos/.gnupg
  echo "disable-scdaemon" >/mnt/etc/nixos/.gnupg/gpg-agent.conf
fi

echo "Installing secret key..."
if [ "$TYPE" = "D" ]; then
  gpg --decrypt /home/pascal/.config/nixos/resources/secrets/desktop/key.gpg | gpg --homedir /mnt/perm/etc/nixos/.gnupg --import
elif [ "$TYPE" = "S" ]; then
  gpg --decrypt /home/pascal/.config/nixos/resources/secrets/server/key.gpg | gpg --homedir /mnt/etc/nixos/.gnupg --import
fi

echo "Installing NixOS..."
nixos-install --impure --no-channel-copy --no-root-password --flake "/home/pascal/.config/nixos#$MACHINE"
