{
  environment.persistence."/perm".directories = [ "/var/lib/docker" ];

  virtualisation.docker.autoPrune = {
    enable = true;
    flags = [ "--all" "--volumes" ];
  };
}
