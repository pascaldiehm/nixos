{ inputs, machine, ... }: {
  networking.hostName = machine.name;
  nixpkgs.hostPlatform = "x86_64-linux";
  services.fwupd.enable = true;

  system = {
    configurationRevision = inputs.self.rev or "<dirty>";
    stateVersion = "24.11";
  };
}
