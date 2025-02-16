{ machine, ... }: {
  boot.loader.systemd-boot.enable = true;
  security.sudo.wheelNeedsPassword = false;
  sops.secrets."${machine.name}/ntfy" = { };
}
