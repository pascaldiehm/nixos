{ config, lib, pkgs, ... }: {
  home-manager.users.pascal = {
    home.sessionVariables.NIXOS_OZONE_WL = 1;

    programs = {
      kitty.enable = true;
      wofi.enable = true;

      hyprlock = {
        enable = true;

        settings = {
          general.hide_cursor = true;

          background = lib.mkForce {
            blur_passes = 2;
            blur_size = 4;
            path = "screenshot";
          };

          label = {
            font_size = 64;
            halign = "center";
            position = "0, 20%";
            shadow_passes = 2;
            shadow_size = 4;
            text = "$TIME";
            valign = "center";
          };
        };
      };
    };

    services = {
      dunst = {
        enable = true;
        settings.global.follow = "mouse";
      };

      hypridle = {
        enable = true;

        settings = {
          general = {
            lock_cmd = "pidof hyprlock || ${lib.getExe pkgs.hyprlock}";
            unlock_cmd = "pkill -USR1 hyprlock && ${lib.getExe' pkgs.hyprland "hyprctl"} dispatch dpms on";
            before_sleep_cmd = "${lib.getExe' pkgs.systemd "loginctl"} lock-session";
            after_sleep_cmd = "${lib.getExe' pkgs.hyprland "hyprctl"} dispatch dpms on";
          };

          listener = {
            timeout = 300;
            on-timeout = "${lib.getExe' pkgs.hyprland "hyprctl"} dispatch dpms off";
            on-resume = "${lib.getExe' pkgs.hyprland "hyprctl"} dispatch dpms on";
          };
        };
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        bindm = [ "SUPER, mouse:272, movewindow" ];
        decoration.rounding = 10;
        workspace = [ "w[t1], gapsout:0, border:false, rounding:false" ];

        animations = {
          animation = [
            "border, 1, 5.39, easeOutQuint"
            "fade, 1, 3.03, quick"
            "fadeIn, 1, 1.73, almostLinear"
            "fadeLayersIn, 1, 1.79, almostLinear"
            "fadeLayersOut, 1, 1.39, almostLinear"
            "fadeOut, 1, 1.46, almostLinear"
            "global, 1, 10, default"
            "layers, 1, 3.81, easeOutQuint"
            "layersIn, 1, 4, easeOutQuint, fade"
            "layersOut, 1, 1.5, linear, fade"
            "windows, 1, 4.79, easeOutQuint"
            "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
            "windowsOut, 1, 1.49, linear, popin 87%"
            "workspaces, 1, 1.94, almostLinear, fade"
            "workspacesIn, 1, 1.21, almostLinear, fade"
            "workspacesOut, 1, 1.94, almostLinear, fade"
          ];

          bezier = [
            "almostLinear, 0.5, 0.5, 0.75, 1"
            "easeInOutCubic, 0.65, 0.05, 0.36, 1"
            "easeOutQuint, 0.23, 1, 0.32, 1"
            "linear, 0, 0, 1, 1"
            "quick, 0.15, 0, 0.1, 1"
          ];
        };

        bind = [
          "SUPER, 1, workspace, 1"
          "SUPER, 2, workspace, 2"
          "SUPER, 3, workspace, 3"
          "SUPER, 4, workspace, 4"
          "SUPER, 5, workspace, 5"
          "SUPER, 6, workspace, 6"
          "SUPER, 7, workspace, 7"
          "SUPER, 8, workspace, 8"
          "SUPER, 9, workspace, 9"

          "SUPER SHIFT, 1, movetoworkspace, 1"
          "SUPER SHIFT, 2, movetoworkspace, 2"
          "SUPER SHIFT, 3, movetoworkspace, 3"
          "SUPER SHIFT, 4, movetoworkspace, 4"
          "SUPER SHIFT, 5, movetoworkspace, 5"
          "SUPER SHIFT, 6, movetoworkspace, 6"
          "SUPER SHIFT, 7, movetoworkspace, 7"
          "SUPER SHIFT, 8, movetoworkspace, 8"
          "SUPER SHIFT, 9, movetoworkspace, 9"

          "SUPER, h, movefocus, l"
          "SUPER, j, movefocus, d"
          "SUPER, k, movefocus, u"
          "SUPER, l, movefocus, r"

          "SUPER SHIFT, h, movewindow, l"
          "SUPER SHIFT, j, movewindow, d"
          "SUPER SHIFT, k, movewindow, u"
          "SUPER SHIFT, l, movewindow, r"

          "SUPER SHIFT, q, killactive"
          "SUPER, RETURN, exec, kitty"
          "SUPER, SPACE, exec, wofi --show drun"
          "SUPER, f, fullscreen"
        ];

        general = {
          border_size = 2;
          "col.active_border" = lib.mkForce "rgb(00dbde) rgb(fc00ff) 45deg";
        };

        input = {
          kb_layout = config.console.keyMap;
          kb_options = "caps:escape";
          numlock_by_default = true;
          repeat_delay = 200;
        };
      };
    };
  };

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
    };
  };
}
