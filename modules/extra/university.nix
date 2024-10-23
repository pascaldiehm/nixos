{ helpers, ... }: {
  home-manager.users.pascal = {
    # Email address
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

    # Bookmarks
    programs.firefox.profiles.default.bookmarks = [
      (helpers.mkFirefoxBookmarksFolder "Uni Würzburg" {
        WueCampus = "https://wuecampus.uni-wuerzburg.de";
        WueStudy = "https://wuestudy.zv.uni-wuerzburg.de";
      })
    ];
  };
}
