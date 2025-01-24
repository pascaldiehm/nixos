{
  home-manager.users.pascal.programs.waybar = {
    enable = true;
    systemd.enable = true;

    # TODO https://github.com/Alexays/Waybar/wiki
    settings.mainBar = {
      modules-center = [ "clock" ];
      modules-left = [ "hyprland/workspaces" ];
      modules-right = [ "group/hardware" "group/screen" "wireplumber" "network" "group/battery" "group/poweroff" ];

      "group/battery" = {
        drawer.transition-left-to-right = false;
        modules = [ "battery" "power-profiles-daemon" ];
        orientation = "inherit";
      };

      "group/hardware" = {
        modules = [ "cpu" "memory" "disk" "temperature" ];
        orientation = "inherit";
      };

      "group/poweroff" = {
        drawer.transition-left-to-right = false;
        modules = [ "custom/shutdown" "custom/lock" "custom/reboot" ];
        orientation = "inherit";
      };

      "group/screen" = {
        drawer.transition-left-to-right = false;
        modules = [ "backlight" "idle_inhibitor" ];
        orientation = "inherit";
      };

      "hyprland/workspaces" = {
        all-outputs = true;
        move-to-monitor = true;
      };
    };
  };
}
