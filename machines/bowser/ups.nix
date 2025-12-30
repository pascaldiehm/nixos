{ config, lib, pkgs, ... }: {
  sops.common.nut = { };

  power.ups = {
    enable = true;
    mode = "netserver";
    openFirewall = true;
    upsd.listen = [ { address = "0.0.0.0"; } { address = "::"; } ];

    ups = {
      ext = {
        description = "External UPS";
        directives = [ "bus = 001" "busport = 003" ];
        driver = "usbhid-ups";
        port = "auto";
      };

      int = {
        description = "Internal UPS";
        directives = [ "bus = 001" "busport = 004" ];
        driver = "usbhid-ups";
        port = "auto";
      };
    };

    upsmon = {
      monitor = {
        ext = {
          powerValue = 0;
          type = "primary";
          user = "pascal";
        };

        int = {
          type = "primary";
          user = "pascal";
        };
      };

      settings = {
        NOTIFYCMD = "${pkgs.writeShellScript "ntfy-ups" ''${lib.getExe pkgs.scripts.ntfy} ups "$1"''}";
        NOTIFYFLAG = lib.map (event: [ event "SYSLOG+EXEC" ]) [ "ONLINE" "ONBATT" "LOWBATT" "FSD" "SHUTDOWN" "REPLBATT" ];
      };
    };

    users.pascal = {
      actions = [ "SET" ];
      instcmds = [ "ALL" ];
      passwordFile = config.sops.common.nut.path;
      upsmon = "primary";
    };
  };
}
