{ ... }: {
  # Set hostname
  networking.hostName = "pascal-laptop";

  # Add network connection
  networking.networkmanager.ensureProfiles.profiles.home-wifi = {
    connection = {
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
}
