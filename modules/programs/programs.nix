{ config, hmcfg, pkgs, helpers, ... }: {
  environment.etc."nixos/packages".text = helpers.mkPackageList (config.environment.systemPackages ++ hmcfg.home.packages);
  fonts.packages = [ pkgs.fira-code ];
  programs.nano.enable = false;

  home-manager.users.pascal.home.packages = [
    pkgs.btrfs-progs
    pkgs.cryptsetup
    pkgs.exfat
    pkgs.gdb
    pkgs.gnumake
    pkgs.gradle
    pkgs.imagemagickBig
    pkgs.jdk
    pkgs.jq
    pkgs.kdePackages.filelight
    pkgs.kdePackages.partitionmanager
    pkgs.nodejs
    pkgs.php
    pkgs.poppler_utils
    pkgs.python3
    pkgs.quickemu
    pkgs.sshfs
    pkgs.texlive.combined.scheme-full
    pkgs.unzip
    pkgs.vlc
    pkgs.wireguard-tools
    pkgs.yt-dlp
    pkgs.zip
  ];
}
