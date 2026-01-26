{ inputs, machine, ... }: {
  hardware.enableRedistributableFirmware = true;
  networking.hostName = machine.name;
  nixpkgs.hostPlatform = "x86_64-linux";
  services.fwupd.enable = true;

  environment.variables = {
    NIXOS_MACHINE_NAME = machine.name;
    NIXOS_MACHINE_TYPE = machine.type;
  };

  system = {
    configurationRevision = inputs.self.rev or "<dirty>";
    stateVersion = "24.11";
  };
}
