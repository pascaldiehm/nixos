{ ... }: {
  environment.persistence."/perm" = {
    hideMounts = true;

    directories = [
      "/etc/nixos"
      "/var/lib/nixos"
    ];

    files = [
      "/etc/machine-id"
    ];

    users.pascal = {
      directories = [
        ".config/kdeconnect"
        ".config/nixos"
        ".local/share/kwalletd"
        ".mozilla/firefox/default"
        ".thunderbird/default"
        "Documents"
        { directory = ".local/share/gnupg"; mode = "0700"; }
        { directory = ".ssh"; mode = "0700"; }
      ];

      files = [
        ".config/Bitwarden/data.json"
        ".config/VSCodium/User/globalStorage/state.vscdb"
      ];
    };
  };
}
