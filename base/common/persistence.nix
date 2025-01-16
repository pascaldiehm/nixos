{ lib, ... }: {
  environment.persistence."/perm" = {
    directories = [ "/etc/nixos" "/var/lib/nixos" "/var/lib/systemd" ];
    files = [ "/etc/machine-id" ];
    hideMounts = true;

    users.pascal.directories = lib.mapAttrsToList (directory: mode: { inherit directory mode; }) {
      ".config/nixos" = "0755";
      ".ssh" = "0700";
    };
  };
}
