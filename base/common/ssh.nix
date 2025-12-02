{ config, lib, machine, ... }: {
  programs.ssh.knownHosts = {
    "[bowser]:1970".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILpY9HXNKIfGvwQTQ1rLidyoheecUiYaBFu6R2LSxiiG";
    "[goomba]:1970".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFyFZp8gdn4egNOAtBA/U+eCxdHEyPU/fnLvwMqOtoFR";
    "[pascal-laptop]:1970".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMdTOVCs6qsCHb3TLXq0rGc7WUgUHgmjGxRxd4rHU+q1";
    "[pascal-pc]:1970".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKSmgsw6WYhO5L9HvG4nhsW+WpTAYsR5UwwOQcmte4QU";
    "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
  };

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
