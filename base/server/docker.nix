{
  environment.persistence."/perm" = {
    directories = [ "/var/lib/docker" ];
    users.pascal.directories = [ "docker" ];
  };

  virtualisation.docker.autoPrune = {
    enable = true;
    flags = [ "--all" "--volumes" ];
  };
}
