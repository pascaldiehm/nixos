{ pkgs, ... }: {
  home-manager.users.pascal = {
    programs.gpg = {
      enable = true;
      homedir = "/home/pascal/.local/share/gnupg";
      scdaemonSettings.disable-ccid = true;
    };

    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-tty;
    };
  };
}
