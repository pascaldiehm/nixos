{ lib, pkgs, ... }: {
  home-manager.users.pascal.systemd.user.services.music = {
    Service.ExecStart = "${lib.getExe' pkgs.vlc "cvlc"} -LZ /home/pascal/Documents/personal/Music/Favorites";
    Unit.Description = "Play music";
  };
}
