{ lib, pkgs, ... }: {
  boot = {
    initrd.luks.devices.nixos.device = "/dev/disk/by-partlabel/nixos";
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services.greetd = {
    enable = true;

    settings = {
      default_session.command = "${lib.getExe pkgs.greetd.tuigreet} --cmd ${pkgs.writeShellScript "exec-shell" "exec $SHELL"}";

      initial_session = {
        command = "${lib.getExe pkgs.uwsm} start ${pkgs.hyprland}/share/wayland-sessions/hyprland.desktop";
        user = "pascal";
      };
    };
  };
}
