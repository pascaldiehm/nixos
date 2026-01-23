{ pkgs, ... }: {
  home-manager.users.pascal = {
    programs.gpg = {
      enable = true;
      homedir = "/home/pascal/.local/share/gnupg";
    };

    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-tty;
    };
  };
}
