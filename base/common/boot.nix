{ lib, ... }:
{
  boot = {
    initrd.postDeviceCommands = builtins.readFile ../../resources/scripts/wipe-root.sh |> lib.mkAfter;

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
      label = "nixos";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

    "/boot" = {
      label = "ESP";
      fsType = "vfat";

      options = [
        "dmask=0077"
        "fmask=0077"
      ];
    };

    "/nix" = {
      label = "nixos";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

    "/perm" = {
      label = "nixos";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=perm" ];
    };
  };
}
