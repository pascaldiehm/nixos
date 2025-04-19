{ lib, pkgs, ... }: {
  home-manager.users.pascal = {
    home.packages = [ pkgs.btrfs-progs pkgs.rsync pkgs.scripts.nixos-upgrade pkgs.unzip pkgs.wireguard-tools pkgs.zip ];

    programs = {
      jq.enable = true;
      ssh.enable = true;
    };
  };

  programs = {
    command-not-found.enable = false;
    nano.enable = false;
    scripts.nixos-upgrade.text = lib.readFile ../../resources/scripts/upgrade.sh;

    vim = {
      enable = true;
      defaultEditor = true;
      package = pkgs.vim.override { vimrc = ../../resources/vimrc.vim; };
    };
  };
}
