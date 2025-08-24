{ pkgs, ... }: {
  home-manager.users.pascal.home.packages = [
    pkgs.blender-hip
    pkgs.freecad
    pkgs.gimp3
    pkgs.qemu
    pkgs.qucs-s
    pkgs.quickemu
    pkgs.tenacity
  ];
}
