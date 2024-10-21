{ ... }: {
  home-manager.users.pascal.programs = {
    plasma.configFile.okularpartrc."Dlg Presentation".SlidesShowProgress = false;

    okular = {
      enable = true;
      accessibility.highlightLinks = true;
    };
  };
}
