{
  home-manager.users.pascal.wayland.windowManager.hyprland.settings.monitor = "eDP-1, preferred, auto, 1.33";
  services.tlp.enable = true;

  features = {
    amdgpu.enable = true;
    bluetooth.enable = true;
  };
}
