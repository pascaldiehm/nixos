{ config, lib, ... }: {
  # Bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;

    systemd-boot = {
      enable = true;
      configurationLimit = 8;
    };
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

  # Yubikey authentication
  security.pam.u2f = {
    enable = true;

    settings = {
      cue = true;
      origin = "pam://pascal";
    };
  };

  # Docker
  users.users.pascal.extraGroups = [ "docker" ];

  virtualisation.docker = {
    enable = true;

    autoPrune = {
      enable = true;
      flags = [ "--all" ];
    };
  };

  # Programs
  programs = {
    git.enable = true;
    nano.enable = false;
    vim.enable = true;
  };

  # Home Manager
  home-manager = {
    backupFileExtension = "bak";
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # List system packages
  environment.etc.nixos-packages.text = (import ../lib.nix).mkPkgList config.environment.systemPackages;
}
