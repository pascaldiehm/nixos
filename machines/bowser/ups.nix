{ config, libx, ... }:
{
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
        NOTIFYCMD = "${libx.mkNtfy "ups" "$1"}";

        NOTIFYFLAG =
          builtins.map
            (event: [
              event
              "SYSLOG+EXEC"
            ])
            [
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

  sops.secrets."bowser/nut".restartUnits = [
    "upsd.service"
    "upsmon.service"
  ];
}
