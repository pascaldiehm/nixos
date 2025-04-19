{ lib, pkgs, ... }: {
  home-manager.users.pascal = {
    services.playerctld.enable = true;

    home.packages = [
      pkgs.cryptsetup
      pkgs.dig
      pkgs.dmidecode
      pkgs.exfat
      pkgs.ffmpeg-full
      pkgs.imagemagickBig
      pkgs.netcat
      pkgs.networkmanagerapplet
      pkgs.poppler_utils
      pkgs.pwvucontrol
      pkgs.scripts.letter
      pkgs.scripts.mnt
      pkgs.sops
      pkgs.usbutils
      pkgs.vlc
      pkgs.wl-clipboard
    ];

    programs = {
      yt-dlp.enable = true;

      git.signing = {
        key = "E85EB0566C779A2F";
        signByDefault = true;
      };
    };
  };

  programs.scripts = {
    letter.text = lib.readFile ../../resources/scripts/letter.sh;

    mnt = {
      deps = [ pkgs.android-file-transfer pkgs.curlftpfs pkgs.sshfs ];
      text = lib.readFile ../../resources/scripts/mount.sh;
    };
  };
}
