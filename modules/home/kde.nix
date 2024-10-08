{ ... }: {
  # Dolphin
  programs.plasma.configFile.dolphinrc = {
    General.RememberOpenedTabs = false;
    IconsMode.PreviewSize = 80;
  };

  # Kate
  programs.plasma.configFile.katerc.General."Show welcome view for new window" = false;

  # Konsole
  programs.konsole = {
    enable = true;
    extraConfig.KonsoleWindow.RememberWindowSize = false;
  };

  # KWallet
  programs.plasma.configFile.kwalletrc = {
    "Auto Allow".kdewallet = builtins.concatStringsSep "," [ "kded6" "KDE System" "kwalletmanager" "Google Chrome" "Code" "Signal" ];
    Wallet."Prompt on Open" = true;
  };

  # Okular
  programs.plasma.configFile.okularpartrc."Dlg Presentation".SlidesShowProgress = false;

  programs.okular = {
    enable = true;
    accessibility.highlightLinks = true;
  };
}
