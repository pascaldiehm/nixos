{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.sops ];

  sops = {
    defaultSopsFile = ../../resources/secrets/desktop/store.yml;
    gnupg.home = "/perm/etc/nixos/.gnupg";
  };
}
