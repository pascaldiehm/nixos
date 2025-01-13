{ config, glb, ... }: {
  home-manager.users.pascal.programs.ssh.matchBlocks."github.com".identityFile = config.sops.secrets.github.path;
  security.sudo.wheelNeedsPassword = false;

  environment.persistence."/perm" = {
    directories = [ "/var/lib/docker" "/var/lib/fail2ban" ];
    users.pascal.directories = [ "docker" ];

    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  networking = {
    useNetworkd = true;
    usePredictableInterfaceNames = false;
  };

  services = {
    fail2ban.enable = true;

    openssh = {
      enable = true;
      authorizedKeysFiles = [ config.sops.secrets."${config.system.name}/ssh".path ];
      ports = [ 1970 ];

      settings = {
        AllowUsers = [ "pascal" ];
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
    };
  };

  sops.secrets = {
    "${config.system.name}/ntfy".restartUnits = [ "journalwatch.service" ];
    "${config.system.name}/ssh".owner = "pascal";
    github.owner = "pascal";
  };

  systemd.services.journalwatch = {
    after = [ "network-online.target" ];
    description = "Watch journalctl and report security-relevant events to ntfy";
    environment.NTFY_CMD = "${glb.mkNtfy "journal" "$1"}";
    script = builtins.readFile ../../resources/scripts/journalwatch.sh;
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
  };
}
