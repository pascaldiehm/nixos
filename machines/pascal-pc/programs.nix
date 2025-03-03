{ pkgs, ... }: {
  home-manager.users.pascal.home.packages = [
    pkgs.freecad-wayland
    pkgs.kdePackages.kdenlive
    pkgs.krita
    pkgs.prismlauncher
    pkgs.quickemu
    pkgs.tenacity
  ];
}
