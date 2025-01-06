{ pkgs, ... }: {
  hardware.graphics.extraPackages = [ pkgs.rocmPackages.clr.icd ];

  networking.networkmanager.ensureProfiles.profiles = {
    home = {
      wireguard.private-key = "$WIREGUARD_PASCAL_LAPTOP_KEY";

      connection = {
        autoconnect = false;
        id = "Home";
        interface-name = "wg0";
        type = "wireguard";
      };

      ipv4 = {
        address1 = "10.42.0.3/24";
        method = "manual";
      };

      "wireguard-peer.8TEjIXVJSJryKAeB2L3BTZjaiQZ77KVoaIpdceEZoGg=" = {
        allowed-ips = "10.42.0.0/24;192.168.0.0/16";
        endpoint = "$WIREGUARD_ENDPOINT";
        preshared-key = "$WIREGUARD_PASCAL_LAPTOP_PSK";
        preshared-key-flags = 0;
      };
    };

    home-wifi = {
      connection = {
        autoconnect-priority = 50;
        id = "Home WiFi";
        type = "wifi";
      };

      ipv4 = {
        address1 = "192.168.1.91/16,192.168.1.1";
        dns = "192.168.1.88";
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
        id = "Hotspot";
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
