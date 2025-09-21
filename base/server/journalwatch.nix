{ lib, pkgs, ... }: {
  systemd.services.journalwatch = {
    after = [ "network-online.target" ];
    description = "Watch journalctl and report security-relevant events to ntfy";
    path = [ pkgs.jq pkgs.iputils pkgs.scripts.ntfy ];
    requires = [ "network-online.target" ];
    script = lib.readFile ../../resources/scripts/journalwatch.sh;
    wantedBy = [ "multi-user.target" ];
  };
}
