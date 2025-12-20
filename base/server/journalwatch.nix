{ lib, pkgs, ... }: {
  systemd.services.journalwatch = {
    after = [ "network-online.target" ];
    description = "Watch journalctl and report security-relevant events to ntfy";
    path = [ pkgs.jq pkgs.iputils pkgs.scripts.ntfy ];
    preStart = "until ${lib.getExe pkgs.netcat} -z ntfy.pdiehm.dev 80; do sleep 1; done";
    requires = [ "network-online.target" ];
    script = lib.readFile ../../resources/scripts/journalwatch.sh;
    wantedBy = [ "multi-user.target" ];
  };
}
