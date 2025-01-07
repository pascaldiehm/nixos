{ config, ... }: {
  sops.secrets = {
    "goomba/wireguard/key".owner = "systemd-network";
    "goomba/wireguard/bowser".owner = "systemd-network";
    "goomba/wireguard/pascal-laptop".owner = "systemd-network";
    "goomba/wireguard/pascal-phone".owner = "systemd-network";
  };

  systemd.network = {
    netdevs."50-wg" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg";
      };

      wireguardConfig = {
        ListenPort = 51820;
        PrivateKeyFile = config.sops.secrets."goomba/wireguard/key".path;
      };

      wireguardPeers = [
        {
          AllowedIPs = [ "10.42.0.2/32" "192.168.0.0/24" ];
          PresharedKeyFile = config.sops.secrets."goomba/wireguard/bowser".path;
          PublicKey = "DGhb5LNEW6X+WhVhzkuUi3wpyYuDDDNq1TQDze4cCTk=";
        }

        {
          AllowedIPs = [ "10.42.0.3/32" ];
          PresharedKeyFile = config.sops.secrets."goomba/wireguard/pascal-laptop".path;
          PublicKey = "NcWpXbnJs4bn9QvhIvCfM/9ocp1JYKSL4DLxDskhIRg=";
        }

        {
          AllowedIPs = [ "10.42.0.4/32" ];
          PresharedKeyFile = config.sops.secrets."goomba/wireguard/pascal-phone".path;
          PublicKey = "dYBJTDmUJCEMB6apLXdgktkRkQrtUvi7up5SFismomI=";
        }
      ];
    };

    networks."50-wg" = {
      address = [ "10.42.0.1/24" ];
      matchConfig.Name = "wg";
      networkConfig.IPv4Forwarding = true;
    };
  };
}
