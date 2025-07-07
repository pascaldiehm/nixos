{
  networking.networkmanager.ensureProfiles.profiles = {
    home = {
      wireguard.private-key = "$WIREGUARD_PASCAL_LAPTOP_KEY";

      connection = {
        autoconnect = false;
        id = "@home";
        interface-name = "wg-home";
        type = "wireguard";
      };

      ipv4 = {
        addresses = "192.168.16.3/24";
        method = "manual";
      };

      "wireguard-peer.$WIREGUARD_GOOMBA_PUBLIC_KEY" = {
        allowed-ips = "192.168.0.0/16";
        endpoint = "goomba:51820";
        preshared-key = "$WIREGUARD_PASCAL_LAPTOP_PSK";
        preshared-key-flags = 0;
      };
    };

    home-wifi = {
      connection = {
        autoconnect-priority = 50;
        id = "home-wifi";
        type = "wifi";
      };

      ipv4 = {
        addresses = "192.168.1.91/16";
        dns = "192.168.1.88";
        gateway = "192.168.1.1";
        method = "manual";
      };

      wifi = {
        mode = "infrastructure";
        ssid = "$HOME_WIFI_SSID";
      };

      wifi-security = {
        key-mgmt = "wpa-psk";
        psk = "$HOME_WIFI_PSK";
      };
    };

    hotspot = {
      connection = {
        autoconnect-priority = 25;
        id = "hotspot";
        type = "wifi";
      };

      wifi = {
        mode = "infrastructure";
        ssid = "$HOTSPOT_SSID";
      };

      wifi-security = {
        key-mgmt = "wpa-psk";
        psk = "$HOTSPOT_PSK";
      };
    };
  };
}
