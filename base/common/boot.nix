{ lib, machine, ... }: {
  boot = {
    initrd.postDeviceCommands = lib.readFile ../../resources/scripts/wipe-root.sh |> lib.mkAfter;

    lanzaboote = {
      enable = machine.boot == "secure";
      pkiBundle = "/perm/var/lib/sbctl";
    };

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = machine.boot == "efi";
    };
  };

  fileSystems = {
    "/" = {
      fsType = "btrfs";
      label = "nixos";
      options = [ "compress=zstd" "subvol=root" ];
    };

    "/boot" = {
      fsType = "vfat";
      label = "ESP";
      options = [ "dmask=0077" "fmask=0077" ];
    };

    "/nix" = {
      fsType = "btrfs";
      label = "nixos";
      options = [ "compress=zstd" "noatime" "subvol=nix" ];
    };

    "/perm" = {
      fsType = "btrfs";
      label = "nixos";
      neededForBoot = true;
      options = [ "compress=zstd" "subvol=perm" ];
    };
  };
}
