{ config, ... }: {
  fileSystems = {
    "/home/pascal/Shared" = {
      device = "pascal@bowser:shared";
      fsType = "sshfs";

      options = [
        "IdentityFile=${config.sops.secrets."ssh/bowser".path}"
        "Port=1970"
        "ServerAliveInterval=15"
        "_netdev"
        "allow_other"
        "reconnect"
        "x-systemd.automount"
      ];
    };

    "/home/pascal/Temp" = {
      device = "tmpfs";
      fsType = "tmpfs";
    };
  };
}
