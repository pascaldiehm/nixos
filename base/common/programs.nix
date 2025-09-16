{ pkgs, ... }: {
  home-manager.users.pascal.home.packages = [
    pkgs.btrfs-progs
    pkgs.fastfetch
    pkgs.file
    pkgs.jq
    pkgs.lsof
    pkgs.netcat
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
