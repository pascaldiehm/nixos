{ ... }: {
  # Setup bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;

    systemd-boot = {
      enable = true;
      configurationLimit = 8;
    };
  };

  # Enable firmware updates
  services.fwupd.enable = true;
}
