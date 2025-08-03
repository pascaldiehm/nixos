{ lib, pkgs, ... }: {
  home-manager.users.pascal.programs.waybar = {
    enable = true;
    style = ../../resources/waybar.css;
    systemd.enable = true;

    settings.bar = {
      modules-center = [ "mpris" ];
      modules-left = [ "hyprland/workspaces" "cpu" "memory" "disk" "temperature" ];
      modules-right = [ "network" "backlight" "wireplumber" "battery" "clock" ];

      backlight = {
        format = "{icon} {percent}%";
        format-icons = [ "󰃞" "󰃟" "󰃠" ];
        on-click = "sleep 1 && ${lib.getExe' pkgs.hyprland "hyprctl"} dispatch dpms off";
        on-click-right = "${lib.getExe pkgs.brightnessctl} set 50%";
        tooltip = false;
      };

      battery = {
        format = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-full = "󱟢";
        format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        format-time = "{H}:{m}";
        full-at = 95;
        interval = 1;
        tooltip-format = "{timeTo}\nPower: {power:.1f}W\nCycles: {cycles}\nHealth: {health}%";

        states = {
          critical = 10;
          warning = 20;
        };
      };

      clock = {
        format = "{:%b %d, %H:%M}";
        tooltip-format = "<tt>{calendar}</tt>";

        actions = {
          on-click = "mode";
          on-click-right = "shift_reset";
          on-scroll-down = "shift_down";
          on-scroll-up = "shift_up";
        };

        calendar = {
          mode-mon-col = 3;
          on-scroll = -1;
          weeks-pos = "left";

          format = {
            months = "<span color='#f80'><b>{}</b></span>";
            today = "<span color='#f00'><b>{}</b></span>";
            weekdays = "<span color='#888'><b>{}</b></span>";
            weeks = "<span color='#888'><b>{}</b></span>";
          };
        };
      };

      cpu = {
        format = " {usage}%";
        interval = 1;

        states = {
          high = 80;
          load = 10;
        };
      };

      disk = {
        format = " {percentage_used}%";
        interval = 10;
        tooltip-format = "{specific_used:.1f} / {specific_total:.1f} GiB";
        unit = "GiB";

        states = {
          critical = 95;
          warning = 80;
        };
      };

      "hyprland/workspaces" = {
        all-outputs = true;
        move-to-monitor = true;
      };

      memory = {
        format = " {percentage}%";
        interval = 1;
        tooltip-format = "{used:.1f} / {total:.1f} GiB";

        states = {
          critical = 80;
          warning = 50;
        };
      };

      mpris = {
        artist-len = 16;
        dynamic-len = 32;
        dynamic-order = [ "title" "artist" ];
        format = "{status_icon} {dynamic}";
        title-len = 32;
        tooltip-format = "Player: {player}\nTitle: {title}\nArtist: {artist}\nAlbum: {album}";

        status-icons = {
          paused = "󰏤";
          playing = "󰐊";
          stopped = "󰓛";
        };
      };

      network = {
        format = "󰛵";
        format-disconnected = "󰲛";
        format-ethernet = "󰈀 {ipaddr}/{cidr}";
        format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
        format-wifi = "{icon} {ipaddr}/{cidr}";
        interval = 1;
        tooltip-format = "Connecting...";
        tooltip-format-disconnected = "Disconnected";
        tooltip-format-ethernet = "{ifname}: Ethernet\nGateway: {gwaddr}\nDown: {bandwidthDownBits}\nUp: {bandwidthUpBits}";
        tooltip-format-wifi = "{ifname}: {essid} ({frequency}GHz WiFi)\nGateway: {gwaddr}\nDown: {bandwidthDownBits}\nUp: {bandwidthUpBits}";
      };

      temperature = {
        format = "{icon} {temperatureC}°C";
        format-icons = [ "" "" "" "" "" ];
        interval = 1;
        tooltip = false;
      };

      wireplumber = {
        format = "{icon} {volume}%";
        format-icons = [ "󰕿" "󰖀" "󰕾" ];
        format-muted = "󰖁";
        on-click = "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_SINK@ toggle";
        on-click-right = "${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_SINK@ 40%";

        on-click-middle = pkgs.writeShellScript "wp-toggle" ''
          DEVICE="$(${lib.getExe' pkgs.wireplumber "wpctl"} inspect @DEFAULT_SINK@ | grep device.id | cut -d \" -f 2)"
          DEVICE="$(${lib.getExe' pkgs.pipewire "pw-dump"} | ${lib.getExe pkgs.jq} ".[] | select(.id == $DEVICE)")"
          ROUTES="$(${lib.getExe pkgs.jq} '.info.params.EnumRoute | .[] | select(.direction == "Output") | .index' <<<"$DEVICE")"
          ROUTE="$(${lib.getExe pkgs.jq} '.info.params.Route | .[] | select(.direction == "Output") | .index' <<<"$DEVICE")"

          ${lib.getExe' pkgs.wireplumber "wpctl"} set-route @DEFAULT_SINK@ "$(echo -e "$ROUTES\n$ROUTES" | sed -n "/^$ROUTE$/{n;p}")"
        '';
      };
    };
  };
}
