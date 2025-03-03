{
  environment.persistence."/perm" = {
    directories = [ "/etc/ssh" "/var/lib/fail2ban" ];
    users.pascal.directories = [ "docker" ];
  };
}
