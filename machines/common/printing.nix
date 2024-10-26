{ pkgs, ... }: {
  hardware.sane.enable = true;
  home-manager.users.pascal.home.packages = [ pkgs.kdePackages.skanlite pkgs.system-config-printer ];
  users.users.pascal.extraGroups = [ "lp" "scanner" ];

  services = {
    ipp-usb.enable = true;
    printing.enable = true;
  };
}
