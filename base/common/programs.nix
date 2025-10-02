{ pkgs, ... }: {
  home-manager.users.pascal.home.packages = [
    pkgs.bat
    pkgs.btrfs-progs
    pkgs.duf
    pkgs.eza
    pkgs.fastfetch
    pkgs.fd
    pkgs.file
    pkgs.jq
    pkgs.lsof
    pkgs.ncdu
    pkgs.netcat
    pkgs.ripgrep
    pkgs.unzip
    pkgs.wireguard-tools
    pkgs.zip
  ];

  programs = {
    command-not-found.enable = false;
    nano.enable = false;

    vim = {
      enable = true;
      defaultEditor = true;
      package = pkgs.vim.override { vimrc = ../../resources/vim/vimrc.vim; };
    };
  };
}
