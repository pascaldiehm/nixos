{ config, lib, pkgs, ... }: {
  sops.secrets."bowser/nut".restartUnits = [ "upsd.service" "upsmon.service" ];

  power.ups = {
    enable = true;

    ups.ups = {
      driver = "usbhid-ups";
      port = "auto";
    };

    upsmon = {
      monitor.ups = {
        type = "primary";
        user = "pascal";
      };

      settings = {
        NOTIFYCMD = "${pkgs.writeShellScript "ntfy-ups" "${lib.getExe pkgs.scripts.ntfy} ups \"$1\""}";
        NOTIFYFLAG = lib.map (event: [ event "SYSLOG+EXEC" ]) [ "ONLINE" "ONBATT" "LOWBATT" "FSD" "SHUTDOWN" "REPLBATT" ];
      };
    };

    users.pascal = {
      actions = [ "SET" ];
      instcmds = [ "ALL" ];
      passwordFile = config.sops.secrets."bowser/nut".path;
      upsmon = "primary";
    };
  };
}
