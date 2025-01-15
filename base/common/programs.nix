{
  lib,
  pkgs,
  system,
  ...
}:
{
  home-manager.users.pascal = {
    home.packages = [
      pkgs.btrfs-progs
      pkgs.jq
      pkgs.unzip
      pkgs.zip
    ];

    programs = {
      ssh.enable = true;

      vim = {
        enable = true;
        defaultEditor = true;
        extraConfig = builtins.readFile ../../resources/vimrc.vim;
      };

      zsh = {
        enable = true;
        autosuggestion.enable = true;
        completionInit = "autoload -U compinit && compinit -d /home/pascal/.local/state/zsh/.zcompdump";
        dotDir = ".config/zsh";
        history.path = "/home/pascal/.local/state/zsh/.zsh_history";
        initExtra = builtins.readFile ../../resources/zshrc.zsh;
        localVariables.NIXOS_MACHINE_TYPE = system.type;
        plugins = lib.mapAttrsToList (name: src: { inherit name src; }) { inherit (pkgs) zsh-completions; };
        syntaxHighlighting.enable = true;
      };
    };
  };

  programs = {
    command-not-found.enable = false;
    nano.enable = false;
  };
}
