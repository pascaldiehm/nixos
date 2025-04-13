{ inputs, ... }: {
  services.fwupd.enable = true;

  system = {
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or "???";
    stateVersion = "24.11";
  };
}
