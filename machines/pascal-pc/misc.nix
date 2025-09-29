{ pkgs, ... }: {
  home-manager.users.pascal.home.packages = [ pkgs.blender-hip pkgs.freecad pkgs.qemu pkgs.qucs-s pkgs.quickemu ];

  features = {
    amdgpu.enable = true;
    bluetooth.enable = true;
  };
}
