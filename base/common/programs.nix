{ lib, pkgs, ... }: {
  home-manager.users.pascal = {
    home.packages = [ pkgs.btrfs-progs pkgs.rsync pkgs.scripts.nixos-update pkgs.unzip pkgs.zip ];

    programs = {
      jq.enable = true;
      ssh.enable = true;
    };
  };

  programs = {
    command-not-found.enable = false;
    nano.enable = false;
    scripts.nixos-update.text = lib.readFile ../../resources/scripts/update.sh;

    vim = {
      enable = true;
      defaultEditor = true;
      package = pkgs.vim.override { vimrc = ../../resources/vimrc.vim; };
    };
  };
}
