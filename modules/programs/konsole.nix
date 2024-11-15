{ ... }: {
  home-manager.users.pascal = {
    xdg.stateFile.konsolestaterc.source = ../../resources/konsolestaterc;

    programs.konsole = {
      enable = true;
      extraConfig.KonsoleWindow.RememberWindowSize = false;
    };
  };
}
