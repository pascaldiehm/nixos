{ config, lib, ... }: {
  # Setup bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  # Firmware updates
  services.fwupd.enable = true;

  # Localization
  console.keyMap = "de";
  services.xserver.xkb.layout = "de";
  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  # Programs
  programs = {
    git.enable = true;
    nano.enable = false;
    vim.enable = true;
  };

  # List system packages
  environment.etc.nixos-packages.text = let
    packages = config.environment.systemPackages;
    names = builtins.map (p: p.name) packages;
    sorted = lib.naturalSort names;
    unique = lib.unique sorted;
    content = builtins.concatStringsSep "\n" unique;
  in content;
}
