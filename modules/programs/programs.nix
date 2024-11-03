{ config, hmcfg, pkgs, helpers, ... }: {
  environment.etc."nixos/packages".text = helpers.mkPackageList (config.environment.systemPackages ++ hmcfg.home.packages);
  programs.nano.enable = false;

  home-manager.users.pascal.home.packages = [
    pkgs.bitwarden-desktop
    pkgs.cryptsetup
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
}
