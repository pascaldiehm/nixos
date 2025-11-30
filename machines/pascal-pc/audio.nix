{ lib, pkgs, ... }: {
  home-manager.users.pascal.systemd.user.services.music = {
    Install.WantedBy = [ "default.target" ];
    Service.ExecStart = "${lib.getExe' pkgs.vlc "cvlc"} --random /home/pascal/Repos/personal/Music/Favorites";

    Unit = {
      ConditionPathExistsGlob = "/home/pascal/Repos/personal/Music/Favorites/*";
      Description = "Play music";
    };
  };

  systemd.services.disable-auto-mute = {
    after = [ "sound.target" ];
    description = "Disable auto-mute";
    wantedBy = [ "sound.target" ];

    serviceConfig = {
      ExecStart = "${lib.getExe' pkgs.alsa-utils "amixer"} --card 2 sset 'Auto-Mute Mode' Disabled";
      Type = "oneshot";
    };
  };
}
