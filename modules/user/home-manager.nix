{ config, ... }: {
  # Enable home-manager
  programs.home-manager.enable = true;

  # Setup home directory
  home = {
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "24.05";
    username = "pascal";
  };
}
