{ libx, ... }:
{
  home-manager.users.pascal.programs.firefox.profiles.default.bookmarks = libx.mkFirefoxBookmarks {
    "Uni Würzburg" = {
      GitLab = "https://gitlab.informatik.uni-wuerzburg.de";
      WueCampus = "https://wuecampus.uni-wuerzburg.de";
      WueStudy = "https://wuestudy.zv.uni-wuerzburg.de";
    };
  };
}
