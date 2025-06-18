{ inputs, ... }: {
  console.keyMap = "de";
  nixpkgs.hostPlatform = "x86_64-linux";
  services.fwupd.enable = true;
  time.timeZone = "Europe/Berlin";

  system = {
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or "???";
    stateVersion = "24.11";
  };
}
