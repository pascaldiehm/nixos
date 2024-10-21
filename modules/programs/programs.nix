{ config, hmcfg, pkgs, helpers, ... }: {
  # Disable nano
  programs.nano.enable = false;

  # Install user programs
  home-manager.users.pascal.home.packages = [
    pkgs.bitwarden-desktop
    pkgs.exfat
    pkgs.imagemagick
    pkgs.kdePackages.filelight
    pkgs.kdePackages.kdeconnect-kde
    pkgs.kdePackages.partitionmanager
    pkgs.php
    pkgs.python3
    pkgs.quickemu
    pkgs.texlive.combined.scheme-full
    pkgs.vlc
    pkgs.yt-dlp
  ];

  # List packages
  environment.etc."nixos/packages".text = helpers.mkPackageList (config.environment.systemPackages ++ hmcfg.home.packages);
}
