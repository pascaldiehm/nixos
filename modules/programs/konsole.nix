{ ... }: {
  home-manager.users.pascal = {
    xdg.stateFile.konsolestaterc.source = ../../resources/konsolestaterc;

    programs.konsole = {
      enable = true;
      defaultProfile = "default";
      extraConfig.KonsoleWindow.RememberWindowSize = false;
      profiles.default.font.name = "Cascadia Code";
    };
  };
}
