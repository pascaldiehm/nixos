{ inputs, machine, ... }: {
  nixpkgs.hostPlatform = "x86_64-linux";
  services.fwupd.enable = true;

  networking = {
    hostName = machine.name;
    nftables.enable = true;
    useDHCP = false;
  };

  system = {
    configurationRevision = inputs.self.rev or "<dirty>";
    stateVersion = "24.11";
  };
}
