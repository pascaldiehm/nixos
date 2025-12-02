{
  sops.secrets = {
    "bowser/wireguard/key".owner = "systemd-network";
    "bowser/wireguard/goomba/psk".owner = "systemd-network";
    "bowser/wireguard/goomba/public".owner = "systemd-network";
  };

  # TODO: Setup WireGuard network
  systemd.network.networks.wired = {
    address = [ "192.168.1.88/16" ];
    gateway = [ "192.168.1.1" ];
    name = "eth0";
  };
}
