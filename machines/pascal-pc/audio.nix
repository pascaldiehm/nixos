{ lib, pkgs, ... }: {
  systemd.services.disable-auto-mute = {
    after = [ "sound.target" ];
    description = "Disable auto-mute";
    script = "${lib.getExe' pkgs.alsa-utils "amixer"} -c 2 sset 'Auto-Mute Mode' Disabled";
    wantedBy = [ "sound.target" ];
  };
}
