{ pkgs, ... }: {
  # Hostname
  networking.hostName = "pascal-pc";

  # Wired connection
  networking.networkmanager.ensureProfiles.profiles.wired = {
    connection = {
      id = "wired";
      type = "ethernet";
    };

    ipv4 = {
      address1 = "192.168.1.90/16,192.168.1.1";
      dns = "192.168.1.88";
      method = "manual";
    };
  };

  # Printer
  hardware.sane.enable = true;
  home-manager.users.pascal.home.packages = [ pkgs.system-config-printer pkgs.kdePackages.skanlite ];
  users.users.pascal.extraGroups = [ "scanner" "lp" ];

  services = {
    ipp-usb.enable = true;
    printing.enable = true;
  };
}
