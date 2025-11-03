{
  environment.persistence."/perm".users.pascal.directories = [ "docker" ];
  security.sudo.wheelNeedsPassword = false;

  services.fail2ban = {
    enable = true;
    bantime = "1m";
    bantime-increment.enable = true;
  };
}
