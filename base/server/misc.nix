{
  environment.persistence."/perm".users.pascal.directories = [ "docker" ];
  networking.usePredictableInterfaceNames = false;
  security.sudo.wheelNeedsPassword = false;
  systemd.network.enable = true;

  services.fail2ban = {
    enable = true;
    bantime = "1m";
    bantime-increment.enable = true;
  };
}
