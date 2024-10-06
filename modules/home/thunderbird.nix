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
      tls.enable = true;
    };

    smtp = {
      host = "smtp.gmail.com";
      port = 465;
      tls.enable = true;
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
}
