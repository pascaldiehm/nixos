{
  environment.persistence."/perm" = {
    directories = [ "/var/lib/docker" "/var/lib/fail2ban" ];
    users.pascal.directories = [ "docker" ];

    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };
}
