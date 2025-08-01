{ config, ... }: {
  nix.cache = "http://bowser:5779";

  fileSystems."/home/pascal/Shared" = {
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

  home-manager.users.pascal.programs.git.signing = {
    key = "E85EB0566C779A2F";
    signByDefault = true;
  };
}
