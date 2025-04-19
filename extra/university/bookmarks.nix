{ lib, ... }: {
  home-manager.users.pascal.programs.firefox.profiles.default.bookmarks.settings = lib.mkFirefoxBookmarks {
    "Uni Würzburg" = {
      GitLab = "https://gitlab.informatik.uni-wuerzburg.de";
      "User Portal" = "https://user-portal.rz.uni-wuerzburg.de";
      "User Portal (IfI)" = "https://user.informatik.uni-wuerzburg.de";
      WueCampus = "https://wuecampus.uni-wuerzburg.de";
      WueStudy = "https://wuestudy.zv.uni-wuerzburg.de";
    };
  };
}
