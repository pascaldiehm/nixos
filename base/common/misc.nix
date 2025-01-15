{ system, ... }:
{
  home-manager.users.pascal.xdg.enable = true;
  networking.hostName = system.name;
  services.fwupd.enable = true;
  system.stateVersion = "24.11";

  virtualisation.docker = {
    enable = true;
    daemon.settings.log-driver = "local";
  };
}
