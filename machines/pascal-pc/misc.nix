{ pkgs, ... }: {
  features = {
    amdgpu.enable = true;
    bluetooth.enable = true;
  };

  home-manager.users.pascal = {
    home.packages = [ pkgs.blender-hip pkgs.freecad pkgs.qemu pkgs.qucs-s pkgs.quickemu ];
    programs.godot.android.enable = true;
  };
}
