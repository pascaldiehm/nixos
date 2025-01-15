{ config, pkgs, ... }:
{
  sops.secrets.password.neededForUsers = true;

  users.users.pascal = {
    description = "Pascal Diehm";
    hashedPasswordFile = config.sops.secrets.password.path;
    home = "/home/pascal";
    ignoreShellProgramCheck = true;
    isNormalUser = true;
    shell = pkgs.zsh;
    uid = 1000;

    extraGroups = [
      "docker"
      "wheel"
    ];
  };
}
