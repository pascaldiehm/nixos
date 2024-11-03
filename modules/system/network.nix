{ config, ... }: {
  sops.secrets.network = { };
  users.users.pascal.extraGroups = [ "networkmanager" ];

  networking = {
    firewall.allowedTCPPorts = [ 1234 ];

    networkmanager = {
      enable = true;
      ensureProfiles.environmentFiles = [ config.sops.secrets.network.path ];
    };
  };
}
