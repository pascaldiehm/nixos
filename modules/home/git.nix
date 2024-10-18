{ ... }: {
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
      key = "44F1404358E52DB9";
      signByDefault = true;
    };
  };
}
