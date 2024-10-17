{ config, lib, ... }: let
  secrets = builtins.fromJSON (builtins.readFile /etc/nixos/secrets.json);
in {
  # Delete dead channel links
  home.activation.deleteChannelLinks = lib.hm.dag.entryAfter [ "writeBoundary" "installPackages" "linkGeneration" ] "run rm -rf .nix-defexpr .nix-profile";

  # Enable XDG
  xdg = {
    enable = true;
    mimeApps.enable = true;
  };

  # Install u2f keys
  xdg.configFile."Yubico/u2f_keys".text = secrets.u2f_keys;

  # List user packages
  xdg.dataFile.nixos-packages.text = let
    packages = config.home.packages;
    names = builtins.map (p: p.name) packages;
    sorted = lib.naturalSort names;
    unique = lib.unique sorted;
    content = builtins.concatStringsSep "\n" unique;
  in content;
}
