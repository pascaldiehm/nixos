{
  networking.networkmanager.ensureProfiles.profiles.wired = {
    connection = {
      autoconnect-priority = 90;
      id = "wired";
      type = "ethernet";
    };

    ipv4 = {
      addresses = "192.168.1.90/16";
      dns = "1.1.1.1,1.0.0.1";
      gateway = "192.168.1.1";
      method = "manual";
    };
  };
}
