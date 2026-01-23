{ lib, pkgs, ... }: {
  home-manager.users.pascal = {
    programs.gpg = {
      enable = true;
      homedir = "/home/pascal/.local/share/gnupg";

      publicKeys = lib.singleton {
        source = ../../resources/key.gpg;
        trust = "ultimate";
      };
    };

    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-tty;
    };
  };
}
