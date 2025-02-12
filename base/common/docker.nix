{
  users.users.pascal.extraGroups = [ "docker" ];

  virtualisation.docker = {
    enable = true;
    daemon.settings.log-driver = "local";
  };
}
