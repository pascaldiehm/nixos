{ pkgs, ... }:
{
  home-manager.users.pascal = {
    home.packages = [
      pkgs.cryptsetup
      pkgs.exfat
      pkgs.ffmpeg
      pkgs.imagemagickBig
      pkgs.poppler_utils
      pkgs.quickemu
      pkgs.smartmontools
      pkgs.sops
      pkgs.sshfs
      pkgs.vlc
      pkgs.yt-dlp
    ];

    programs = {
      git.signing = {
        key = "E85EB0566C779A2F";
        signByDefault = true;
      };

      gpg = {
        enable = true;
        homedir = "/home/pascal/.local/share/gnupg";
        scdaemonSettings.disable-ccid = true;
      };
    };
  };
}
