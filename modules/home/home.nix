{ config, lib, ... }: {
  # Delete dead channel links
  home.activation.deleteChannelLinks = lib.hm.dag.entryAfter [ "writeBoundary" "installPackages" "linkGeneration" ] "run rm -rf .nix-defexpr .nix-profile";

  # Enable XDG
  xdg = {
    enable = true;
    mimeApps.enable = true;
  };

  # List user packages
  xdg.dataFile.nixos-packages.text = let
    packages = config.home.packages;
    names = builtins.map (p: p.name) packages;
    sorted = lib.naturalSort names;
    unique = lib.unique sorted;
    content = builtins.concatStringsSep "\n" unique;
  in content;
}
