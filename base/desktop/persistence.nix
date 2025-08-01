{ lib, ... }: {
  environment.persistence."/perm".users.pascal.directories =
    lib.mapAttrsToList (directory: mode: { inherit directory mode; })
      {
        ".config/nixos" = "0755";
        ".local/share/gnupg" = "0700";
        ".local/state/wireplumber" = "0755";
        ".mozilla/firefox/default" = "0755";
        ".thunderbird/default" = "0755";
        Repos = "0755";
      };
}
