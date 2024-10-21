{ ... }: {
  # Setup Docker
  virtualisation.docker = {
    enable = true;

    autoPrune = {
      enable = true;
      flags = [ "--all" ];
    };
  };

  # Add user to docker group
  users.users.pascal.extraGroups = [ "docker" ];
}
