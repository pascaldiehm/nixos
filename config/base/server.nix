{ config, pkgs, ... }: {
  imports = [ ./common.nix ];
  home-manager.users.pascal.programs.ssh.matchBlocks."github.com".identityFile = config.sops.secrets.github.path;
  networking.firewall.enable = false;

  services.openssh = {
    enable = true;
    ports = [ 1970 ];

    settings = {
      AllowUsers = [ "pascal" ];
      PasswordAuthentication = false;
      PermitRootLogin = "no";
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
      github.owner = "pascal";
      ntfy.restartUnits = [ "journalwatch.service" ];
    };
  };

  systemd.services.journalwatch = {
    description = "Watch journalctl and report security-relevant events to ntfy";
    wantedBy = [ "default.target" ];

    script = ''
      function report() {
        ${pkgs.curl}/bin/curl -s -H "Authorization: Bearer $(cat ${config.sops.secrets.ntfy.path})" -d "$1" 'https://ntfy.pdiehm.dev/bowser-journal'
      }

      ${builtins.readFile ../../resources/scripts/journalwatch.sh}
    '';
  };
}
