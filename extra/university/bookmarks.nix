{ lib, ... }:
{
  home-manager.users.pascal.programs.firefox.profiles.default.bookmarks = [
    {
      name = "Uni Würzburg";

      bookmarks = lib.mapAttrsToList (name: url: { inherit name url; }) {
        GitLab = "https://gitlab.informatik.uni-wuerzburg.de";
        WueCampus = "https://wuecampus.uni-wuerzburg.de";
        WueStudy = "https://wuestudy.zv.uni-wuerzburg.de";
      };
    }
  ];
}
