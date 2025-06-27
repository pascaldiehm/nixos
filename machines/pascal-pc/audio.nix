{ lib, pkgs, ... }: {
  home-manager.users.pascal.systemd.user.services.music = {
    Install.WantedBy = [ "default.target" ];
    Unit.Description = "Play music";

    Service = {
      ConditionPathExistsGlob = "/home/pascal/Documents/personal/Music/Favorites/*";
      ExecStart = "${lib.getExe' pkgs.vlc "cvlc"} -LZ /home/pascal/Documents/personal/Music/Favorites";
    };
  };

  systemd.services.disable-auto-mute = {
    after = [ "sound.target" ];
    description = "Disable auto-mute";
    wantedBy = [ "sound.target" ];

    serviceConfig = {
      ExecStart = "${lib.getExe' pkgs.alsa-utils "amixer"} -c 2 sset 'Auto-Mute Mode' Disabled";
      Type = "oneshot";
    };
  };
}
