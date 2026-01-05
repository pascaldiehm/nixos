{ config, lib, pkgs, ... }: {
  services.speechd.enable = false;
  sops.secrets.home-assistant-token.owner = "pascal";
  users.users.pascal.extraGroups = [ "ydotool" ];

  home-manager.users.pascal = {
    home.packages = [
      pkgs.brightnessctl
      pkgs.clinfo
      pkgs.cloc
      pkgs.clock-rs
      pkgs.cryptsetup
      pkgs.dmidecode
      pkgs.doggo
      pkgs.exfat
      pkgs.ffmpeg-full
      pkgs.hardinfo2
      pkgs.hexedit
      pkgs.imagemagickBig
      pkgs.mtr
      pkgs.nmap
      pkgs.pd.ha
      pkgs.pd.mk
      pkgs.pd.mnt
      pkgs.pd.repo
      pkgs.pd.wp-toggle
      pkgs.poppler-utils
      pkgs.rsync
      pkgs.steam-run-free
      pkgs.tcpdump
      pkgs.usbutils
      pkgs.vhs
      pkgs.wf-recorder
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
    ydotool.enable = true;

    scripts = {
      mk.text = lib.readFile ../../resources/scripts/mk.sh;
      repo.text = lib.readFile ../../resources/scripts/repo.sh;
      wp-toggle.text = lib.readFile ../../resources/scripts/wp-toggle.sh;

      ha.text = lib.readFile ../../resources/scripts/ha.sh
        |> lib.templateString { TOKEN = config.sops.secrets.home-assistant-token.path; };

      mnt = {
        deps = [ pkgs.android-file-transfer pkgs.curlftpfs pkgs.sshfs ];
        text = lib.readFile ../../resources/scripts/mnt.sh;
      };
    };
  };
}
