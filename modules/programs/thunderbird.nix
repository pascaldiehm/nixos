{ ... }: {
  home-manager.users.pascal = {
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
      #settings."mail.openpgp.fetch_pubkeys_from_gnupg" = true;

      profiles.default = {
        isDefault = true;
        withExternalGnupg = true;
      };

      settings = {
        "mail.collect_email_address_outgoing" = false;
        "mail.openpgp.fetch_pubkeys_from_gnupg" = true;
      };
    };

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/mailto" = "thunderbird.desktop";
    };
  };
}
