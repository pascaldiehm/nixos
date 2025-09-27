{
  environment.persistence."/perm".directories = [ "/var/lib/fail2ban" ];

  services.fail2ban = {
    enable = true;
    bantime = "1m";
    bantime-increment.enable = true;
  };
}
