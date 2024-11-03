{ ... }: {
  users.users.pascal.extraGroups = [ "docker" ];
  virtualisation.docker.enable = true;
}
