{
  security.sudo.wheelNeedsPassword = false;
  services.fail2ban.enable = true;

  environment.persistence."/perm" = {
    directories = [ "/var/lib/fail2ban" ];
    users.pascal.directories = [ "docker" ];
  };
}
