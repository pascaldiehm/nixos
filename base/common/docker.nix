{
  environment.persistence."/perm".directories = [ "/var/lib/docker" ];
  users.users.pascal.extraGroups = [ "docker" ];

  virtualisation.docker = {
    enable = true;
    daemon.settings.ip-forward-no-drop = true;
    logDriver = "local";

    autoPrune = {
      enable = true;
      flags = [ "--all" "--volumes" ];
    };
  };
}
