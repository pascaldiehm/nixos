{
  home-manager.users.pascal.accounts.email.accounts.default = {
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
}
