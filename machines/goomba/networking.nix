{
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

  # TODO: Setup WireGuard network
  systemd.network.networks.wired = {
    DHCP = "ipv4";
    address = [ "2a01:4f8:c0c:988b::1/64" ];
    gateway = [ "fe80::1" ];
    name = "eth0";
  };
}
