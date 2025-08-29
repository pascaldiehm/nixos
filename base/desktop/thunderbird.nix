{ lib, pkgs, ... }: {
  environment.persistence."/perm".users.pascal.directories = [ ".thunderbird/default" ];

  home-manager.users.pascal = {
    accounts = {
      calendar.accounts.default = {
        primary = true;
        thunderbird.enable = true;

        remote = {
          type = "caldav";
          url = "https://apidata.googleusercontent.com/caldav/v2/pdiehm8%40gmail.com/events/";
          userName = "pdiehm8@gmail.com";
        };
      };

      contact.accounts.default = {
        thunderbird.enable = true;

        remote = {
          type = "carddav";
          url = "https://www.googleapis.com/carddav/v1/principals/pdiehm8@gmail.com/lists/default/";
          userName = "pdiehm8@gmail.com";
        };
      };

      email.accounts.default = {
        address = "pdiehm8@gmail.com";
        flavor = "gmail.com";
        primary = true;
        realName = "Pascal Diehm";
        thunderbird.enable = true;
        userName = "pdiehm8@gmail.com";
      };
    };

    programs.thunderbird = {
      enable = true;
      profiles.default.isDefault = true;

      package = pkgs.thunderbird.override {
        extraPolicies.ExtensionSettings = lib.mkMozillaExtensions ../../resources/extensions/thunderbird.json { };
      };

      settings = {
        "mail.collect_email_address_outgoing" = false;
        "spellchecker.dictionary" = "en-US,de-DE";
      };
    };
  };
}
