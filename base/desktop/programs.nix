{ pkgs, ... }: {
  home-manager.users.pascal = {
    services.playerctld.enable = true;

    home.packages = [
      pkgs.cryptsetup
      pkgs.exfat
      pkgs.ffmpeg-full
      pkgs.imagemagickBig
      pkgs.poppler_utils
      pkgs.pwvucontrol
      pkgs.sbctl
      pkgs.sops
      pkgs.vlc
      pkgs.wl-clipboard

      (pkgs.writeShellApplication {
        name = "letter";
        text = builtins.readFile ../../resources/scripts/letter.sh;
      })

      (pkgs.writeShellApplication {
        name = "mnt";
        runtimeInputs = [ pkgs.android-file-transfer pkgs.curlftpfs pkgs.sshfs ];
        text = builtins.readFile ../../resources/scripts/mount.sh;
      })
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
