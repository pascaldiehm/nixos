{
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "Mon 01:00";
    flags = [ "--impure" ];
    flake = "github:pascaldiehm/nixos";
    upgrade = false;
  };
}
