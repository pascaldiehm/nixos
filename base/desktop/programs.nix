{ lib, pkgs, ... }: {
  users.users.pascal.extraGroups = [ "ydotool" ];

  home-manager.users.pascal = {
    programs.yt-dlp.enable = true;
    services.playerctld.enable = true;

    home.packages = [
      pkgs.adwaita-icon-theme
      pkgs.cryptsetup
      pkgs.exfat
      pkgs.ffmpeg-full
      pkgs.imagemagickBig
      pkgs.networkmanagerapplet
      pkgs.poppler-utils
      pkgs.pwvucontrol
      pkgs.scripts.mkletter
      pkgs.scripts.mnt
      pkgs.scripts.nixos-upgrade
      pkgs.scripts.repo
      pkgs.sops
      pkgs.vlc
      pkgs.wl-clipboard
    ];
  };

  programs = {
    ydotool.enable = true;

    scripts = {
      mkletter.text = lib.readFile ../../resources/scripts/mkletter.sh;
      nixos-upgrade.text = lib.readFile ../../resources/scripts/nixos-upgrade.sh;
      repo.text = lib.readFile ../../resources/scripts/repo.sh;

      mnt = {
        deps = [ pkgs.android-file-transfer pkgs.curlftpfs pkgs.sshfs ];
        text = lib.readFile ../../resources/scripts/mount.sh;
      };
    };
  };
}
