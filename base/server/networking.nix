{
  networking.usePredictableInterfaceNames = false;

  systemd.network = {
    enable = true;

    networks."99-wired-dhcp" = {
      DHCP = "ipv4";

      matchConfig = {
        Kind = "!*";
        Type = "ether";
      };
    };
  };
}
