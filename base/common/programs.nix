{ pkgs, ... }: {
  home-manager.users.pascal = {
    home.packages = [ pkgs.btrfs-progs ];

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
