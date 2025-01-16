{ pkgs, ... }: {
  systemd.services.disable-auto-mute = {
    after = [ "sound.target" ];
    description = "Disable auto-mute";
    script = "${pkgs.alsa-utils}/bin/amixer -c 2 sset 'Auto-Mute Mode' Disabled";
    wantedBy = [ "multi-user.target" ];
    wants = [ "sound.target" ];
  };
}
