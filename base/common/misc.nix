{ machine, ... }: {
  console.keyMap = "de";
  home-manager.users.pascal.xdg.enable = true;
  networking.hostName = machine.name;
  services.fwupd.enable = true;
  system.stateVersion = "24.11";
  time.timeZone = "Europe/Berlin";
}
