{ system, ... }: {
  boot.loader.systemd-boot.enable = true;
  security.sudo.wheelNeedsPassword = false;
  sops.secrets."${system.name}/ntfy" = { };
}
