{ machine, ... }: {
  networking = {
    hostName = machine.name;
    nftables.enable = true;
    useDHCP = false;
  };
}
