{ config, lib, pkgs, ... }: {
  sops.secrets."bowser/nut".restartUnits = [ "upsd.service" "upsmon.service" ];

  power.ups = {
    enable = true;

    ups.ups = {
      description = "Main UPS";
      driver = "usbhid-ups";
      port = "auto";
    };

    upsmon = {
      monitor.ups = {
        type = "primary";
        user = "pascal";
      };

      settings = {
        NOTIFYCMD = "${lib.getExe pkgs.scripts.ntfy} ups";

        NOTIFYFLAG = builtins.map (event: [ event "SYSLOG+EXEC" ]) [
          "ONLINE"
          "ONBATT"
          "LOWBATT"
          "FSD"
          "SHUTDOWN"
          "REPLBATT"
          "NOCOMM"
          "NOPARENT"
        ];
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
