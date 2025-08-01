{
  nix.cache = "http://bowser:5779";

  home-manager.users.pascal.programs.git.signing = {
    key = "E85EB0566C779A2F";
    signByDefault = true;
  };
}
