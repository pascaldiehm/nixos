{
  users.users.pascal.extraGroups = [ "docker" ];
  systemd.timers.docker-prune.timerConfig.Persistent = true;

  virtualisation.docker = {
    enable = true;
    logDriver = "local";

    autoPrune = {
      enable = true;
      flags = [ "--all" ];
    };
  };
}
