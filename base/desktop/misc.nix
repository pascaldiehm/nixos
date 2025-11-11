{ config, ... }: {
  sops.secrets.password.neededForUsers = true;
  users.users.pascal.hashedPasswordFile = config.sops.secrets.password.path;

  home-manager.users.pascal.programs.git.signing = {
    key = "E85EB0566C779A2F";
    signByDefault = true;
  };
}
