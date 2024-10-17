{ config, lib, ... }: {
  # Delete dead channel links
  home.activation.deleteChannelLinks = lib.hm.dag.entryAfter [ "writeBoundary" "installPackages" "linkGeneration" ] "run rm -rf .nix-defexpr .nix-profile";

  # Enable XDG
  xdg = {
    enable = true;
    mimeApps.enable = true;
  };

  # Install u2f keys
  xdg.configFile."Yubico/u2f_keys".text = (import ../lib.nix).secrets.u2f_keys;

  # List user packages
  xdg.dataFile.nixos-packages.text = (import ../lib.nix).mkPkgList config.home.packages;
}
