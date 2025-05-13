{
  environment.persistence."/perm" = {
    directories = [ "/var/lib/docker" "/var/lib/fail2ban" ];
    users.pascal.directories = [ "docker" ];
  };
}
