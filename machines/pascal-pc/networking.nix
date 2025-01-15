{
  networking.networkmanager.ensureProfiles.profiles.wired = {
    connection = {
      autoconnect-priority = 90;
      id = "Wired connection";
      type = "ethernet";
    };

    ipv4 = {
      address1 = "192.168.1.90/16,192.168.1.1";
      method = "manual";
    };
  };
}
