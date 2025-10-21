{ config, ... }: {
  sops.secrets."university/gitlab-ssh-key".owner = "pascal";

  home-manager.users.pascal.programs = {
    git.settings.url = {
      "git@gitlab.informatik.uni-wuerzburg.de:".insteadOf = "uni:";
      "git@gitlab.informatik.uni-wuerzburg.de:s457719/".insteadOf = "uni:/";
    };

    ssh.matchBlocks."gitlab.informatik.uni-wuerzburg.de" = {
      identityFile = config.sops.secrets."university/gitlab-ssh-key".path;
    };
  };

  programs.ssh.knownHosts."gitlab.informatik.uni-wuerzburg.de" = {
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIHuymoMSN41qVyA1d1+awluFWRCElDIRa+ygAugtr9R";
  };
}
