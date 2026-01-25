{ lib, pkgs, ... }: {
  environment.pathsToLink = [ "/share/zsh" ];

  home-manager.users.pascal.programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    completionInit = "autoload -U compinit && compinit -d /home/pascal/.local/state/zsh/.zcompdump";
    dotDir = "/home/pascal/.config/zsh";
    history.path = "/home/pascal/.local/state/zsh/.zsh_history";
    setOptions = [ "PUSHD_SILENT" ];
    syntaxHighlighting.enable = true;

    initContent = lib.mkMerge [
      (lib.readFile ../../resources/zsh/aliases.zsh)
      (lib.readFile ../../resources/zsh/completion.zsh)
      (lib.readFile ../../resources/zsh/functions.zsh)
      (lib.readFile ../../resources/zsh/input.zsh)
      (lib.readFile ../../resources/zsh/prompt.zsh)
    ];

    plugins = lib.mapAttrsToList (name: value: value // { inherit name; }) {
      zsh-completions = {
        completions = [ "share/zsh/site-functions" ];
        src = pkgs.zsh-completions;
      };
    };
  };
}
