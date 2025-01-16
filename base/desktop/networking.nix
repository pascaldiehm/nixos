{ config, ... }: {
  sops.secrets.network.restartUnits = [ "NetworkManager.service" "NetworkManager-ensure-profiles.service" ];
  users.users.pascal.extraGroups = [ "networkmanager" ];

  networking = {
    firewall = {
      allowedTCPPorts = [ 1234 1716 1739 1740 1741 ];
      allowedUDPPorts = [ 1719 ];
    };

    networkmanager = {
      enable = true;
      ensureProfiles.environmentFiles = [ config.sops.secrets.network.path ];
    };
  };
}
