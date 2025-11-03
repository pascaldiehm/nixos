{ config, ... }: {
  environment.persistence."/perm".users.pascal.directories = [
    ".config/nixos"
    ".local/state/wireplumber"
    "Repos"

    {
      directory = ".local/share/gnupg";
      mode = "0700";
    }
  ];

  fileSystems = {
    "/home/pascal/Shared" = {
      device = "pascal@bowser:shared";
      fsType = "sshfs";

      options = [
        "ConnectTimeout=5"
        "IdentityFile=${config.sops.secrets."ssh/bowser".path}"
        "Port=1970"
        "ServerAliveInterval=5"
        "_netdev"
        "allow_other"
        "reconnect"
        "x-systemd.automount"
        "x-systemd.idle-timeout=1h"
      ];
    };

    "/home/pascal/Temp" = {
      device = "tmpfs";
      fsType = "tmpfs";
    };
  };
}
