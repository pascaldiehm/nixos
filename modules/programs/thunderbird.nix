{ ... }: {
  home-manager.users.pascal = {
    # Setup email account
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

    # Setup Thunderbird
    programs.thunderbird = {
      enable = true;
      settings."mail.openpgp.fetch_pubkeys_from_gnupg" = true;

      profiles.default = {
        isDefault = true;
        withExternalGnupg = true;
      };
    };

    # Add mime types
    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/mailto" = "thunderbird.desktop";
    };
  };
}
