{ pkgs, ... }: {
  fonts.packages = [ pkgs.fira-code ];

  system.activationScripts.linkProfilePicture = ''
    mkdir -p /var/lib/AccountsService/icons
    ln -sf "${../../resources/profile.png}" /var/lib/AccountsService/icons/pascal
  '';
}
