{ lib, pkgs, ... }: {
  systemd.services.nixos-upgrade = {
    after = [ "network-online.target" ];
    description = "Upgrade NixOS";
    path = [ pkgs.git pkgs.nixos-rebuild pkgs.sudo ];
    requires = [ "network-online.target" ];
    startAt = "Mon 01:00";

    serviceConfig = {
      ExecStart = "${lib.getExe pkgs.scripts.nx} upgrade";
      ExecStartPost = "${lib.getExe' pkgs.systemd "systemctl"} reboot";
      Type = "oneshot";
    };
  };
}
