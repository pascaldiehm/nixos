{ config, helpers, ... }: {
  boot.swraid = {
    enable = true;

    mdadmConf = ''
      PROGRAM ${helpers.ntfy "raid" "$1: $2\${3:+ ($3)}"}
      ARRAY /dev/md/0 metadata=1.2 name=bowser:0 UUID=d56224b5:9d97fe09:73ab00f5:631ed84c
    '';
  };

  fileSystems."/home/pascal/archive" = {
    device = "/dev/md/0";
    fsType = "ext4";
  };

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
        NOTIFYCMD = "${helpers.ntfy "ups" "$1"}";

        NOTIFYFLAG = [
          [ "ONLINE" "SYSLOG+EXEC" ]
          [ "ONBATT" "SYSLOG+EXEC" ]
          [ "LOWBATT" "SYSLOG+EXEC" ]
          [ "FSD" "SYSLOG+EXEC" ]
          [ "SHUTDOWN" "SYSLOG+EXEC" ]
          [ "REPLBATT" "SYSLOG+EXEC" ]
          [ "NOCOMM" "SYSLOG+EXEC" ]
          [ "NOPARENT" "SYSLOG+EXEC" ]
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

  sops.secrets = {
    "bowser/nut".restartUnits = [ "upsd.service" "upsmon.service" ];
    "bowser/wireguard/key".owner = "systemd-network";
    "bowser/wireguard/goomba".owner = "systemd-network";
  };

  systemd.network = {
    netdevs."50-wg" = {
      wireguardConfig.PrivateKeyFile = config.sops.secrets."bowser/wireguard/key".path;

      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };

      wireguardPeers = [{
        AllowedIPs = [ "10.42.0.0/24" ];
        Endpoint = "goomba:51820";
        PersistentKeepalive = 25;
        PresharedKeyFile = config.sops.secrets."bowser/wireguard/goomba".path;
        PublicKey = "8TEjIXVJSJryKAeB2L3BTZjaiQZ77KVoaIpdceEZoGg=";
      }];
    };

    networks = {
      "10-wired" = {
        address = [ "192.168.1.88/16" ];
        gateway = [ "192.168.1.1" ];
        linkConfig.RequiredForOnline = "routable";
        matchConfig.Name = "eth0";
      };

      "50-wg" = {
        address = [ "10.42.0.2/24" ];
        matchConfig.Name = "wg0";
        networkConfig.IPMasquerade = "ipv4";
      };
    };
  };
}
