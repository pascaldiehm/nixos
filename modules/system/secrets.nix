{ config, pkgs, ... }: {
  # Install sops
  environment.systemPackages = [ pkgs.sops ];

  # Apply secrets
  users.users.pascal.hashedPasswordFile = config.sops.secrets.password.path;

  sops = {
    age.keyFile = /etc/nixos/secret.key;
    defaultSopsFile = ../../resources/secrets/store.yml;

    secrets = { password = {}; } // (import ../lib.nix).mkUserSecrets {
      u2f_keys = config.home-manager.users.pascal.xdg.configHome + "/Yubico/u2f_keys";
    };
  };
}
