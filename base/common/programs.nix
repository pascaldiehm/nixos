{ pkgs, ... }: {
  home-manager.users.pascal = {
    home.packages = [
      pkgs.btrfs-progs
      pkgs.dig
      pkgs.dmidecode
      pkgs.fastfetch
      pkgs.file
      pkgs.lsof
      pkgs.man-pages
      pkgs.man-pages-posix
      pkgs.netcat
      pkgs.nmap
      pkgs.rsync
      pkgs.traceroute
      pkgs.unzip
      pkgs.usbutils
      pkgs.wireguard-tools
      pkgs.zip
    ];

    programs = {
      jq.enable = true;
      ssh.enable = true;
    };
  };

  programs = {
    command-not-found.enable = false;
    nano.enable = false;

    vim = {
      enable = true;
      defaultEditor = true;
      package = pkgs.vim.override { vimrc = ../../resources/vimrc.vim; };
    };
  };
}
