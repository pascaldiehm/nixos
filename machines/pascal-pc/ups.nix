{ config, lib, pkgs, ... }: {
  sops.common.nut = { };

  home-manager.users.pascal = {
    programs.waybar.settings.bar = {
      modules-right = lib.mkForce [ "network" "wireplumber" "custom/ups" "clock" ];

      "custom/ups" = {
        exec = "cat /run/user/1000/upsmon";
        format = "{icon} {percentage}%";
        interval = 1;
        return-type = "json";

        format-icons = {
          charging = "󰂄";
          discharging = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          error = "󱟨";
          full = "󱟢";
        };
      };
    };

    systemd.user.services.upsmon = {
      Install.WantedBy = [ "default.target" ];
      Service.ExecStart = lib.readFile ../../resources/scripts/upsmon.sh |> pkgs.writeShellScript "upsmon";
      Unit.Description = "Monitor UPS";
    };
  };

  power.ups = {
    enable = true;
    mode = "netclient";

    upsmon.monitor.ups = {
      system = "ext@bowser";
      type = "secondary";
      user = "pascal";
    };

    users.pascal = {
      actions = [ "SET" ];
      instcmds = [ "ALL" ];
      passwordFile = config.sops.common.nut.path;
      upsmon = "secondary";
    };
  };
}
