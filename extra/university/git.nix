{ config, ... }: {
  sops.secrets."university/gitlab-ssh-key".owner = "pascal";

  home-manager.users.pascal.programs = {
    git.extraConfig.url = {
      "git@gitlab.informatik.uni-wuerzburg.de:".insteadOf = "uni:";
      "git@gitlab.informatik.uni-wuerzburg.de:s457719/".insteadOf = "uni:/";
    };

    ssh.matchBlocks."gitlab.informatik.uni-wuerzburg.de".identityFile = ''
      ${config.sops.secrets."university/gitlab-ssh-key".path}
    '';
  };
}
