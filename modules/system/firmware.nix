{ pkgs, ... }: {
  services.fwupd.enable = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        configurationLimit = 8;
      };
    };
  };
}
