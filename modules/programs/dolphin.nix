{ ... }: {
  home-manager.users.pascal.programs.plasma = {
    configFile.dolphinrc = {
      General.RememberOpenedTabs = false;
      IconsMode.PreviewSize = 80;
    };

    dataFile."dolphin/view_properties/global/.directory" = {
      Settings.HiddenFilesShown = true;
    };
  };
}
