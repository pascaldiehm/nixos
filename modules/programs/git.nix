{ ... }: {
  home-manager.users.pascal.programs.git = {
    enable = true;
    userEmail = "pdiehm8@gmail.com";
    userName = "Pascal Diehm";

    extraConfig = {
      help.autoCorrect = "prompt";
      init.defaultBranch = "main";
      pull.rebase = true;
      rebase.autoStash = true;
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
      key = "E85EB0566C779A2F";
      signByDefault = true;
    };
  };
}
