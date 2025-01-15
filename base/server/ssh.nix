{ config, system, ... }:
{
  home-manager.users.pascal.programs.ssh.matchBlocks."github.com".identityFile = config.sops.secrets.github.path;

  services.openssh = {
    enable = true;
    authorizedKeysFiles = [ config.sops.secrets."${system.name}/ssh".path ];
    ports = [ 1970 ];

    settings = {
      AllowUsers = [ "pascal" ];
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
  };

  sops.secrets = {
    "${system.name}/ssh".owner = "pascal";
    github.owner = "pascal";
  };
}
