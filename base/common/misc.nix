{ inputs, ... }: {
  nixpkgs.hostPlatform = "x86_64-linux";
  services.fwupd.enable = true;

  networking.hosts = {
    "192.168.1.88" = [ "bowser" ];
    "192.168.1.89" = [ "homeassistant" ];
    "192.168.1.90" = [ "pascal-pc" ];
    "192.168.1.91" = [ "pascal-laptop" ];
    "192.168.1.99" = [ "pascal-phone" ];
    "91.99.52.233" = [ "goomba" ];
  };

  system = {
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or "???";
    stateVersion = "24.11";
  };
}
