{ pkgs, ... }: {
  # Programs
  home.packages = [
    pkgs.bitwarden-desktop
    pkgs.exfat
    pkgs.imagemagick
    pkgs.kdePackages.filelight
    pkgs.kdePackages.kdeconnect-kde
    pkgs.kdePackages.partitionmanager
    pkgs.php
    pkgs.python3
    pkgs.texlive.combined.scheme-full
    pkgs.vlc
    pkgs.yt-dlp
  ];
}
