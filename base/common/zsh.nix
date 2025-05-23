{ lib, machine, pkgs, ... }: {
  environment.pathsToLink = [ "/share/zsh" ];

  home-manager.users.pascal.programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    completionInit = "autoload -U compinit && compinit -d /home/pascal/.local/state/zsh/.zcompdump";
    dotDir = ".config/zsh";
    history.path = "/home/pascal/.local/state/zsh/.zsh_history";
    initContent = lib.readFile ../../resources/zshrc.zsh;
    localVariables.NIXOS_MACHINE_TYPE = machine.type;
    plugins = lib.mapAttrsToList (name: src: { inherit name src; }) { inherit (pkgs) zsh-completions; };
    syntaxHighlighting.enable = true;
  };
}
