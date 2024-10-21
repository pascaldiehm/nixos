{ ... }: {
  # Enable NetworkManager
  networking.networkmanager.enable = true;

  # Add user to networkmanager group
  users.users.pascal.extraGroups = [ "networkmanager" ];

  # Setup firewall
  networking.firewall.allowedTCPPorts = [ 1234 ];
}
