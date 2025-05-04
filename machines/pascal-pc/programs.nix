{ pkgs, ... }: {
  home-manager.users.pascal.home.packages = [
    pkgs.blender-hip
    pkgs.freecad-wayland
    pkgs.gimp3
    pkgs.inkscape
    pkgs.kicad
    pkgs.prismlauncher
    pkgs.quickemu
    pkgs.tenacity
  ];
}
