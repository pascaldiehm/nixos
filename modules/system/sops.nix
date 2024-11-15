{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.sops ];

  sops = {
    defaultSopsFile = ../../resources/secrets/store.yml;
    gnupg.home = "/perm/etc/nixos/.gnupg";
  };
}
