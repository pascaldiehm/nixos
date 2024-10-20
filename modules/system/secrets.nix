{ pkgs, ... }: {
  # Install sops
  environment.systemPackages = [ pkgs.sops ];

  # Install secrets
  sops = {
    age.keyFile = /etc/nixos/secret.key;
    defaultSopsFile = ../../resources/secrets/store.yml;
  };
}
