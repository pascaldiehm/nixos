{ pkgs, ... }: {
  boot = {
    initrd.luks.devices.nixos.device = "/dev/disk/by-partlabel/nixos";
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services.displayManager = {
    autoLogin.user = "pascal";

    sddm = {
      enable = true;
      autoLogin.relogin = true;
      wayland.enable = true;
    };
  };
}
