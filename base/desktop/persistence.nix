{ lib, ... }: {
  environment.persistence."/perm" = {
    directories = [ "/var/lib/sbctl" ];

    users.pascal = {
      files = [ ".config/VSCodium/User/globalStorage/state.vscdb" ];

      directories = lib.mapAttrsToList (directory: mode: { inherit directory mode; }) {
        ".local/share/gnupg" = "0700";
        ".local/state/wireplumber" = "0755";
        ".mozilla/firefox/default" = "0755";
        ".thunderbird/default" = "0755";
        Desktop = "0755";
        Documents = "0755";
        Music = "0755";
        Pictures = "0755";
        Videos = "0755";
      };
    };
  };
}
