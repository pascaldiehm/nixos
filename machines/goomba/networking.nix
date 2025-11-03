{ config, ... }: {
  networking.firewall.allowedUDPPorts = [ 51820 ];

  sops.secrets = {
    "goomba/wireguard/key".owner = "systemd-network";
    "goomba/wireguard/bowser/psk".owner = "systemd-network";
    "goomba/wireguard/bowser/public".owner = "systemd-network";
    "goomba/wireguard/pascal-pc/psk".owner = "systemd-network";
    "goomba/wireguard/pascal-pc/public".owner = "systemd-network";
    "goomba/wireguard/pascal-laptop/psk".owner = "systemd-network";
    "goomba/wireguard/pascal-laptop/public".owner = "systemd-network";
  };

  systemd.network = {
    netdevs."50-wg-main" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-main";
      };

      wireguardConfig = {
        ListenPort = 51820;
        PrivateKeyFile = config.sops.secrets."goomba/wireguard/key".path;
      };

      wireguardPeers = [
        {
          AllowedIPs = [ "10.42.42.2/32" ];
          PresharedKeyFile = config.sops.secrets."goomba/wireguard/bowser/psk".path;
          PublicKeyFile = config.sops.secrets."goomba/wireguard/bowser/public".path;
        }

        {
          AllowedIPs = [ "10.42.42.90/32" ];
          PresharedKeyFile = config.sops.secrets."goomba/wireguard/pascal-pc/psk".path;
          PublicKeyFile = config.sops.secrets."goomba/wireguard/pascal-pc/public".path;
        }

        {
          AllowedIPs = [ "10.42.42.91/32" ];
          PresharedKeyFile = config.sops.secrets."goomba/wireguard/pascal-laptop/psk".path;
          PublicKeyFile = config.sops.secrets."goomba/wireguard/pascal-laptop/public".path;
        }
      ];
    };

    networks = {
      "10-wired" = {
        DHCP = "ipv4";
        address = [ "2a01:4f8:c0c:988b::1/64" ];
        gateway = [ "fe80::1" ];
        name = "eth0";
      };

      "50-wg-main" = {
        address = [ "10.42.42.1/24" ];
        name = "wg-main";
        networkConfig.IPv4Forwarding = true;
      };
    };
  };
}
