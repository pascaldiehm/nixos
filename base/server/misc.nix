{
  environment.persistence."/perm".directories = [ "/var/lib/fail2ban" ];
  security.sudo.wheelNeedsPassword = false;
  services.fail2ban.enable = true;
}
