{ config, lib, ... }: {
  environment.persistence."/perm".users.pascal = {
    directories = lib.mapAttrsToList (directory: mode: { inherit directory mode; }) {
      ".local/share/gnupg" = "0700";
      ".local/state/wireplumber" = "0755";
      Repos = "0755";
    };
  };

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
