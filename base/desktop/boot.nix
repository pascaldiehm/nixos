{ pkgs, ... }: {
  boot = {
    initrd.luks.devices.nixos.device = "/dev/disk/by-partlabel/nixos";
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services.getty = {
    autologinOnce = true;
    autologinUser = "pascal";
  };
}
