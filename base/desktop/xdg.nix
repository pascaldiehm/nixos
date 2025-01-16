{
  home-manager.users.pascal.xdg = {
    stateFile.konsolestaterc.source = ../../resources/konsolestaterc;

    userDirs = {
      enable = true;
      createDirectories = true;
      publicShare = null;
      templates = null;
    };
  };
}
