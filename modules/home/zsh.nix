{ lib, pkgs, ... }: {
  # Delete ~/.zshenv (ZDOTDIR is defiend system-wide)
  home.activation.deleteZSHEnv = lib.hm.dag.entryAfter [ "writeBoundary" ] "run rm -rf .zshenv";

  # Setup ZSH
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    dotDir = ".config/zsh";
    history.path = "$ZDOTDIR/.zsh_history";
    initExtra = builtins.readFile ../../resources/zshrc.zsh;
    plugins = [ { name = "zsh-completions"; src = pkgs.zsh-completions; } ];
    syntaxHighlighting.enable = true;

    shellAliases = {
      l = "ls -alh";
      open = "xdg-open";
      py = "python3";
      pyenv = "[ -d .venv ] || python3 -m venv .venv; source .venv/bin/activate";
    };
  };
}
