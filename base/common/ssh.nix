{ config, lib, machine, ... }: {
  services.openssh = {
    enable = true;
    authorizedKeysFiles = [ config.sops.common."ssh/${machine.name}/public".path ];
    authorizedKeysInHomedir = false;
    ports = [ 1970 ];

    hostKeys = lib.singleton {
      type = "ed25519";
      path = config.sops.common."ssh/${machine.name}/host".path;
    };

    settings = {
      AllowUsers = [ "pascal" ];
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
  };

  sops.common = {
    "ssh/${machine.name}/host" = { };
    "ssh/${machine.name}/public".owner = "pascal";
  };
}
