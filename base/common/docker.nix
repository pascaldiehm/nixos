{
  users.users.pascal.extraGroups = [ "docker" ];

  virtualisation.docker = {
    enable = true;
    logDriver = "local";

    autoPrune = {
      enable = true;
      flags = [ "--all" ];
    };
  };
}
