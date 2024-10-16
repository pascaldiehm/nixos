{ pkgs, ... }: {
  # Programs
  home.packages = [
    pkgs.bitwarden-desktop
    pkgs.exfat
    pkgs.imagemagick
    pkgs.kdePackages.filelight
    pkgs.kdePackages.kdeconnect-kde
    pkgs.kdePackages.partitionmanager
    pkgs.nodejs
    pkgs.texlive.combined.scheme-full
    pkgs.vlc
    pkgs.yarn
    pkgs.yt-dlp
  ];
}
