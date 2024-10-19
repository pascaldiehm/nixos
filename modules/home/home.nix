{ config, lib, ... }: {
  # Delete dead channel links
  home.activation.deleteChannelLinks = lib.hm.dag.entryAfter [ "writeBoundary" "installPackages" "linkGeneration" ] "run rm -rf .nix-defexpr .nix-profile";

  # Enable XDG
  xdg = {
    enable = true;
    mimeApps.enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  # List user packages
  xdg.dataFile.nixos-packages.text = (import ../lib.nix).mkPkgList config.home.packages;
}
