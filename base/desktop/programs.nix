{ pkgs, ... }: {
  home-manager.users.pascal = {
    services.playerctld.enable = true;

    home.packages = [
      pkgs.android-file-transfer
      pkgs.cryptsetup
      pkgs.curlftpfs
      pkgs.exfat
      pkgs.ffmpeg-full
      pkgs.imagemagickBig
      pkgs.poppler_utils
      pkgs.pwvucontrol
      pkgs.quickemu
      pkgs.sbctl
      pkgs.smartmontools
      pkgs.sops
      pkgs.sshfs
      pkgs.vlc
    ];

    programs = {
      yt-dlp.enable = true;

      git.signing = {
        key = "E85EB0566C779A2F";
        signByDefault = true;
      };
    };
  };
}
