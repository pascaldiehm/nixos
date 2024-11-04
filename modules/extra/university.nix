{ config, helpers, ... }: {
  sops.secrets = helpers.mkSSHSecrets [ "university/gitlab-ssh-key" ];

  home-manager.users.pascal = {
    accounts.email.accounts.university = {
      address = "pascal.diehm@stud-mail.uni-wuerzburg.de";
      realName = "Pascal Diehm";
      thunderbird.enable = true;
      userName = "s457719";

      imap = {
        host = "imap.mail.uni-wuerzburg.de";
        port = 993;
      };

      smtp = {
        host = "mailmaster.uni-wuerzburg.de";
        port = 465;
      };
    };

    home.activation.writeSSHConfigUniversity = helpers.mkHMActivation [ "writeSSHConfig" ] ''
      cd $HOME
      run cat << EOF >> .ssh/config

      Host gitlab.informatik.uni-wuerzburg.de
        IdentityFile ${config.sops.secrets."university/gitlab-ssh-key".path}
      EOF
    '';

    programs = {
      git.extraConfig.url."git@gitlab.informatik.uni-wuerzburg.de:".insteadOf = "uni:";

      firefox.profiles.default.bookmarks = [
        (helpers.mkFirefoxBookmarksFolder "Uni Würzburg" {
          GitLab = "https://gitlab.informatik.uni-wuerzburg.de";
          WueCampus = "https://wuecampus.uni-wuerzburg.de";
          WueStudy = "https://wuestudy.zv.uni-wuerzburg.de";
        })
      ];
    };
  };
}
