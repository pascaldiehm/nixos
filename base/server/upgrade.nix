{ pkgs, ... }: {
  systemd.services.nixos-upgrade = {
    after = [ "network-online.target" ];
    description = "Upgrade NixOS";
    path = [ pkgs.git pkgs.nixos-rebuild pkgs.sudo ];
    requires = [ "network-online.target" ];
    serviceConfig.Type = "oneshot";
    startAt = "Mon 01:00";

    script = ''
      sudo -u pascal git -C /home/pascal/.config/nixos pull
      nixos-rebuild --impure --flake /home/pascal/.config/nixos boot
      systemctl reboot
    '';
  };
}
