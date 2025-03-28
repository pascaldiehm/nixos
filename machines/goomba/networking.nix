{ config, ... }: {
  networking.firewall.allowedUDPPorts = [ 51820 ];

  sops.secrets = {
    "goomba/wireguard/key".owner = "systemd-network";
    "goomba/wireguard/bowser/psk".owner = "systemd-network";
    "goomba/wireguard/bowser/public".owner = "systemd-network";
    "goomba/wireguard/pascal-laptop/psk".owner = "systemd-network";
    "goomba/wireguard/pascal-laptop/public".owner = "systemd-network";
    "goomba/wireguard/pascal-phone/psk".owner = "systemd-network";
    "goomba/wireguard/pascal-phone/public".owner = "systemd-network";
  };

  systemd.network = {
    netdevs."50-wireguard" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };

      wireguardConfig = {
        ListenPort = 51820;
        PrivateKeyFile = config.sops.secrets."goomba/wireguard/key".path;
        RouteTable = "main";
      };

      wireguardPeers = [
        {
          AllowedIPs = [ "10.42.0.2/32" "192.168.0.0/16" ];
          PresharedKeyFile = config.sops.secrets."goomba/wireguard/bowser/psk".path;
          PublicKeyFile = config.sops.secrets."goomba/wireguard/bowser/public".path;
        }

        {
          AllowedIPs = [ "10.42.0.3/32" ];
          PresharedKeyFile = config.sops.secrets."goomba/wireguard/pascal-laptop/psk".path;
          PublicKeyFile = config.sops.secrets."goomba/wireguard/pascal-laptop/public".path;
        }

        {
          AllowedIPs = [ "10.42.0.4/32" ];
          PresharedKeyFile = config.sops.secrets."goomba/wireguard/pascal-phone/psk".path;
          PublicKeyFile = config.sops.secrets."goomba/wireguard/pascal-phone/public".path;
        }
      ];
    };

    networks = {
      "99-wired-dhcp".linkConfig.RequiredForOnline = "routable";

      "50-wireguard" = {
        address = [ "10.42.0.1/24" ];
        matchConfig.Name = "wg0";
        networkConfig.IPv4Forwarding = true;
      };
    };
  };
}
