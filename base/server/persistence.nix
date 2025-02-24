{
  environment.persistence."/perm" = {
    directories = [ "/etc/ssh" "/var/lib/docker" "/var/lib/fail2ban" ];
    users.pascal.directories = [ "docker" ];
  };
}
