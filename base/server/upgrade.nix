{ lib, pkgs, ... }: {
  systemd.services.nixos-upgrade.serviceConfig.ExecStartPost = "${lib.getExe' pkgs.systemd "systemctl"} reboot";

  system.autoUpgrade = {
    enable = true;
    dates = "Mon 01:00";
    flags = [ "--impure" ];
    flake = "github:pascaldiehm/nixos";
    operation = "boot";
    upgrade = false;
  };
}
