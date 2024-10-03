{ config, pkgs, ... }: {
  # Setup GnuPG
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };

  # Setup gpg-agent
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

  # Setup git
  programs.git = {
    enable = true;
    userEmail = "pdiehm8@gmail.com";
    userName = "Pascal Diehm";

    extraConfig = {
      help.autocorrect = "prompt";
      init.defaultBranch = "main";
      pull.rebsae = true;
      rebase.autostash = true;
      submodule.recurse = true;

      fetch = {
        prune = true;
        pruneTags = true;
      };

      push = {
        autoSetupRemote = true;
        followTags = true;
      };

      url = {
        "git@github.com:".insteadOf = "gh:";
        "git@github.com:pascaldiehm/".insteadOf = "gh:/";
      };
    };

    signing = {
      key = "pdiehm8@gmail.com";
      signByDefault = true;
    };
  };
}
