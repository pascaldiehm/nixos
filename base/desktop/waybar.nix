{ lib, pkgs, ... }: {
  home-manager.users.pascal = {
    services.playerctld.enable = true;

    programs.waybar = {
      enable = true;
      style = lib.mkForce ../../resources/waybar.css;
      systemd.enable = true;

      settings.bar = {
        clock.tooltip-format = "<tt>{calendar}</tt>";
        modules-left = [ "privacy" "clock" "hyprland/workspaces" "mpris" ];
        modules-right = [ "group/hardware" "group/screen" "wireplumber" "network" "battery" "group/session" ];

        backlight = {
          format = "{icon} {percent}%";
          format-icons = [ "󰃞" "󰃟" "󰃠" ];
          on-click-right = "${lib.getExe pkgs.brightnessctl} s 50%";
          on-scroll-down = "${lib.getExe pkgs.brightnessctl} s 1%-";
          on-scroll-up = "${lib.getExe pkgs.brightnessctl} s +1%";
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

        cpu = {
          format = " {usage}%";

          states = {
            load = 10;
            high = 80;
          };
        };

        "custom/dpms" = {
          format = "󰶐";
          on-click = "sleep 1 && ${lib.getExe' pkgs.hyprland "hyprctl"} dispatch dpms off";
          tooltip-format = "Turn off screen";
        };

        "custom/lock" = {
          format = "󰌾";
          on-click = "${lib.getExe' pkgs.systemd "loginctl"} lock-session";
          tooltip-format = "Lock screen";
        };

        "custom/quit" = {
          format = "󰈆";
          on-click = "${lib.getExe' pkgs.hyprland "hyprctl"} dispatch exit";
          tooltip-format = "Quit Hyprland";
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

        "group/screen" = {
          drawer.transition-left-to-right = false;
          modules = [ "backlight" "custom/dpms" "idle_inhibitor" ];
          orientation = "inherit";
        };

        "group/session" = {
          drawer.transition-left-to-right = false;
          modules = [ "custom/shutdown" "custom/lock" "custom/quit" "custom/sleep" "custom/reboot" ];
          orientation = "inherit";
        };

        idle_inhibitor = rec {
          format = "{icon}";
          tooltip-format-activated = "Keep screen unlocked";
          tooltip-format-deactivated = tooltip-format-activated;

          format-icons = {
            activated = "󰒳";
            deactivated = "󰒲";
          };
        };

        "hyprland/workspaces" = {
          all-outputs = true;
          move-to-monitor = true;
        };

        memory = {
          format = " {percentage}%";
          interval = 10;
          tooltip-format = "{used:.1f} / {total:.1f} GiB";

          states = {
            warning = 50;
            critical = 80;
          };
        };

        mpris = {
          dynamic-order = [ "title" "artist" ];
          format = "{status_icon} {dynamic} ({player})";
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
  };
}
