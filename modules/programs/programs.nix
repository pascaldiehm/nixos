{ config, hmcfg, pkgs, helpers, ... }: {
  environment.etc."nixos/packages".text = helpers.mkPackageList (config.environment.systemPackages ++ hmcfg.home.packages);
  programs.nano.enable = false;

  home-manager.users.pascal.home.packages = [
    pkgs.bitwarden-desktop
    pkgs.btrfs-progs
    pkgs.cryptsetup
    pkgs.exfat
    pkgs.gradle
    pkgs.imagemagick
    pkgs.jdk
    pkgs.jq
    pkgs.kdePackages.filelight
    pkgs.kdePackages.kdeconnect-kde
    pkgs.kdePackages.partitionmanager
    pkgs.nodejs
    pkgs.php
    pkgs.python3
    pkgs.quickemu
    pkgs.texlive.combined.scheme-full
    pkgs.unzip
    pkgs.vlc
    pkgs.yt-dlp
    pkgs.zip
  ];
}
