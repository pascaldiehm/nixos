{ config, pkgs, ... }: {
  sops.secrets.password.neededForUsers = true;

  users.users.pascal = {
    description = "Pascal Diehm";
    extraGroups = [ "docker" "wheel" ];
    hashedPasswordFile = config.sops.secrets.password.path;
    ignoreShellProgramCheck = true;
    isNormalUser = true;
    shell = pkgs.zsh;
    uid = 1000;
  };
}
