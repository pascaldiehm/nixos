{ lib, pkgs, ... }: {
  users.users.pascal.extraGroups = [ "wireshark" "ydotool" ];

  home-manager.users.pascal = {
    services.playerctld.enable = true;

    home.packages = [
      pkgs.brightnessctl
      pkgs.clinfo
      pkgs.clock-rs
      pkgs.cryptsetup
      pkgs.dmidecode
      pkgs.dogdns
      pkgs.exfat
      pkgs.ffmpeg-full
      pkgs.gimp3
      pkgs.hardinfo2
      pkgs.imagemagickBig
      pkgs.inkscape
      pkgs.mtr
      pkgs.networkmanagerapplet
      pkgs.nmap
      pkgs.pdfpc
      pkgs.poppler-utils
      pkgs.pwvucontrol
      pkgs.rsync
      pkgs.scripts.mk
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
      pkgs.wf-recorder
      pkgs.wireshark
      pkgs.wl-clipboard
      pkgs.wl-mirror
      pkgs.xh
      pkgs.yt-dlp
    ];
  };

  programs = {
    wireshark.enable = true;
    ydotool.enable = true;

    scripts = {
      mk.text = lib.readFile ../../resources/scripts/mk.sh;
      nixos-upgrade.text = lib.readFile ../../resources/scripts/nixos-upgrade.sh;
      repo.text = lib.readFile ../../resources/scripts/repo.sh;
      wp-toggle.text = lib.readFile ../../resources/scripts/wp-toggle.sh;

      mnt = {
        deps = [ pkgs.android-file-transfer pkgs.curlftpfs pkgs.sshfs ];
        text = lib.readFile ../../resources/scripts/mnt.sh;
      };
    };
  };
}
