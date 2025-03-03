{ config, lib, pkgs, ... }: {
  home-manager.users.pascal = {
    services.ssh-agent.enable = true;

    programs.ssh = {
      extraConfig = ''
        IdentitiesOnly yes
        SetEnv TERM=xterm-256color
      '';

      matchBlocks = {
        "github.com".identityFile = config.sops.secrets."ssh/github".path;

        bowser = {
          forwardAgent = true;
          identityFile = config.sops.secrets."ssh/bowser".path;
          port = 1970;
        };

        goomba = {
          forwardAgent = true;
          identityFile = config.sops.secrets."ssh/goomba".path;
          port = 1970;
        };

        installer = {
          extraOptions.UserKnownHostsFile = "/dev/null";
          hostname = "nixos";
          identityFile = config.sops.secrets."ssh/installer".path;
          user = "nixos";
        };
      };
    };

    systemd.user.services.ssh-agent.Service = {
      Environment = "SSH_AUTH_SOCK=%t/ssh-agent";

      ExecStartPost = pkgs.writeShellScript "add-ssh-keys" ''
        ${lib.getExe' pkgs.openssh "ssh-add"} ${config.sops.secrets."ssh/github".path}
      '';
    };
  };

  sops.secrets = {
    "ssh/bowser".owner = "pascal";
    "ssh/github".owner = "pascal";
    "ssh/goomba".owner = "pascal";
    "ssh/installer".owner = "pascal";
  };
}
