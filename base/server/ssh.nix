{ config, machine, ... }: {
  services.fail2ban.enable = true;
  sops.secrets."${machine.name}/ssh".owner = "pascal";

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
}
