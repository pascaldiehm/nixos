{ config, lib, ... }:
{
  home-manager.users.pascal = {
    accounts.email.accounts.university = {
      address = "pascal.diehm@stud-mail.uni-wuerzburg.de";
      realName = config.users.users.pascal.description;
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

    programs = {
      firefox.profiles.default.bookmarks = [
        {
          name = "Uni Würzburg";

          bookmarks = lib.mapAttrsToList (name: url: { inherit name url; }) {
            GitLab = "https://gitlab.informatik.uni-wuerzburg.de";
            WueCampus = "https://wuecampus.uni-wuerzburg.de";
            WueStudy = "https://wuestudy.zv.uni-wuerzburg.de";
          };
        }
      ];

      git.extraConfig.url = {
        "git@gitlab.informatik.uni-wuerzburg.de:".insteadOf = "uni:";
        "git@gitlab.informatik.uni-wuerzburg.de:s457719/".insteadOf = "uni:/";
      };

      ssh.matchBlocks."gitlab.informatik.uni-wuerzburg.de".identityFile =
        config.sops.secrets."university/gitlab-ssh-key".path;
    };
  };

  networking.networkmanager.ensureProfiles = {
    environmentFiles = [ config.sops.secrets."university/eduroam/network".path ];

    profiles = {
      bayern-wlan = {
        connection = {
          autoconnect-priority = 25;
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
          autoconnect-priority = 50;
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

  sops.secrets = {
    "university/eduroam/ca-cert" = { };
    "university/eduroam/client-cert" = { };
    "university/eduroam/private-key" = { };
    "university/gitlab-ssh-key".owner = "pascal";

    "university/eduroam/network".restartUnits = [
      "NetworkManager.service"
      "NetworkManager-ensure-profiles.service"
    ];
  };
}
