{
  services.logind.settings.Login.HandlePowerKey = "suspend";

  home-manager.users.pascal.programs.git.signing = {
    key = "E85EB0566C779A2F";
    signByDefault = true;
  };
}
