{ lib, pkgs, ... }: {
  boot = {
    initrd.luks.devices.nixos.device = "/dev/disk/by-partlabel/nixos";
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services.greetd = {
    enable = true;
    useTextGreeter = true;

    settings = {
      default_session.command = "${lib.getExe' pkgs.greetd "agreety"} --cmd ${pkgs.writeShellScript "exec-shell" "exec $SHELL"}";

      initial_session = {
        command = "${lib.getExe pkgs.uwsm} start -F /run/current-system/sw/bin/Hyprland";
        user = "pascal";
      };
    };
  };
}
