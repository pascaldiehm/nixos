{
  networking.hostId = "06378c60";
  services.zfs.autoScrub.enable = true;

  boot = {
    supportedFilesystems.zfs = true;
    zfs.forceImportRoot = false;
  };

  fileSystems."/home/pascal/archive" = {
    device = "archive";
    fsType = "zfs";
  };
}
