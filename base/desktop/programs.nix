{ pkgs, ... }: {
  home-manager.users.pascal = {
    home.packages = [
      pkgs.android-file-transfer
      pkgs.cryptsetup
      pkgs.curlftpfs
      pkgs.exfat
      pkgs.ffmpeg-full
      pkgs.imagemagickBig
      pkgs.poppler_utils
      pkgs.quickemu
      pkgs.sbctl
      pkgs.smartmontools
      pkgs.sops
      pkgs.sshfs
      pkgs.tinyxxd
      pkgs.vlc
    ];

    programs = {
      yt-dlp.enable = true;

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

    services = {
      playerctld.enable = true;

      gpg-agent = {
        enable = true;
        pinentryPackage = pkgs.pinentry-tty;
      };
    };
  };
}
