{ lib, ... }:
{
  environment.persistence."/perm".users.pascal = {
    directories = lib.mapAttrsToList (directory: mode: { inherit directory mode; }) {
      ".config/kdeconnect" = "0755";
      ".local/share/gnupg" = "0700";
      ".local/share/kwalletd" = "0755";
      ".local/state/wireplumber" = "0755";
      ".mozilla/firefox/default" = "0755";
      ".thunderbird/default" = "0755";
      Desktop = "0755";
      Documents = "0755";
      Music = "0755";
      Pictures = "0755";
      Videos = "0755";
    };

    files = [
      ".config/VSCodium/User/globalStorage/state.vscdb"
      ".config/kwinoutputconfig.json"
    ];
  };
}
