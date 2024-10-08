{ pkgs, ... }: {
  # Programs
  home.packages = [
    pkgs.bitwarden-desktop
    pkgs.imagemagick
    pkgs.texlive.combined.scheme-full
    pkgs.vlc
    pkgs.yt-dlp
  ];
}
