{ pkgs, ... }: {
  boot.initrd.luks.devices.nixos.device = "/dev/disk/by-partlabel/nixos";
  fonts.packages = [ pkgs.fira-code ];

  home-manager.users.pascal.services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

  system.activationScripts.linkProfilePicture = ''
    mkdir -p /var/lib/AccountsService/icons
    ln -sf "${../../resources/profile.png}" /var/lib/AccountsService/icons/pascal
  '';
}
