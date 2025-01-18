{ pkgs, ... }: {
  home-manager.users.pascal = {
    home.packages = [ pkgs.btrfs-progs pkgs.jq pkgs.unzip pkgs.zip ];

    programs = {
      ssh.enable = true;

      vim = {
        enable = true;
        defaultEditor = true;
        extraConfig = builtins.readFile ../../resources/vimrc.vim;
      };
    };
  };

  programs = {
    command-not-found.enable = false;
    nano.enable = false;
  };
}
