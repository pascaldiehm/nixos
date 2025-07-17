{
  security.sudo.wheelNeedsPassword = false;
  services.fail2ban.enable = true;

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "Mon 01:00";
    flags = [ "--impure" ];
    flake = "github:pascaldiehm/nixos";
    operation = "boot";
  };

  virtualisation.docker.autoPrune = {
    enable = true;
    flags = [ "--all" "--volumes" ];
  };
}
