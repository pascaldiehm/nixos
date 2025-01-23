{ inputs, lib, pkgs, ... }: {
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  boot = {
    initrd.luks.devices.nixos.device = "/dev/disk/by-partlabel/nixos";

    lanzaboote = {
      enable = true;
      pkiBundle = "/perm/var/lib/sbctl";
    };
  };

  services.greetd = {
    enable = true;

    settings.default_session = {
      command = "${lib.getExe pkgs.uwsm} start ${pkgs.hyprland}/share/wayland-sessions/hyprland.desktop";
      user = "pascal";
    };
  };
}
