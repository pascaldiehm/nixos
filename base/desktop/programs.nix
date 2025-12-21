{ lib, pkgs, ... }: {
  services.speechd.enable = false;
  users.users.pascal.extraGroups = [ "wireshark" "ydotool" ];

  home-manager.users.pascal = {
    home.packages = [
      pkgs.brightnessctl
      pkgs.clinfo
      pkgs.clock-rs
      pkgs.cryptsetup
      pkgs.dmidecode
      pkgs.dogdns
      pkgs.exfat
      pkgs.ffmpeg-full
      pkgs.gimp
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
      pkgs.scripts.repo
      pkgs.scripts.wp-toggle
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

    programs = {
      kitty.enable = true;
      rofi.enable = true;
    };

    services = {
      playerctld.enable = true;

      mako = {
        enable = true;
        settings.default-timeout = 5000;
      };
    };
  };

  programs = {
    wireshark.enable = true;
    ydotool.enable = true;

    scripts = {
      mk.text = lib.readFile ../../resources/scripts/mk.sh;
      repo.text = lib.readFile ../../resources/scripts/repo.sh;
      wp-toggle.text = lib.readFile ../../resources/scripts/wp-toggle.sh;

      mnt = {
        deps = [ pkgs.android-file-transfer pkgs.curlftpfs pkgs.sshfs ];
        text = lib.readFile ../../resources/scripts/mnt.sh;
      };
    };
  };
}
