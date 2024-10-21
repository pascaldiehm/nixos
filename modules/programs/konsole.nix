{ ... }: {
  home-manager.users.pascal.programs.konsole = {
    enable = true;
    extraConfig.KonsoleWindow.RememberWindowSize = false;
  };
}
