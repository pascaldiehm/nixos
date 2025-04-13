{ lib, pkgs, ... }: {
  home-manager.users.pascal.programs.waybar = {
    enable = true;
    style = lib.mkForce ../../resources/waybar.css;
    systemd.enable = true;

    settings.bar = {
      modules-center = [ "clock" ];
      modules-left = [ "privacy" "hyprland/workspaces" "group/hardware" "mpris" ];
      modules-right = [ "network" "backlight" "wireplumber" "battery" "group/power" ];

      backlight = {
        format = "{icon} {percent}%";
        format-icons = [ "󰃞" "󰃟" "󰃠" ];
        on-click = "sleep 1 && ${lib.getExe' pkgs.hyprland "hyprctl"} dispatch dpms off";
        on-click-right = "${lib.getExe pkgs.brightnessctl} s 50%";
        tooltip = false;
      };

      battery = {
        format = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-full = "󱟢";
        format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        interval = 10;

        states = {
          warning = 20;
          critical = 10;
        };
      };

      clock = {
        calendar.format.today = "<b>{}</b>";
        tooltip-format = "<tt>{calendar}</tt>";
      };

      cpu = {
        format = " {usage}%";
        interval = 1;

        states = {
          load = 10;
          high = 80;
        };
      };

      "custom/reboot" = {
        format = "󰜉";
        on-click = "${lib.getExe' pkgs.systemd "systemctl"} reboot";
        tooltip-format = "Reboot";
      };

      "custom/shutdown" = {
        format = "󰐥";
        on-click = "${lib.getExe' pkgs.systemd "systemctl"} poweroff";
        tooltip-format = "Power off";
      };

      "custom/sleep" = {
        format = "󰤄";
        on-click = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
        tooltip-format = "Sleep";
      };

      disk = {
        format = " {percentage_used}%";
        interval = 10;
        tooltip-format = "{specific_used:.1f} / {specific_total:.1f} GiB";
        unit = "GiB";

        states = {
          warning = 80;
          critical = 95;
        };
      };

      "group/hardware" = {
        modules = [ "cpu" "memory" "disk" "temperature" ];
        orientation = "inherit";
      };

      "group/power" = {
        drawer.transition-left-to-right = false;
        modules = [ "custom/shutdown" "custom/sleep" "custom/reboot" ];
        orientation = "inherit";
      };

      "hyprland/workspaces" = {
        all-outputs = true;
        move-to-monitor = true;
      };

      memory = {
        interval = 1;
        format = " {percentage}%";
        tooltip-format = "{used:.1f} / {total:.1f} GiB";

        states = {
          warning = 50;
          critical = 80;
        };
      };

      mpris = {
        artist-len = 16;
        dynamic-order = [ "title" "artist" ];
        format = "{status_icon} {dynamic}";
        title-len = 32;
        tooltip-format = "Player: {player}\nTitle: {title}\nArtist: {artist}\nAlbum: {album}";

        status-icons = {
          playing = "󰐊";
          paused = "󰏤";
          stopped = "󰓛";
        };
      };

      network = {
        format = "󰛵";
        format-disconnected = "󰲛";
        format-ethernet = "󰈀 {ipaddr}/{cidr}";
        format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
        format-wifi = "{icon} {ipaddr}/{cidr}";
        interval = 10;
        tooltip-format = "Unknown state";
        tooltip-format-disconnected = "Disconnected";
        tooltip-format-ethernet = "{ifname}: Ethernet";
        tooltip-format-wifi = "{ifname}: {essid} ({frequency}GHz WiFi)";
      };

      privacy = {
        icon-size = 14;
        icon-spacing = 0;
      };

      temperature = {
        format = "{icon} {temperatureC}°C";
        format-icons = [ "" "" "" "" "" ];
        tooltip = false;
      };

      wireplumber = {
        format = "{icon} {volume}%";
        format-icons = [ "󰕿" "󰖀" "󰕾" ];
        format-muted = "󰖁";
        on-click = "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_SINK@ toggle";
        on-click-right = "${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_SINK@ 40%";
      };
    };
  };
}
