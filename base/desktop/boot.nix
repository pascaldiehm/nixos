{ lib, pkgs, ... }: {
  home-manager.users.pascal.home.packages = [ pkgs.pd.hypr ];
  programs.scripts.hypr.text = "exec ${lib.getExe pkgs.uwsm} start -Fe -D Hyprland -N Hyprland -g -1 /run/current-system/sw/bin/start-hyprland";

  boot = {
    initrd.luks.devices.nixos.device = "/dev/disk/by-partlabel/nixos";
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services.greetd = {
    enable = true;
    useTextGreeter = true;

    settings = {
      default_session.command = "${lib.getExe' pkgs.greetd "agreety"} --cmd ${pkgs.writeShellScript "exec-shell" ''exec "$SHELL"''}";

      initial_session = {
        command = lib.getExe pkgs.pd.hypr;
        user = "pascal";
      };
    };
  };
}
