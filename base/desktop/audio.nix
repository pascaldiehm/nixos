{ lib, pkgs, ... }: {
  home-manager.users.pascal.systemd.user.services.music = {
    Unit.Description = "Play music";

    Service = {
      ExecCondition = "${lib.getExe' pkgs.coreutils "test"} -d /home/pascal/Documents/personal/Music/Favorites";
      ExecStart = "${lib.getExe' pkgs.vlc "cvlc"} -LZ /home/pascal/Documents/personal/Music/Favorites";
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}
