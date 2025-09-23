{ lib, pkgs, ... }: {
  users.users.pascal.extraGroups = [ "wireshark" "ydotool" ];

  home-manager.users.pascal = {
    services.playerctld.enable = true;

    home.packages = [
      pkgs.adwaita-icon-theme
      pkgs.bat
      pkgs.brightnessctl
      pkgs.cryptsetup
      pkgs.dmidecode
      pkgs.dog
      pkgs.duf
      pkgs.exfat
      pkgs.eza
      pkgs.fd
      pkgs.ffmpeg-full
      pkgs.gimp3
      pkgs.hardinfo2
      pkgs.imagemagickBig
      pkgs.inkscape
      pkgs.mtr
      pkgs.ncdu
      pkgs.networkmanagerapplet
      pkgs.nmap
      pkgs.poppler-utils
      pkgs.pwvucontrol
      pkgs.ripgrep
      pkgs.rsync
      pkgs.scripts.mkletter
      pkgs.scripts.mnt
      pkgs.scripts.nixos-upgrade
      pkgs.scripts.repo
      pkgs.scripts.wp-toggle
      pkgs.sops
      pkgs.steam-run-free
      pkgs.tcpdump
      pkgs.tenacity
      pkgs.usbutils
      pkgs.vhs
      pkgs.vlc
      pkgs.wireshark
      pkgs.wl-clipboard
      pkgs.xh
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
      wp-toggle.text = lib.readFile ../../resources/scripts/wp-toggle.sh;

      mnt = {
        deps = [ pkgs.android-file-transfer pkgs.curlftpfs pkgs.sshfs ];
        text = lib.readFile ../../resources/scripts/mount.sh;
      };
    };
  };
}
