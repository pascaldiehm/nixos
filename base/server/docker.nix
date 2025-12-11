{
  environment.persistence."/perm" = {
    directories = [ "/var/lib/docker" ];
    users.pascal.directories = [ "docker" ];
  };

  services.backup."/var/lib/docker/volumes" = {
    excludeRegex = [ "[0-9a-f]{64}" ];
    include = [ "*/" ];
  };

  virtualisation.docker.autoPrune = {
    enable = true;
    flags = [ "--all" "--volumes" ];
  };
}
