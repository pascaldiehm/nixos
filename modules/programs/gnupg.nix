{ hmcfg, pkgs, ... }: {
  home-manager.users.pascal = {
    # Setup GnuPG
    programs.gpg = {
      enable = true;
      homedir = "${hmcfg.xdg.dataHome}/gnupg";
    };

    # Setup gpg-agent
    services.gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-qt;
    };
  };
}
