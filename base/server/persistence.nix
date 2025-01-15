{
  environment.persistence."/perm" = {
    users.pascal.directories = [ "docker" ];

    directories = [
      "/var/lib/docker"
      "/var/lib/fail2ban"
    ];

    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };
}
