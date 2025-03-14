{ machine, ... }: {
  services.fwupd.enable = true;

  networking = {
    hostName = machine.name;
    nftables.enable = true;
  };
}
