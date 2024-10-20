{ config, pkgs, ... }: {
  # Create user
  users.users.pascal = {
    description = "Pascal Diehm";
    extraGroups = [ "wheel" "networkmanager" ];
    isNormalUser = true;
    uid = 1000;
  };

  # Link profile picture
  system.activationScripts.linkProfilePicture = ''
    mkdir -p -m 0775 /var/lib/AccountsService/icons
    ln -sf ${../../resources/profile.png} /var/lib/AccountsService/icons/pascal
  '';

  # Setup ZSH
  users.users.pascal.shell = pkgs.zsh;

  programs.zsh = {
    enable = true;
    shellInit = "export ZDOTDIR=\"$HOME/.config/zsh\"";
  };

  # Mount tmpfs in ~/Downloads
  systemd.mounts = [{
    description = "Mount tmpfs in ~/Downloads";
    type = "tmpfs";
    wantedBy = [ "multi-user.target" ];
    what = "tmpfs";
    where = "${config.home-manager.users.pascal.xdg.userDirs.download}";
  }];
}
