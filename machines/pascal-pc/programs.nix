{ pkgs, ... }: {
  home-manager.users.pascal.home.packages = [
    pkgs.blender-hip
    pkgs.freecad-wayland
    pkgs.gimp3
    pkgs.inkscape
    pkgs.prismlauncher
    pkgs.qucs-s
    pkgs.quickemu
    pkgs.tenacity
  ];
}
