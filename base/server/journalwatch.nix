{
  libx,
  system,
  ...
}:
{
  sops.secrets."${system.name}/ntfy".restartUnits = [ "journalwatch.service" ];

  systemd.services.journalwatch = {
    after = [ "network-online.target" ];
    description = "Watch journalctl and report security-relevant events to ntfy";
    environment.NTFY_CMD = "${libx.mkNtfy "journal" "$1"}";
    script = builtins.readFile ../../resources/scripts/journalwatch.sh;
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
  };
}
