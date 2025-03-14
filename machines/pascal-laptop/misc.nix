{ pkgs, ... }: {
  home-manager.users.pascal.wayland.windowManager.hyprland.settings.monitor = "eDP-1, preferred, auto, 1.33";

  hardware = {
    bluetooth.enable = true;
    graphics.extraPackages = [ pkgs.rocmPackages.clr.icd ];
  };
}
