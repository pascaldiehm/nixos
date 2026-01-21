{ pkgs, ... }: {
  features = {
    amdgpu.enable = true;
    bluetooth.enable = true;
  };

  home-manager.users.pascal = {
    home.packages = [ pkgs.blender pkgs.freecad pkgs.qucs-s ];
    programs.godot.android.enable = true;
  };
}
