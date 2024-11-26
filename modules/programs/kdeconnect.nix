{ pkgs, ... }: {
  home-manager.users.pascal.home.packages = [ pkgs.kdePackages.kdeconnect-kde ];

  networking = {
    firewall = {
      allowedTCPPorts = [ 1716 1739 1740 1741 ];
      allowedUDPPorts = [ 1716 ];
    };
  };
}
