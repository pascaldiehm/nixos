{ system, ... }: {
  boot.loader.systemd-boot.enable = true;
  security.sudo.wheelNeedsPassword = false;
  services.fail2ban.enable = true;
  sops.secrets."${system.name}/ntfy" = { };

  networking = {
    useNetworkd = true;
    usePredictableInterfaceNames = false;
  };
}
