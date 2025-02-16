{ config, machine, ... }: {
  home-manager.users.pascal.programs.ssh.matchBlocks."github.com".identityFile = config.sops.secrets.github.path;
  services.fail2ban.enable = true;

  services.openssh = {
    enable = true;
    authorizedKeysFiles = [ config.sops.secrets."${machine.name}/ssh".path ];
    ports = [ 1970 ];

    settings = {
      AllowUsers = [ "pascal" ];
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
  };

  sops.secrets = {
    "${machine.name}/ssh".owner = "pascal";
    github.owner = "pascal";
  };
}
