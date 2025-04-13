{ lib, ... }: {
  boot = {
    initrd.postDeviceCommands = lib.readFile ../../resources/scripts/wipe-root.sh |> lib.mkAfter;
    loader.efi.canTouchEfiVariables = true;
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
