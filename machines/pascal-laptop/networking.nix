{
  networking.networkmanager.ensureProfiles.profiles = {
    home-wifi = {
      connection = {
        autoconnect-priority = 50;
        id = "home-wifi";
        type = "wifi";
      };

      ipv4 = {
        addresses = "192.168.1.91/16";
        dns = "1.1.1.1;1.0.0.1";
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

    wg-main = {
      wireguard.private-key = "$WIREGUARD_PASCAL_LAPTOP_KEY";

      connection = {
        autoconnect-priority = 100;
        id = "@main";
        interface-name = "wg-main";
        type = "wireguard";
      };

      ipv4 = {
        addresses = "10.42.42.91/24";
        method = "manual";
      };

      "wireguard-peer.$WIREGUARD_GOOMBA_PUBLIC" = {
        allowed-ips = "10.42.42.0/24";
        endpoint = "goomba.wan:51820";
        preshared-key = "$WIREGUARD_PASCAL_LAPTOP_PSK";
        preshared-key-flags = 0;
      };
    };
  };
}
