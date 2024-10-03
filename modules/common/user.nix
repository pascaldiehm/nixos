{ pkgs, ... }: {
  # Create user
  users.users.pascal = {
    description = "Pascal Diehm";
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "pascal";
    isNormalUser = true;
    uid = 1000;
  };

  # Link profile picture
  system.activationScripts.profilePicture = ''
    mkdir -p -m 0775 /var/lib/AccountsService/icons
    ln -sf ${../../resources/profile.png} /var/lib/AccountsService/icons/pascal
  '';

  # Setup ZSH
  users.users.pascal.shell = pkgs.zsh;

  programs.zsh = {
    enable = true;
    shellInit = "export ZDOTDIR=\"$HOME/.config/zsh\"";
  };

  # Setup home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
