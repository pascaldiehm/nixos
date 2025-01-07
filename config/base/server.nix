{ config, pkgs, ... }: {
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
    firewall.enable = false;
    useNetworkd = true;
    usePredictableInterfaceNames = false;
  };

  services.openssh = {
    enable = true;
    authorizedKeysFiles = [ config.sops.secrets."${config.networking.hostName}/ssh".path ];
    ports = [ 1970 ];

    settings = {
      AllowUsers = [ "pascal" ];
      PasswordAuthentication = false;
    };
  };

  sops = {
    age.sshKeyPaths = [ ];
    defaultSopsFile = ../../resources/secrets/server/store.yml;

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
    path = [ pkgs.curl ];
    script = builtins.readFile ../../resources/scripts/journalwatch.sh;
    wantedBy = [ "multi-user.target" ];

    environment = {
      NTFY_CHANNEL = "${config.networking.hostName}-journal";
      NTFY_TOKEN_PATH = config.sops.secrets."${config.networking.hostName}/ntfy".path;
    };
  };
}
