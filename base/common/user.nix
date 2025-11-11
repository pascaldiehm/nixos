{ config, pkgs, ... }: {
  sops.common.password.neededForUsers = true;

  users = {
    mutableUsers = false;

    users.pascal = {
      description = "Pascal Diehm";
      extraGroups = [ "wheel" ];
      hashedPasswordFile = config.sops.common.password.path;
      ignoreShellProgramCheck = true;
      isNormalUser = true;
      shell = pkgs.zsh;
      uid = 1000;
    };
  };
}
