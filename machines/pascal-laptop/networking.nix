{
  # TODO: Setup WireGuard network
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
  };
}
