{ pkgs, helpers, ... }: {
  home-manager.users.pascal = {
    xdg.mimeApps.defaultApplications."x-scheme-handler/mailto" = "thunderbird.desktop";

    accounts.email.accounts.default = {
      address = "pdiehm8@gmail.com";
      flavor = "gmail.com";
      primary = true;
      realName = "Pascal Diehm";
      thunderbird.enable = true;

      gpg = {
        key = "E85EB0566C779A2F";
        signByDefault = true;
      };

      imap = {
        host = "imap.gmail.com";
        port = 993;
      };

      smtp = {
        host = "smtp.gmail.com";
        port = 465;
      };
    };

    programs.thunderbird = {
      enable = true;
      package = pkgs.thunderbird.override { extraPolicies.ExtensionSettings = helpers.mkMozillaExtensions ../../resources/extensions/thunderbird.json; };

      profiles.default = {
        isDefault = true;
        withExternalGnupg = true;
      };

      settings = {
        "mail.collect_email_address_outgoing" = false;
        "mail.openpgp.fetch_pubkeys_from_gnupg" = true;
      };
    };
  };
}
