{ lib, pkgs, ... }: {
  users.users.pascal.extraGroups = [ "wireshark" "ydotool" ];

  home-manager.users.pascal = {
    services.playerctld.enable = true;

    home.packages = [
      pkgs.adwaita-icon-theme
      pkgs.brightnessctl
      pkgs.cryptsetup
      pkgs.exfat
      pkgs.ffmpeg-full
      pkgs.hardinfo2
      pkgs.imagemagickBig
      pkgs.inkscape
      pkgs.networkmanagerapplet
      pkgs.poppler-utils
      pkgs.pwvucontrol
      pkgs.scripts.mkletter
      pkgs.scripts.mnt
      pkgs.scripts.nixos-upgrade
      pkgs.scripts.repo
      pkgs.sops
      pkgs.steam-run-free
      pkgs.vlc
      pkgs.wireshark
      pkgs.wl-clipboard
      pkgs.yt-dlp
    ];
  };

  programs = {
    wireshark.enable = true;
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
