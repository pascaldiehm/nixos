{
  environment.persistence."/perm" = {
    directories = [ "/var/lib/fail2ban" ];
    users.pascal.directories = [ "docker" ];
  };
}
