{ inputs, ... }: {
  console.keyMap = "de";
  services.fwupd.enable = true;
  time.timeZone = "Europe/Berlin";

  system = {
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or "???";
    stateVersion = "24.11";
  };
}
