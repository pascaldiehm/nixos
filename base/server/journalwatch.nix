{ libx, system, ... }:
{
  sops.secrets."${system.name}/ntfy".restartUnits = [ "journalwatch.service" ];

  systemd.services.journalwatch = {
    after = [ "network-online.target" ];
    description = "Watch journalctl and report security-relevant events to ntfy";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];

    script = libx.mkScript {
      env.NTFY_CMD = libx.mkNtfy "journal" "$1";
      path = ../../resources/scripts/journalwatch.sh;
    };
  };
}
