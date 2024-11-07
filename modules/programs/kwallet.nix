{ ... }: {
  home-manager.users.pascal.programs.plasma.configFile.kwalletrc = {
    "Auto Allow".kdewallet = builtins.concatStringsSep "," [ "kded6" "KDE System" "kwalletmanager" "VSCodium" ];
    Wallet."Prompt on Open" = true;
  };
}
