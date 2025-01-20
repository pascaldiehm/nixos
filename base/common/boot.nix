{ lib, ... }: {
  boot = {
    initrd.postDeviceCommands = builtins.readFile ../../resources/scripts/wipe-root.sh |> lib.mkAfter;

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 8;
    };
  };

  fileSystems = {
    "/" = {
      fsType = "btrfs";
      label = "nixos";
      options = [ "subvol=root" ];
    };

    "/boot" = {
      fsType = "vfat";
      label = "ESP";
      options = [ "dmask=0077" "fmask=0077" ];
    };

    "/nix" = {
      fsType = "btrfs";
      label = "nixos";
      options = [ "subvol=nix" ];
    };

    "/perm" = {
      fsType = "btrfs";
      label = "nixos";
      neededForBoot = true;
      options = [ "subvol=perm" ];
    };
  };
}
