{ lib, ... }: {
  home-manager.users.pascal.programs.firefox.profiles.default.bookmarks = lib.mkFirefoxBookmarks {
    "Uni Würzburg" = {
      GitLab = "https://gitlab.informatik.uni-wuerzburg.de";
      WueCampus = "https://wuecampus.uni-wuerzburg.de";
      WueStudy = "https://wuestudy.zv.uni-wuerzburg.de";
    };
  };
}
