{
  boot.loader.systemd-boot.enable = true;
  security.sudo.wheelNeedsPassword = false;

  networking = {
    useNetworkd = true;
    usePredictableInterfaceNames = false;
  };
}
