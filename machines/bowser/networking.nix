{ config, lib, ... }: {
  services.resolved.extraConfig = "DNSStubListener=no";

  sops.secrets = {
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

      wireguardPeers = lib.singleton {
        AllowedIPs = [ "10.42.0.0/24" ];
        Endpoint = "goomba:51820";
        PersistentKeepalive = 25;
        PresharedKeyFile = config.sops.secrets."bowser/wireguard/goomba".path;
        PublicKey = "8TEjIXVJSJryKAeB2L3BTZjaiQZ77KVoaIpdceEZoGg=";
      };
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
