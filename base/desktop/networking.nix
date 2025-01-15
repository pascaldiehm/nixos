{ config, ... }:
{
  users.users.pascal.extraGroups = [ "networkmanager" ];

  networking = {
    firewall = {
      allowedUDPPorts = [ 1719 ];

      allowedTCPPorts = [
        1234
        1716
        1739
        1740
        1741
      ];
    };

    networkmanager = {
      enable = true;
      ensureProfiles.environmentFiles = [ config.sops.secrets.network.path ];
    };
  };

  sops.secrets.network.restartUnits = [
    "NetworkManager.service"
    "NetworkManager-ensure-profiles.service"
  ];
}
