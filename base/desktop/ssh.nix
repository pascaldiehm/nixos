{ config, ... }: {
  home-manager.users.pascal.programs.ssh = {
    extraConfig = "SetEnv TERM=xterm-256color";

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

  sops.secrets = {
    "ssh/bowser".owner = "pascal";
    "ssh/github".owner = "pascal";
    "ssh/goomba".owner = "pascal";
    "ssh/installer".owner = "pascal";
  };
}
