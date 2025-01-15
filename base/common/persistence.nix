{ lib, ... }:
{
  environment.persistence."/perm" = {
    files = [ "/etc/machine-id" ];
    hideMounts = true;

    directories = [
      "/etc/nixos"
      "/var/lib/nixos"
      "/var/lib/systemd"
    ];

    users.pascal.directories = lib.mapAttrsToList (directory: mode: { inherit directory mode; }) {
      ".config/nixos" = "0755";
      ".ssh" = "0700";
    };
  };
}
