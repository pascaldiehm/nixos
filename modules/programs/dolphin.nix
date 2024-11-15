{ ... }: {
  home-manager.users.pascal.programs.plasma = {
    configFile.dolphinrc = {
      General.RememberOpenedTabs = true;
      IconsMode.PreviewSize = 80;
    };

    dataFile."dolphin/view_properties/global/.directory" = {
      Settings.HiddenFilesShown = true;
    };
  };
}
