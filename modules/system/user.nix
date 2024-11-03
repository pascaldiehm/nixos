{ config, ... }: {
  sops.secrets.password.neededForUsers = true;

  system.activationScripts.linkProfilePicture = ''
    mkdir -p /var/lib/AccountsService/icons
    ln -sf ${../../resources/profile.png} /var/lib/AccountsService/icons/pascal
  '';

  users.users.pascal = {
    description = "Pascal Diehm";
    extraGroups = [ "wheel" ];
    hashedPasswordFile = config.sops.secrets.password.path;
    isNormalUser = true;
    uid = 1000;
  };
}
