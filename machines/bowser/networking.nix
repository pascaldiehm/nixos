{ config, lib, ... }: {
  sops.secrets = {
    "bowser/wireguard/key".owner = "systemd-network";
    "bowser/wireguard/goomba/psk".owner = "systemd-network";
    "bowser/wireguard/goomba/public".owner = "systemd-network";
  };

  systemd.network = {
    netdevs."50-wireguard" = {
      wireguardConfig.PrivateKeyFile = config.sops.secrets."bowser/wireguard/key".path;

      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };

      wireguardPeers = lib.singleton {
        AllowedIPs = [ "192.168.16.0/24" ];
        Endpoint = "goomba:51820";
        PersistentKeepalive = 25;
        PresharedKeyFile = config.sops.secrets."bowser/wireguard/goomba/psk".path;
        PublicKeyFile = config.sops.secrets."bowser/wireguard/goomba/public".path;
      };
    };

    networks = {
      "10-wired" = {
        address = [ "192.168.1.88/16" ];
        gateway = [ "192.168.1.1" ];
        matchConfig.Name = "eth0";
      };

      "50-wireguard" = {
        address = [ "192.168.16.2/24" ];
        matchConfig.Name = "wg0";
        networkConfig.IPMasquerade = "ipv4";
      };
    };
  };
}
