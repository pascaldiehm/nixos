{ config, ... }: {
  sops.secrets."bowser/nix-serve" = { };

  services.nix-serve = {
    enable = true;
    openFirewall = true;
    port = 5779;
    secretKeyFile = config.sops.secrets."bowser/nix-serve".path;
  };
}
