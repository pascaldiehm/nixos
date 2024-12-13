{ ... }: {
  home-manager.users.pascal.programs.plasma = {
    dataFile."dolphin/view_properties/global/.directory".Settings.HiddenFilesShown = true;

    configFile.dolphinrc = {
      General.RememberOpenedTabs = false;
      IconsMode.PreviewSize = 80;
    };
  };
}
