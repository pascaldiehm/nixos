{ pkgs, ... }: {
  users = {
    mutableUsers = false;

    users.pascal = {
      description = "Pascal Diehm";
      extraGroups = [ "wheel" ];
      ignoreShellProgramCheck = true;
      isNormalUser = true;
      shell = pkgs.zsh;
      uid = 1000;
    };
  };
}
