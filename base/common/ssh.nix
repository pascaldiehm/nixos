{ config, machine, ... }: {
  services.openssh = {
    enable = true;
    authorizedKeysFiles = [ config.sops.secrets."common/ssh/${machine.name}".path ];
    ports = [ 1970 ];

    settings = {
      AllowUsers = [ "pascal" ];
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
  };

  sops.secrets."common/ssh/${machine.name}" = {
    owner = "pascal";
    sopsFile = ../../resources/secrets/common/store.yaml;
  };
}
