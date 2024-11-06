{ pkgs, helpers, ... }: {
  home-manager.users.pascal.home.packages = [ pkgs.krita pkgs.prismlauncher ];

  imports = [
    ./common/3d-printing.nix
    ./common/disable-auto-mute.nix
    ./common/printing.nix
  ];

  networking = {
    hostName = "pascal-pc";

    networkmanager.ensureProfiles.profiles.wired = {
      connection = {
        autoconnect-priority = 90;
        id = "Wired connection";
        type = "ethernet";
      };

      ipv4 = {
        address1 = "192.168.1.90/16,192.168.1.1";
        dns = "192.168.1.88";
        method = "manual";
      };
    };
  };
}
