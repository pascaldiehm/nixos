{ ... }: {
  # Setup email account
  accounts.email.accounts.default = {
    address = "pdiehm8@gmail.com";
    flavor = "gmail.com";
    primary = true;
    realName = "Pascal Diehm";
    thunderbird.enable = true;

    gpg = {
      key = "pdiehm8@gmail.com";
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

  # Setup thunderbird
  programs.thunderbird = {
    enable = true;

    profiles.default = {
      isDefault = true;
      withExternalGnupg = true;
    };
  };

  # Add mime types
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/mailto" = "thunderbird.desktop";
  };
}
