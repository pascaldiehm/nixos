{
  config,
  lib,
  system,
  ...
}:
{
  boot = {
    initrd.postDeviceCommands = lib.mkAfter ''
      DISK="${config.fileSystems."/".device}"
      ${builtins.readFile ../../resources/scripts/wipe-root.sh}
    '';

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
      device = if system.type == "desktop" then "/dev/mapper/nixos" else "/dev/disk/by-partlabel/nixos";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

    "/boot" = {
      device = "/dev/disk/by-partlabel/ESP";
      fsType = "vfat";

      options = [
        "dmask=0077"
        "fmask=0077"
      ];
    };

    "/nix" = {
      inherit (config.fileSystems."/") device;
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

    "/perm" = {
      inherit (config.fileSystems."/") device;
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=perm" ];
    };
  };
}
