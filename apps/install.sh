#!/usr/bin/env bash

[ "$EUID" = 0 ] || exec sudo "$0" "$@"

if ! ping -c 1 1.1.1.1 &>/dev/null; then
  echo "No internet connection"
  exit 1
fi

MACHINE=""
TYPE="null"
while [ "$TYPE" = "null" ]; do
  clear
  echo "Which machine should I install?"
  echo
  read -r -p "> " MACHINE
  TYPE="$(machines | jq -r ".\"$MACHINE\"")"
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

if [ "$TYPE" = "desktop" ]; then
  if ! sbctl status &>/dev/null || [ "$(sbctl status --json | jq .setup_mode)" = "false" ]; then
    echo "ERROR: Secure boot is disabled or not in setup mode"
    exit 1
  fi
fi

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

if [ "$TYPE" = "desktop" ]; then
  echo "Encrypting root partition..."
  read -rs -p "Enter disk encryption password: " FDE_PASS

  echo -n "$FDE_PASS" | cryptsetup luksFormat "$PART_NIXOS"
  echo -n "$FDE_PASS" | cryptsetup open "$PART_NIXOS" nixos

  unset FDE_PASS
  PART_NIXOS="/dev/mapper/nixos"
fi

echo "Creating filesystems..."
mkfs.btrfs -f -L nixos "$PART_NIXOS"
mkfs.fat -F 32 -n ESP "$PART_ESP"

echo "Creating subvolumes..."
mount "$PART_NIXOS" /mnt
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/perm
umount /mnt

echo "Mounting partitions..."
mount -o compress=zstd,subvol=root "$PART_NIXOS" /mnt
mkdir /mnt/{nix,perm,boot}
mount -o compress=zstd,noatime,subvol=nix "$PART_NIXOS" /mnt/nix
mount -o compress=zstd,subvol=perm "$PART_NIXOS" /mnt/perm
mount -o umask=077 "$PART_ESP" /mnt/boot

if [ "$TYPE" = "desktop" ]; then
  echo "Setting up secure boot..."
  mkdir -p /mnt/perm/var/lib/sbctl
  ln -s /mnt/perm/var/lib/sbctl /var/lib/sbctl
  sbctl create-keys
  sbctl enroll-keys --microsoft
fi

echo "Generating hardware configuration..."
mkdir -p /mnt/perm/etc/nixos
nixos-generate-config --root /mnt --show-hardware-config --no-filesystems >/mnt/perm/etc/nixos/hardware.nix
ln -s /mnt/perm/etc/nixos/hardware.nix /etc/nixos/hardware.nix

echo "Cloning NixOS configuration..."
git clone https://github.com/pascaldiehm/nixos.git /mnt/perm/home/pascal/.config/nixos
git --git-dir /mnt/perm/home/pascal/.config/nixos/.git remote set-url origin git@github.com:pascaldiehm/nixos.git
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
echo disable-scdaemon >/mnt/perm/etc/nixos/.gnupg/gpg-agent.conf

echo "Installing secret key..."
gpg --decrypt "/home/pascal/.config/nixos/resources/secrets/$TYPE/key.gpg" | gpg --homedir /mnt/perm/etc/nixos/.gnupg --import

echo "Installing NixOS..."
nixos-install --impure --no-channel-copy --no-root-password --flake "/home/pascal/.config/nixos#$MACHINE"
