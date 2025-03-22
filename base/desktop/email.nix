{
  home-manager.users.pascal.accounts.email.accounts.default = {
    address = "pdiehm8@gmail.com";
    primary = true;
    realName = "Pascal Diehm";
    thunderbird.enable = true;
    userName = "pdiehm8@gmail.com";

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
