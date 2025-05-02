{ lib, pkgs, ... }: {
  home-manager.users.pascal = {
    programs.yt-dlp.enable = true;
    services.playerctld.enable = true;

    home.packages = [
      pkgs.cryptsetup
      pkgs.dig
      pkgs.dmidecode
      pkgs.exfat
      pkgs.ffmpeg-full
      pkgs.file
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
  };

  programs.scripts = {
    letter.text = lib.readFile ../../resources/scripts/letter.sh;

    mnt = {
      deps = [ pkgs.android-file-transfer pkgs.curlftpfs pkgs.sshfs ];
      text = lib.readFile ../../resources/scripts/mount.sh;
    };
  };
}
