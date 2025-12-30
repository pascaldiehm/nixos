{ config, lib, pkgs, ... }: {
  sops.common.nut = { };

  home-manager.users.pascal.programs.waybar.settings.bar = {
    modules-right = lib.mkForce [ "network" "wireplumber" "custom/ups" "clock" ];

    "custom/ups" = {
      exec = lib.readFile ../../resources/scripts/waybar-ups.sh |> pkgs.writeShellScript "waybar-ups";
      format = "{icon} {percentage}%";
      hide-empty-text = true;
      interval = 1;
      return-type = "json";

      format-icons = {
        charging = "󰂄";
        discharging = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        full = "󱟢";
      };
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
      upsmon = "primary";
    };
  };
}
