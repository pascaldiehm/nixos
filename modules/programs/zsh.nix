{ pkgs, helpers, ... }: {
  users.users.pascal.shell = pkgs.zsh;

  home-manager.users.pascal = {
    home.activation.deleteZSHEnv = helpers.mkHMActivation [ "writeBoundary" ] "run rm -f $HOME/.zshenv";

    programs.zsh = {
      enable = true;
      autocd = true;
      autosuggestion.enable = true;
      dotDir = ".config/zsh";
      history.path = "$ZDOTDIR/.zsh_history";
      initExtra = builtins.readFile ../../resources/zshrc.zsh;
      plugins = [{ name = "zsh-completions"; src = pkgs.zsh-completions; }];
      syntaxHighlighting.enable = true;

      shellAliases = {
        vsc = "codium";
        l = "ls -alh";
        nixos-secrets = "sudo GNUPGHOME=/etc/nixos/.gnupg sops ~/.config/nixos/resources/secrets/store.yml";
        nixos-test = "sudo nixos-rebuild --impure --flake ~/.config/nixos test";
        nixos-update = "nix run ~/.config/nixos#update";
        open = "xdg-open";
        py = "python3";
      };
    };
  };

  programs.zsh = {
    enable = true;
    shellInit = "export ZDOTDIR=\"$HOME/.config/zsh\"";
  };
}
