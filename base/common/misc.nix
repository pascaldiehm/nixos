{ machine, ... }: {
  home-manager.users.pascal.xdg.enable = true;
  networking.hostName = machine.name;
  services.fwupd.enable = true;
  system.stateVersion = "24.11";
}
