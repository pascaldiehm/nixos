{ config, helpers, ... }: {
  imports = [ ./common.nix ];
  security.sudo.wheelNeedsPassword = false;

  fileSystems."/" = {
    device = "/dev/disk/by-partlabel/nixos";
    fsType = "ext4";
  };

  home-manager.users.pascal.programs = {
    ssh.matchBlocks."github.com".identityFile = config.sops.secrets.github.path;
    zsh.localVariables.NIXOS_MACHINE_TYPE = "server";
  };

  networking = {
    useNetworkd = true;
    usePredictableInterfaceNames = false;
  };

  services = {
    fail2ban.enable = true;

    cron = {
      enable = true;

      systemCronJobs = [
        "0 3 * * * pascal rm $HOME/.config/zsh/.zsh_history"
      ];
    };

    openssh = {
      enable = true;
      authorizedKeysFiles = [ config.sops.secrets."${config.networking.hostName}/ssh".path ];
      ports = [ 1970 ];

      settings = {
        AllowUsers = [ "pascal" ];
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
    };
  };

  sops = {
    age.sshKeyPaths = [ ];
    defaultSopsFile = ../../resources/secrets/server/store.yaml;

    gnupg = {
      home = "/etc/nixos/.gnupg";
      sshKeyPaths = [ ];
    };

    secrets = {
      "${config.networking.hostName}/ntfy".restartUnits = [ "journalwatch.service" ];
      "${config.networking.hostName}/ssh".owner = "pascal";
      github.owner = "pascal";
    };
  };

  systemd.services.journalwatch = {
    after = [ "network-online.target" ];
    description = "Watch journalctl and report security-relevant events to ntfy";
    environment.NTFY_CMD = "${helpers.ntfy "journal" "$1"}";
    script = builtins.readFile ../../resources/scripts/journalwatch.sh;
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
  };
}
