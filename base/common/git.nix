{
  home-manager.users.pascal.programs.git = {
    enable = true;
    userEmail = "pdiehm8@gmail.com";
    userName = "Pascal Diehm";

    aliases = {
      a = "add";
      ap = "add --patch";

      b = "branch";
      bc = "branch --copy";
      bd = "branch --delete";
      bdf = "branch --delete --force";
      bm = "branch --move";
      bu = "branch --set-upstream-to";

      bsb = "bisect bad";
      bsg = "bisect good";
      bsr = "bisect reset";
      bss = "bisect start";
      bsv = "bisect view";

      c = "commit";
      ca = "commit --all";
      cac = "commit --all --amend --no-edit";
      cacm = "commit --all --amend --message";
      cam = "commit --all --message";
      cc = "commit --amend --no-edit";
      ccm = "commit --amend --message";
      ce = "commit --allow-empty";
      cem = "commit --allow-empty --message";
      cm = "commit --message";

      cl = "clean -fdx";
      cli = "clean -fdX";

      co = "checkout";
      cob = "checkout -b";

      d = "diff";
      dm = "rev-list --left-right --oneline '...main'";
      ds = "diff --staged";
      du = "rev-list --left-right --oneline '...@{u}'";

      f = "fetch";

      i = "status";
      is = "status --short";

      l = "log --format='%C(yellow)%h %C(blue)%aN, %ah %C(reset)%s%C(dim white)%d'";
      ll = "log --format='%C(yellow)%h %C(white)%s%C(dim white)%d%n%C(blue)%aN <%aE>, %ah %C(reset)- %C(green)(%G?) %GS%n'";
      lll = "log --format='%C(yellow)Commit %H%C(dim white)%d%n%C(blue)Author:    %aN <%aE> on %aD%n%C(blue)Committer: %cN <%cE> on %cD%n%C(green)Signature: (%G?) %GS%n%n%B%n'";

      m = "merge";
      ma = "merge --abort";
      mc = "merge --continue";

      pf = "push --force-with-lease";
      pl = "pull";
      ps = "push";

      rb = "rebase";
      rba = "rebase --abort";
      rbc = "rebase --continue";
      rbi = "rebase --interactive";
      rbr = "rebase --interactive --root";
      rbs = "rebase --interactive '@{1 day ago}'";

      rs = "restore";
      rss = "restore --staged";

      rt = "reset";
      rth = "reset --hard";
      rtu = "reset --hard '@{u}'";

      rv = "revert";
      rva = "revert --abort";
      rvc = "revert --continue";

      s = "stash push --include-untracked";
      sc = "stash clear";
      sd = "stash drop";
      sl = "stash list";
      sp = "stash pop";

      sh = "show";

      t = "tag";
      td = "tag --delete";
      tm = "tag --message";
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
  };
}
