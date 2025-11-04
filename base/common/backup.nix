{ config, lib, machine, pkgs, ... }: {
  environment.persistence."/perm".directories = [ "/var/lib/duplicity" ];
  home-manager.users.pascal.home.packages = [ pkgs.scripts.backup ];
  systemd.timers.duplicity.timerConfig.Persistent = true;

  programs.scripts.backup.text = ''
    test "$UID" = 0 || exec sudo "$0" "$@"
    set -a

    # shellcheck disable=SC1091
    source "${config.sops.common."backup/env".path}"

    KEY="${config.sops.common."backup/key".path}"
    URL="sftp://pascal@bowser:1970/archive/Backups/${machine.name}"

    exec ${lib.getExe pkgs.duplicity} --archive-dir /var/lib/duplicity --ssh-options "-i '$KEY'" "$1" "$URL" "''${@:2}"
  '';

  services.duplicity = {
    enable = true;
    cleanup.maxFull = 2;
    exclude = [ "**" ];
    extraFlags = [ "--ssh-options=\"-i ${config.sops.common."backup/key".path}\"" ];
    fullIfOlderThan = "1M";
    secretFile = config.sops.common."backup/env".path;
    targetUrl = "sftp://pascal@bowser:1970/archive/Backups/${machine.name}";
  };

  sops.common = {
    "backup/env" = { };
    "backup/key" = { };
  };
}
