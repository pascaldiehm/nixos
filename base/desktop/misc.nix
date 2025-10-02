{
  home-manager.users.pascal.programs.git.signing = {
    key = "E85EB0566C779A2F";
    signByDefault = true;
  };

  nix.settings = {
    substituters = [ "http://bowser:5778" "http://bowser:5779" ];
    trusted-public-keys = [ "private-1:Rx2/kvQOl7bTeQLc9hq8jV+7mJZaPZv3see8QbcXSmI=" ];
  };
}
