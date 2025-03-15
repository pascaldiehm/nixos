{ machine, ... }: {
  networking = {
    hostName = machine.name;
    nftables.enable = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
}
