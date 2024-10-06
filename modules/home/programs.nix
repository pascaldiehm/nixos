{ pkgs, ... }: {
  # Programs
  home.packages = [
    pkgs.bitwarden-desktop
    pkgs.imagemagick
    pkgs.vlc
    pkgs.yt-dlp
  ];
}
