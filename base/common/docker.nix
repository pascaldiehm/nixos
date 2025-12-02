{
  users.users.pascal.extraGroups = [ "docker" ];

  virtualisation.docker = {
    enable = true;
    daemon.settings.ip-forward-no-drop = true;
    logDriver = "local";
  };
}
