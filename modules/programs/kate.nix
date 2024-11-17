{ ... }: {
  home-manager.users.pascal.programs.plasma.configFile.katerc = {
    General."Show welcome view for new window" = false;

    "KTextEditor Document" = {
      "Indentation Width" = 2;
      "Tab Width" = 2;
    };
  };
}
