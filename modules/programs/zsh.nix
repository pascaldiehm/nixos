{ pkgs, helpers, ... }: {
  # Set ZSH as default shell
  programs.zsh.enable = true;
  users.users.pascal.shell = pkgs.zsh;

  # Set ZDOTDIR
  programs.zsh.shellInit = "export ZDOTDIR=\"$HOME/.config/zsh\"";

  home-manager.users.pascal = {
    # Delete .zshenv
    home.activation.deleteZSHEnv = helpers.mkHomeManagerActivation [ "writeBoundary" ] "run rm -f .zshenv";

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
        nixos-secrets = "sudo SOPS_AGE_KEY_FILE=/etc/nixos/secret.key sops ~/.config/nixos/resources/secrets/store.yml";
        nixos-test = "sudo nixos-rebuild --impure --flake ~/.config/nixos test";
        open = "xdg-open";
        py = "python3";
        pyenv = "[ -d .venv ] || python3 -m venv .venv; source .venv/bin/activate";
      };
    };
  };
}
