{ lib, pkgs, ... }: {
  boot = {
    initrd = {
      luks.devices.nixos.device = "/dev/disk/by-partlabel/nixos";
      postDeviceCommands = lib.mkAfter (builtins.readFile ../../resources/scripts/wipe-root.sh);
    };

    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        configurationLimit = 8;
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/nixos";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

    "/boot" = {
      device = "/dev/disk/by-partlabel/ESP";
      fsType = "vfat";
      options = [ "dmask=0077" "fmask=0077" ];
    };

    "/nix" = {
      device = "/dev/mapper/nixos";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

    "/perm" = {
      device = "/dev/mapper/nixos";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=perm" ];
    };
  };
}
