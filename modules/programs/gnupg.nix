{ hmcfg, pkgs, ... }: {
  home-manager.users.pascal = {
    programs.gpg = {
      enable = true;
      homedir = "${hmcfg.xdg.dataHome}/gnupg";
    };

    services.gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-qt;
    };
  };
}
