{
  security.sudo.wheelNeedsPassword = false;
  services.fail2ban.enable = true;

  virtualisation.docker.autoPrune = {
    enable = true;
    flags = [ "--all" "--volumes" ];
  };
}
