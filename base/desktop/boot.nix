{ inputs, lib, pkgs, ... }: {
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  boot = {
    initrd.luks.devices.nixos.device = "/dev/disk/by-partlabel/nixos";
    kernelPackages = pkgs.linuxPackages_latest;

    lanzaboote = {
      enable = true;
      pkiBundle = "/perm/var/lib/sbctl";
    };
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
