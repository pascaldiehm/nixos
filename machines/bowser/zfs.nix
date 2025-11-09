{
  boot.zfs.forceImportRoot = false;
  networking.hostId = "06378c60";
  services.zfs.autoScrub.enable = true;

  fileSystems."/home/pascal/archive" = {
    device = "archive";
    fsType = "zfs";
    options = [ "nofail" "x-systemd.device-timeout=10" ];
  };
}
