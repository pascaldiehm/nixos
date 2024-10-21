{ pkgs, ... }: {
  # Install sops
  environment.systemPackages = [ pkgs.sops ];

  # Setup sops-nix
  sops = {
    defaultSopsFile = ../../resources/secrets/store.yml;
    gnupg.home = "/etc/nixos/.gnupg";
  };
}
