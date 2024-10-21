{ config, ... }: {
  # Setup network secrets
  sops.secrets.network = {};

  # Setup NetworkManager
  networking.networkmanager = {
    enable = true;
    ensureProfiles.environmentFiles = [ config.sops.secrets.network.path ];
  };

  # Add user to networkmanager group
  users.users.pascal.extraGroups = [ "networkmanager" ];

  # Setup firewall
  networking.firewall.allowedTCPPorts = [ 1234 ];
}
