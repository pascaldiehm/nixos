{
  home-manager.users.pascal.programs.git.signing = {
    key = "E85EB0566C779A2F";
    signByDefault = true;
  };

  nix.settings = {
    substituters = [ "http://bowser:5778" "http://bowser:5779" ];
    trusted-public-keys = [ "bowser:diwsWDb5oogaZJ5BwRrjtRWcwGPzppJhZkiIqgjIP+g=" ];
  };
}
