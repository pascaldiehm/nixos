{ config, lib, machine, ... }: {
  services.openssh = {
    enable = true;
    authorizedKeysFiles = [ config.sops.secrets."common/ssh/${machine.name}/public".path ];
    ports = [ 1970 ];

    hostKeys = lib.singleton {
      type = "ed25519";
      path = config.sops.secrets."common/ssh/${machine.name}/host".path;
    };

    settings = {
      AllowUsers = [ "pascal" ];
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
  };

  sops.secrets = {
    "common/ssh/${machine.name}/host".sopsFile = ../../resources/secrets/common/store.yaml;

    "common/ssh/${machine.name}/public" = {
      owner = "pascal";
      sopsFile = ../../resources/secrets/common/store.yaml;
    };
  };
}
