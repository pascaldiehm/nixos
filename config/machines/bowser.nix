{ config, pkgs, ... }: {
  boot.swraid = {
    enable = true;

    mdadmConf = ''
      PROGRAM ${pkgs.curl}/bin/curl -s -H "Authorization: Bearer $(cat ${config.sops.secrets.ntfy.path})" -d 'A RAID drive has failed' 'https://ntfy.pdiehm.dev/bowser-raid'
      ARRAY /dev/md/0 metadata=1.2 name=bowser:0 UUID=d56224b5:9d97fe09:73ab00f5:631ed84c
    '';
  };

  fileSystems."/home/pascal/archive" = {
    device = "/dev/md/0";
    fsType = "ext4";
  };

  sops.secrets = {
    "wireguard/bowser/key".owner = "systemd-network";
    "wireguard/bowser/goomba".owner = "systemd-network";
  };

  systemd.network = {
    netdevs."50-wg" = {
      wireguardConfig.PrivateKeyFile = config.sops.secrets."wireguard/bowser/key".path;

      netdevConfig = {
        Kind = "wireguard";
        Name = "wg";
      };

      wireguardPeers = [{
        AllowedIPs = [ "10.42.0.0/24" ];
        Endpoint = "116.203.102.96:51820";
        PersistentKeepalive = 25;
        PresharedKeyFile = config.sops.secrets."wireguard/bowser/goomba".path;
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
        matchConfig.Name = "wg";
        networkConfig.IPMasquerade = "ipv4";
      };
    };
  };
}
