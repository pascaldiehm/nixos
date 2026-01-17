{
  environment.persistence."/perm".users.pascal.directories = [ "docker" ];

  services.backup = {
    "/home/pascal/docker".include = [ "**/.env" ];

    "/var/lib/docker/volumes" = {
      excludeRegex = [ "[0-9a-f]{64}" ];
      include = [ "*/" ];
    };
  };
}
