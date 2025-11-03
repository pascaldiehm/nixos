{
  environment.persistence."/perm".directories = [ "/var/lib/docker" ];
  services.duplicity.include = [ "/var/lib/docker/volumes" ];

  virtualisation.docker.autoPrune = {
    enable = true;
    flags = [ "--all" "--volumes" ];
  };
}
