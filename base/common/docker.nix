{
  users.users.pascal.extraGroups = [ "docker" ];

  virtualisation.docker = {
    enable = true;

    autoPrune = {
      enable = true;
      flags = [ "--all" ];
    };
  };
}
