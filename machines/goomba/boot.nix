{ lib, ... }: {
  boot.loader = {
    systemd-boot.enable = lib.mkForce false;
    grub.device = "/dev/sda";
  };
}
