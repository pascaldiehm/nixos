{ config, ... }: {
  users.users.pascal.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGOcME9MFgLx87iigjoZHIodQs2Rre39SflSRCfnpFZs pascal" ];

  sops.secrets = {
    "wireguard/goomba/key".owner = "systemd-network";
    "wireguard/goomba/bowser".owner = "systemd-network";
    "wireguard/goomba/pascal-laptop".owner = "systemd-network";
    "wireguard/goomba/pascal-phone".owner = "systemd-network";
  };

  systemd.network = {
    netdevs."50-wg" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg";
      };

      wireguardConfig = {
        ListenPort = 51820;
        PrivateKeyFile = config.sops.secrets."wireguard/goomba/key".path;
      };

      wireguardPeers = [
        {
          AllowedIPs = [ "10.42.0.2/32" "192.168.0.0/24" ];
          PresharedKeyFile = config.sops.secrets."wireguard/goomba/bowser".path;
          PublicKey = "DGhb5LNEW6X+WhVhzkuUi3wpyYuDDDNq1TQDze4cCTk=";
        }

        {
          AllowedIPs = [ "10.42.0.3/32" ];
          PresharedKeyFile = config.sops.secrets."wireguard/goomba/pascal-laptop".path;
          PublicKey = "NcWpXbnJs4bn9QvhIvCfM/9ocp1JYKSL4DLxDskhIRg=";
        }

        {
          AllowedIPs = [ "10.42.0.4/32" ];
          PresharedKeyFile = config.sops.secrets."wireguard/goomba/pascal-phone".path;
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
