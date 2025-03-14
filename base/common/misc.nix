{ machine, ... }: {
  networking.hostName = machine.name;
  services.fwupd.enable = true;
}
