{ config, pkgs, helpers, ... }: {
  imports = [ ./common.nix ];
  home-manager.users.pascal.programs.ssh.matchBlocks."github.com".identityFile = config.sops.secrets.github.path;
  security.sudo.wheelNeedsPassword = false;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-partlabel/nixos";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-partlabel/ESP";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };

  networking = {
    useNetworkd = true;
    usePredictableInterfaceNames = false;
  };

  services = {
    fail2ban.enable = true;

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
      "${config.networking.hostName}/ssh" = { };
      github.owner = "pascal";
    };
  };

  systemd.services.journalwatch = {
    description = "Watch journalctl and report security-relevant events to ntfy";
    environment.NTFY_CMD = "${helpers.ntfy "journal" "$1"}";
    script = builtins.readFile ../../resources/scripts/journalwatch.sh;
    wantedBy = [ "multi-user.target" ];
  };
}
