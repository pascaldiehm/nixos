{ pkgs, ... }: {
  systemd.services.journalwatch = {
    after = [ "network-online.target" ];
    description = "Watch journalctl and report security-relevant events to ntfy";
    path = [ pkgs.scripts.ntfy ];
    script = builtins.readFile ../../resources/scripts/journalwatch.sh;
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
  };
}
