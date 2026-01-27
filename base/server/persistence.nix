{
  environment.persistence."/perm".users.pascal.directories = [ "docker" ];

  services.backup = {
    postStart = "systemctl start docker.service docker.socket";
    preStart = "systemctl stop docker.service docker.socket";

    targets = {
      "/home/pascal/docker".include = [ "**/.env" ];

      "/var/lib/docker/volumes" = {
        excludeRegex = [ "[0-9a-f]{64}" ];
        include = [ "*/" ];
      };
    };
  };
}
