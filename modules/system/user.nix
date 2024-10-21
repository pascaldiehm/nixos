{ config, ... }: {
  # Setup user
  users.users.pascal = {
    description = "Pascal Diehm";
    extraGroups = [ "wheel" ];
    hashedPasswordFile = config.sops.secrets.password.path;
    isNormalUser = true;
    uid = 1000;
  };

  # Enable password secret
  sops.secrets.password.neededForUsers = true;

  # Link profile picture
  system.activationScripts.linkProfilePicture = ''
    mkdir -p /var/lib/AccountsService/icons
    ln -sf ${../../resources/profile.png} /var/lib/AccountsService/icons/pascal
  '';
}
