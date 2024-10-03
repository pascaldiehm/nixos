{ ... }: {
  # Enable home-manager
  programs.home-manager.enable = true;

  # Setup home directory
  home = {
    homeDirectory = "/home/pascal";
    stateVersion = "24.05";
    username = "pascal";
  };
}
