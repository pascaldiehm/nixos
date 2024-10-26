{ pkgs, helpers, ... }: {
  # Modules
  imports = [
    ./common/3d-printing.nix
    ./common/media.nix
    ./common/printing.nix
  ];

  # Set hostname
  networking.hostName = "pascal-pc";

  # Add network connection
  networking.networkmanager.ensureProfiles.profiles.wired = {
    connection = {
      id = "Wired connection";
      type = "ethernet";
    };

    ipv4 = {
      address1 = "192.168.1.90/16,192.168.1.1";
      dns = "192.168.1.88";
      method = "manual";
    };
  };

  # Disable auto-mute
  systemd.services.disableAutoMute = {
    after = [ "sound.target" ];
    description = "Disable auto-mute";
    script = "${pkgs.alsa-utils}/bin/amixer -c 2 sset 'Auto-Mute Mode' Disabled";
    wantedBy = [ "multi-user.target" ];
  };
}
