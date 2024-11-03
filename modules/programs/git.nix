{ ... }: {
  home-manager.users.pascal.programs.git = {
    enable = true;
    userEmail = "pdiehm8@gmail.com";
    userName = "Pascal Diehm";

    aliases = {
      a = "add";

      b = "branch";
      bD = "branch -D";
      bM = "branch -M";
      bc = "branch -c";
      bd = "branch -d";
      bm = "branch -m";
      bu = "branch -u";

      c = "commit";
      ca = "commit -a";
      caa = "commit -a --amend --no-edit";
      cae = "commit --amend";
      cam = "commit --amend --no-edit";
      ce = "commit --allow-empty";
      cm = "commit -m";

      cl = "clean -fdx";
      cli = "clean -fdX";

      co = "checkout";
      cob = "checkout -b";

      d = "diff";
      dm = "diff main @";
      ds = "diff --staged";
      du = "diff @{u} @";

      f = "fetch";

      i = "status";
      is = "status -s";

      l = "log --format='%C(yellow)%h %C(blue)%aN, %ah %C(reset)%s%C(dim white)%d'";
      ll = "log --format='%C(yellow)%h %C(white)%s%C(dim white)%d%n%C(blue)%aN <%aE>, %ah %C(reset)- %C(green)(%G?) %GS%n'";
      lll = "log --format='%C(yellow)Commit %H%C(dim white)%d%n%C(blue)Author:    %aN <%aE> on %aD%n%C(blue)Committer: %cN <%cE> on %cD%n%C(green)Signature: (%G?) %GS%n%n%B%n'";

      m = "merge";
      ma = "merge --abort";
      mc = "merge --continue";

      rb = "rebase";
      rba = "rebase --abort";
      rbc = "rebase --continue";
      rbi = "rebase -i";
      rbr = "rebase -i --root";

      rsh = "reset --hard";
      rso = "reset --hard origin";

      rs = "restore";
      rss = "restore --staged";

      rv = "revert";
      rva = "revert --abort";
      rvc = "revert --continue";

      s = "stash";
      sb = "stash branch";
      sc = "stash clear";
      sd = "stash drop";
      sl = "stash list";
      sp = "stash pop";
      su = "stash -u";

      sh = "show";

      t = "tag";
      td = "tag -d";
    };

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
