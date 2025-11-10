{ config, ... }: {
  boot.zfs.forceImportRoot = false;
  networking.hostId = "06378c60";

  fileSystems."/home/pascal/archive" = {
    device = "archive";
    fsType = "zfs";
    options = [ "nofail" "x-systemd.device-timeout=10" ];
  };

  services.zfs = {
    autoScrub.enable = true;

    zed.settings = {
      ZED_NOTIFY_VERBOSE = true;
      ZED_NTFY_ACCESS_TOKEN = "$(cat \"${config.sops.common.ntfy.path}\")";
      ZED_NTFY_TOPIC = "bowser-zfs";
      ZED_NTFY_URL = "https://ntfy.pdiehm.dev";
    };
  };
}
