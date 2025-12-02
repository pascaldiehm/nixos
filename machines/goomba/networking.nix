{ config, lib, ... }: {
  networking.firewall.allowedUDPPorts = [ 51820 ];

  sops.secrets = {
    "goomba/wireguard/key".owner = "systemd-network";
    "goomba/wireguard/bowser/psk".owner = "systemd-network";
    "goomba/wireguard/bowser/public".owner = "systemd-network";
    "goomba/wireguard/pascal-laptop/psk".owner = "systemd-network";
    "goomba/wireguard/pascal-laptop/public".owner = "systemd-network";
    "goomba/wireguard/pascal-pc/psk".owner = "systemd-network";
    "goomba/wireguard/pascal-pc/public".owner = "systemd-network";
  };

  systemd.network = {
    config.networkConfig.IPv6Forwarding = true;

    netdevs.wg-main = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-main";
      };

      wireguardConfig = {
        ListenPort = 51820;
        PrivateKeyFile = config.sops.secrets."goomba/wireguard/key".path;
      };

      wireguardPeers = {
        bowser = [ "fd42:5041:5343:414c::2/128" ];
        pascal-pc = [ "fd42:5041:5343:414c::1001/128" ];
        pascal-laptop = [ "fd42:5041:5343:414c::1002/128" ];
      }
      |> lib.mapAttrsToList (
        name: AllowedIPs: {
          inherit AllowedIPs;
          PresharedKeyFile = config.sops.secrets."goomba/wireguard/${name}/psk".path;
          PublicKeyFile = config.sops.secrets."goomba/wireguard/${name}/public".path;
        }
      );
    };

    networks = {
      wg-main = {
        address = [ "fd42:5041:5343:414c::1/112" ];
        name = "wg-main";
        networkConfig.IPv6Forwarding = true;
      };

      wired = {
        DHCP = "ipv4";
        address = [ "2a01:4f8:c0c:988b::1/64" ];
        gateway = [ "fe80::1" ];
        name = "eth0";
      };
    };
  };
}
