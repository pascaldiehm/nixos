{ pkgs, ... }: {
  # Programs
  home.packages = [
    pkgs.bitwarden-desktop
    pkgs.vlc
  ];
}
