{
  networking.networkmanager.ensureProfiles.profiles = {
    wg-main = {
      wireguard.private-key = "$WIREGUARD_PASCAL_PC_KEY";

      connection = {
        autoconnect-priority = 100;
        id = "@main";
        interface-name = "wg-main";
        type = "wireguard";
      };

      ipv4 = {
        addresses = "10.42.42.90/24";
        method = "manual";
      };

      "wireguard-peer.$WIREGUARD_GOOMBA_PUBLIC" = {
        allowed-ips = "10.42.42.0/24";
        endpoint = "goomba.wan:51820";
        preshared-key = "$WIREGUARD_PASCAL_PC_PSK";
        preshared-key-flags = 0;
      };
    };

    wired = {
      connection = {
        autoconnect-priority = 100;
        id = "wired";
        type = "ethernet";
      };

      ipv4 = {
        addresses = "192.168.1.90/16";
        dns = "1.1.1.1;1.0.0.1";
        gateway = "192.168.1.1";
        method = "manual";
      };
    };
  };
}
