{ config, lib, ... }: {
  sops.secrets = {
    "bowser/wireguard/key".owner = "systemd-network";
    "bowser/wireguard/goomba/psk".owner = "systemd-network";
    "bowser/wireguard/goomba/public".owner = "systemd-network";
  };

  systemd.network = {
    netdevs."50-wg-main" = {
      wireguardConfig.PrivateKeyFile = config.sops.secrets."bowser/wireguard/key".path;

      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-main";
      };

      wireguardPeers = lib.singleton {
        AllowedIPs = [ "10.42.42.0/24" ];
        Endpoint = "goomba.wan:51820";
        PersistentKeepalive = 25;
        PresharedKeyFile = config.sops.secrets."bowser/wireguard/goomba/psk".path;
        PublicKeyFile = config.sops.secrets."bowser/wireguard/goomba/public".path;
      };
    };

    networks = {
      "10-wired" = {
        address = [ "192.168.1.88/16" ];
        dns = [ "1.1.1.1" "1.0.0.1" ];
        gateway = [ "192.168.1.1" ];
        name = "eth0";
      };

      "50-wg-main" = {
        address = [ "10.42.42.2/24" ];
        name = "wg-main";
      };
    };
  };
}
