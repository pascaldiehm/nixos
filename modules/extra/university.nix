{ config, helpers, ... }: {
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
      firefox.profiles.default.bookmarks = [
        (helpers.mkFirefoxBookmarksFolder "Uni Würzburg" {
          GitLab = "https://gitlab.informatik.uni-wuerzburg.de";
          WueCampus = "https://wuecampus.uni-wuerzburg.de";
          WueStudy = "https://wuestudy.zv.uni-wuerzburg.de";
        })
      ];

      git.extraConfig.url = {
        "git@gitlab.informatik.uni-wuerzburg.de:".insteadOf = "uni:";
        "git@gitlab.informatik.uni-wuerzburg.de:s457719/".insteadOf = "uni:/";
      };
    };
  };

  networking.networkmanager.ensureProfiles = {
    environmentFiles = [ config.sops.secrets."university/eduroam/network".path ];

    profiles = {
      bayern-wlan = {
        connection = {
          autoconnect-priority = 10;
          id = "BayernWLAN";
          type = "wifi";
        };

        wifi = {
          mode = "infrastructure";
          ssid = "@BayernWLAN";
        };
      };

      eduroam = {
        wifi-security.key-mgmt = "wpa-eap";

        "802-1x" = {
          ca-cert = config.sops.secrets."university/eduroam/ca-cert".path;
          client-cert = config.sops.secrets."university/eduroam/client-cert".path;
          eap = "tls";
          identity = "$EDUROAM_IDENTITY";
          private-key = config.sops.secrets."university/eduroam/private-key".path;
          private-key-password = "$EDUROAM_PASSWORD";
        };

        connection = {
          autoconnect-priority = 20;
          id = "eduroam";
          type = "wifi";
        };

        wifi = {
          mode = "infrastructure";
          ssid = "eduroam";
        };
      };
    };
  };

  sops.secrets = helpers.mkSSHSecrets [ "university/gitlab-ssh-key" ] // {
    "university/eduroam/ca-cert" = { };
    "university/eduroam/client-cert" = { };
    "university/eduroam/network" = { };
    "university/eduroam/private-key" = { };
  };
}
