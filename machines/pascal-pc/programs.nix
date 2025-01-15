{ pkgs, ... }:
{
  home-manager.users.pascal.home.packages = [
    pkgs.freecad-wayland
    pkgs.krita
  ];
}
