{
  boot = {
    initrd.luks.devices.nixos.device = "/dev/disk/by-partlabel/nixos";

    lanzaboote = {
      enable = true;
      pkiBundle = "/perm/var/lib/sbctl";
    };
  };
}
