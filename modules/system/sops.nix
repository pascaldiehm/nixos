{ pkgs, ... }: {
  # Install sops
  environment.systemPackages = [ pkgs.sops ];

  # Setup sops-nix
  sops = {
    age.keyFile = /etc/nixos/secret.key;
    defaultSopsFile = ../../resources/secrets/store.yml;
  };
}
