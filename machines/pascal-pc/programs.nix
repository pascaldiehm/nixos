{ pkgs, ... }: {
  home-manager.users.pascal.home.packages = [
    pkgs.blender-hip
    pkgs.freecad-wayland
    pkgs.gimp3
    pkgs.prismlauncher
    pkgs.quickemu
    pkgs.tenacity
  ];
}
